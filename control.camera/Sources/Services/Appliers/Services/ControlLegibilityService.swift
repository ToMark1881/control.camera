//
//  ControlLegibilityService.swift
//  control.camera
//

import Foundation
import CoreImage
import QuartzCore

protocol ControlLegibilityService: AnyObject {
    /// Called on the main thread when the on-screen controls layout changes.
    /// Regions are normalized (0...1) rects in the camera container space,
    /// UIKit coordinates, keyed by the control grid index
    func update(regions: [Int: CGRect])

    /// Whether enough time has passed since the previous sample.
    /// Lets the caller skip composing the sampling image entirely
    var isSampleDue: Bool { get }

    /// Samples the composed container-space image and reports which
    /// controls sit on a light background. Called on the video queue
    func process(containerImage: CIImage)

    /// Reported on the main thread with grid indexes mapped to
    /// "is on light background"
    var onLegibilityChange: (([Int: Bool]) -> Void)? { get set }
}

class ControlLegibilityServiceImplementation: ControlLegibilityService {

    private enum Constants {
        static let samplingInterval: CFTimeInterval = 0.25
        /// Hysteresis: text turns black above the upper threshold and
        /// back to white below the lower one, so borderline scenes
        /// do not make the text flicker
        static let lightEnterLuminance: CGFloat = 0.6
        static let lightExitLuminance: CGFloat = 0.45
    }

    var onLegibilityChange: (([Int: Bool]) -> Void)?

    var isSampleDue: Bool {
        return CACurrentMediaTime() - lastSampleTime >= Constants.samplingInterval
    }

    private let stateLock = NSLock()
    private var regions = [Int: CGRect]()
    private var lightIndexes = [Int: Bool]()
    private var lastSampleTime: CFTimeInterval = 0

    private let ciContext = CIContext(options: [.workingColorSpace: NSNull()])
    private let outputColorSpace = CGColorSpaceCreateDeviceRGB()

    func update(regions: [Int: CGRect]) {
        stateLock.lock()
        self.regions = regions
        stateLock.unlock()
    }

    func process(containerImage: CIImage) {
        guard isSampleDue else { return }
        lastSampleTime = CACurrentMediaTime()

        stateLock.lock()
        let regions = self.regions
        let previous = self.lightIndexes
        stateLock.unlock()

        guard !regions.isEmpty else { return }

        var updated = [Int: Bool]()
        let extent = containerImage.extent

        for (index, region) in regions {
            let luminance = averageLuminance(of: containerImage, in: roi(for: region, in: extent))
            let wasLight = previous[index] ?? false
            let threshold = wasLight ? Constants.lightExitLuminance : Constants.lightEnterLuminance

            updated[index] = luminance > threshold
        }

        guard updated != previous else { return }

        stateLock.lock()
        lightIndexes = updated
        stateLock.unlock()

        DispatchQueue.main.async { [weak self] in
            self?.onLegibilityChange?(updated)
        }
    }

}

private extension ControlLegibilityServiceImplementation {

    /// Normalized UIKit rect (top-left origin) -> Core Image ROI
    /// (bottom-left origin) within the image extent
    func roi(for region: CGRect, in extent: CGRect) -> CGRect {
        let x = extent.minX + region.minX * extent.width
        let y = extent.minY + (1.0 - region.maxY) * extent.height
        let width = region.width * extent.width
        let height = region.height * extent.height

        return CGRect(x: x, y: y, width: width, height: height)
            .intersection(extent)
    }

    func averageLuminance(of image: CIImage, in roi: CGRect) -> CGFloat {
        guard !roi.isEmpty else { return 0 }

        let average = image.applyingFilter("CIAreaAverage",
                                           parameters: [kCIInputExtentKey: CIVector(cgRect: roi)])

        var pixel = [UInt8](repeating: 0, count: 4)
        ciContext.render(average,
                         toBitmap: &pixel,
                         rowBytes: 4,
                         bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                         format: .RGBA8,
                         colorSpace: outputColorSpace)

        return relativeLuminance(red: CGFloat(pixel[0]) / 255.0,
                                 green: CGFloat(pixel[1]) / 255.0,
                                 blue: CGFloat(pixel[2]) / 255.0)
    }

    /// WCAG relative luminance of an sRGB color
    func relativeLuminance(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
        return 0.2126 * linearized(red) + 0.7152 * linearized(green) + 0.0722 * linearized(blue)
    }

    func linearized(_ channel: CGFloat) -> CGFloat {
        if channel <= 0.03928 {
            return channel / 12.92
        }

        return pow((channel + 0.055) / 1.055, 2.4)
    }

}
