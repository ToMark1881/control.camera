//
//  FrameApplyingService.swift
//  control.camera
//

import Foundation
import CoreImage

protocol FrameApplyingService {
    /// Adds a solid border around the image by extending the canvas.
    /// `relativeWidth` is the border thickness as a percent of the shorter image side
    func applyFrame(to image: CIImage, relativeWidth: CGFloat, color: CGColor) -> CIImage
}

class FrameApplyingServiceImplementation: FrameApplyingService {

    func applyFrame(to image: CIImage, relativeWidth: CGFloat, color: CGColor) -> CIImage {
        guard relativeWidth > 0 else {
            return image
        }

        let extent = image.extent
        let borderWidth = (min(extent.width, extent.height) * relativeWidth / 100.0).rounded()
        let backgroundRect = extent.insetBy(dx: -borderWidth, dy: -borderWidth)
        let background = CIImage(color: CIColor(cgColor: color)).cropped(to: backgroundRect)

        return image.composited(over: background)
    }

}
