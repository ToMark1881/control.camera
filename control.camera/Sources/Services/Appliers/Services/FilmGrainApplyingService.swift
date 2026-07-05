//
//  FilmGrainApplyingService.swift
//  control.camera
//

import Foundation
import CoreImage

protocol FilmGrainApplyingService {
    /// Overlays monochrome film grain on the image.
    /// - Parameters:
    ///   - intensity: grain strength, 0...1
    ///   - grainSize: grain particle scale multiplier, 1 is the finest
    func applyGrain(to image: CIImage, intensity: CGFloat, grainSize: CGFloat) -> CIImage
}

class FilmGrainApplyingServiceImplementation: FilmGrainApplyingService {

    private enum Constants {
        /// The shorter image side is divided by this value to get the base
        /// grain particle size, so the grain scales with sensor resolution
        static let referenceSideDivider: CGFloat = 1500.0
        /// Max deviation from neutral gray at intensity 1.0
        static let maxAmplitude: CGFloat = 0.5
        /// Blur radius per unit of grain scale, makes clumps look organic
        static let softeningPerScaleUnit: CGFloat = 0.4
        /// CIRandomGenerator is a static 512x512 tile, so every capture
        /// gets a random offset to avoid the same visible pattern
        static let noiseTileSide: CGFloat = 512.0
    }

    func applyGrain(to image: CIImage, intensity: CGFloat, grainSize: CGFloat) -> CIImage {
        guard intensity > 0 else {
            return image
        }

        guard let noise = CIFilter(name: "CIRandomGenerator")?.outputImage else {
            return image
        }

        let extent = image.extent

        // Grain particle size relative to the image resolution
        let baseScale = max(min(extent.width, extent.height) / Constants.referenceSideDivider, 1.0)
        let scale = baseScale * max(grainSize, 1.0)

        let offsetX = CGFloat.random(in: 0...Constants.noiseTileSide)
        let offsetY = CGFloat.random(in: 0...Constants.noiseTileSide)

        var grain = noise
            .transformed(by: CGAffineTransform(scaleX: scale, y: scale))
            .transformed(by: CGAffineTransform(translationX: offsetX, y: offsetY))

        // Film grain is density (luma) noise, not per-channel color noise
        grain = grain.applyingFilter("CIColorControls",
                                     parameters: [kCIInputSaturationKey: 0.0])

        // Soften the noise so grains read as organic clumps
        grain = grain.applyingFilter("CIGaussianBlur",
                                     parameters: [kCIInputRadiusKey: scale * Constants.softeningPerScaleUnit])

        // Re-center the noise around neutral gray with the requested
        // amplitude: out = 0.5 + amplitude * (noise - 0.5). Neutral gray is
        // an identity for soft light, so deviations become the grain
        let amplitude = intensity * Constants.maxAmplitude
        let bias = 0.5 * (1.0 - amplitude)

        grain = grain.applyingFilter("CIColorMatrix", parameters: [
            "inputRVector": CIVector(x: amplitude, y: 0, z: 0, w: 0),
            "inputGVector": CIVector(x: 0, y: amplitude, z: 0, w: 0),
            "inputBVector": CIVector(x: 0, y: 0, z: amplitude, w: 0),
            "inputAVector": CIVector(x: 0, y: 0, z: 0, w: 0),
            "inputBiasVector": CIVector(x: bias, y: bias, z: bias, w: 1.0)
        ])

        grain = grain.cropped(to: extent)

        // Soft light keeps deep shadows and blown highlights intact and
        // peaks in the midtones, matching how real film grain reads
        return grain.applyingFilter("CISoftLightBlendMode",
                                    parameters: [kCIInputBackgroundImageKey: image])
    }

}
