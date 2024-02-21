//
//  UIImage+Cropping.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.02.2024.
//

import UIKit

extension UIImage {
    /// Crop the image to be the required size.
    ///
    /// - parameter bounds:    The bounds to which the new image should be cropped.
    ///
    /// - returns:             Cropped `UIImage`.

    func cropping(to bounds: CGRect) -> UIImage? {
        // if bounds is entirely within image, do simple CGImage `cropping` …

        if CGRect(origin: .zero, size: size).contains(bounds),
            imageOrientation == .up,
            let cropped = cgImage?.cropping(to: bounds * scale)
        {
            return UIImage(cgImage: cropped, scale: scale, orientation: imageOrientation)
        }

        // … otherwise, manually render whole image, only drawing what we need

        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        format.scale = scale

        return UIGraphicsImageRenderer(size: bounds.size, format: format).image { _ in
            let origin = CGPoint(x: -bounds.minX, y: -bounds.minY)
            draw(in: CGRect(origin: origin, size: size))
        }
    }
}
