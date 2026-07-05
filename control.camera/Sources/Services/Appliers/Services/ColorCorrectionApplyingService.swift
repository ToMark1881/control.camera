//
//  ColorCorrectionApplyingService.swift
//  control.camera
//

import Foundation
import CoreImage

struct CurveColorCorrection {
    /// All values are normalized to -1...1, 0 is neutral
    let contrast: CGFloat
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat

    var isNeutral: Bool {
        return contrast == 0 && red == 0 && green == 0 && blue == 0
    }
}

protocol ColorCorrectionApplyingService {
    func applyCorrection(_ correction: CurveColorCorrection, to image: CIImage) -> CIImage
    func applyMonochrome(to image: CIImage) -> CIImage
}

class ColorCorrectionApplyingServiceImplementation: ColorCorrectionApplyingService {

    private enum Constants {
        /// Max vertical shift of the S-curve quarter points at |contrast| == 1
        static let maxContrastShift: CGFloat = 0.12
        /// Midtone parabola strength at |channel| == 1,
        /// lifts the curve at 0.5 by maxChannelLift / 4
        static let maxChannelLift: CGFloat = 0.6
    }

    func applyCorrection(_ correction: CurveColorCorrection, to image: CIImage) -> CIImage {
        guard !correction.isNeutral else {
            return image
        }

        var result = image
        result = applyContrastCurve(correction.contrast, to: result)
        result = applyChannelCurves(red: correction.red,
                                    green: correction.green,
                                    blue: correction.blue,
                                    to: result)

        return result
    }

    /// Neutral luminance-preserving black and white conversion. Applied
    /// after the curves, so the channel controls act like classic color
    /// filters in monochrome photography (e.g. boosting red darkens the sky)
    func applyMonochrome(to image: CIImage) -> CIImage {
        return image.applyingFilter("CIColorControls",
                                    parameters: [kCIInputSaturationKey: 0.0])
    }

}

private extension ColorCorrectionApplyingServiceImplementation {

    /// Classic S-curve: the black and white points stay locked, shadows are
    /// pulled down and highlights pushed up (or the reverse for negative
    /// values). The spline pivots around the 0.5 midpoint, so the perceived
    /// exposure is preserved
    func applyContrastCurve(_ contrast: CGFloat, to image: CIImage) -> CIImage {
        guard contrast != 0 else {
            return image
        }

        let shift = contrast * Constants.maxContrastShift

        return image.applyingFilter("CIToneCurve", parameters: [
            "inputPoint0": CIVector(x: 0.0, y: 0.0),
            "inputPoint1": CIVector(x: 0.25, y: clamped(0.25 - shift)),
            "inputPoint2": CIVector(x: 0.5, y: 0.5),
            "inputPoint3": CIVector(x: 0.75, y: clamped(0.75 + shift)),
            "inputPoint4": CIVector(x: 1.0, y: 1.0)
        ])
    }

    /// Midtone curve per channel: y = x + k * x * (1 - x). The endpoints
    /// stay fixed (y(0) = 0, y(1) = 1), so lifting a channel does not shift
    /// the black point or clip the highlights. Expressed as the polynomial
    /// coefficients (0, 1 + k, -k, 0) for CIColorPolynomial
    func applyChannelCurves(red: CGFloat,
                            green: CGFloat,
                            blue: CGFloat,
                            to image: CIImage) -> CIImage {
        guard red != 0 || green != 0 || blue != 0 else {
            return image
        }

        return image.applyingFilter("CIColorPolynomial", parameters: [
            "inputRedCoefficients": midtoneCoefficients(for: red),
            "inputGreenCoefficients": midtoneCoefficients(for: green),
            "inputBlueCoefficients": midtoneCoefficients(for: blue),
            "inputAlphaCoefficients": CIVector(x: 0, y: 1, z: 0, w: 0)
        ])
    }

    func midtoneCoefficients(for level: CGFloat) -> CIVector {
        let strength = level * Constants.maxChannelLift

        return CIVector(x: 0, y: 1 + strength, z: -strength, w: 0)
    }

    func clamped(_ value: CGFloat) -> CGFloat {
        return min(max(value, 0.0), 1.0)
    }

}
