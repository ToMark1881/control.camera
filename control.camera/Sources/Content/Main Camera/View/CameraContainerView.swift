//
//  CameraContainerView.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 23.02.2024.
//

import UIKit

class CameraContainerView: UIView {

    private enum CaptureAnimation {
        static let flashDuration: CFTimeInterval = 0.3
        static let flashPeakOpacity: Double = 0.4
    }

    var cameraLayer: CALayer?

    private var flashLayer: CALayer?

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutCaptureAnimationLayers()

        #if !targetEnvironment(simulator)

        // The camera layer is attached asynchronously after the session is
        // configured and is never attached if configuration fails (e.g. camera
        // permission denied), so layout passes must tolerate its absence
        guard let cameraLayer = cameraLayer, cameraLayer.superlayer == layer else { return }

        // If the view is animating apply the animation to the sublayer
        CATransaction.begin()
        if let animation = layer.animation(forKey: "position") {
            CATransaction.setAnimationDuration(animation.duration)
            CATransaction.setAnimationTimingFunction(animation.timingFunction)
        } else {
            CATransaction.disableActions()
        }

        cameraLayer.frame = bounds

        CATransaction.commit()
        #endif
    }
    
    func setCaptureAnimation(active: Bool) {
        if active {
            playFlash()
        }
    }

}

// MARK: - Capture animation
private extension CameraContainerView {

    func playFlash() {
        flashLayer?.removeFromSuperlayer()

        let flash = CALayer()
        flash.frame = bounds
        flash.backgroundColor = UIColor.white.cgColor
        flash.opacity = 0.0
        layer.addSublayer(flash)
        flashLayer = flash

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self, weak flash] in
            flash?.removeFromSuperlayer()

            if let self = self, let flash = flash, self.flashLayer === flash {
                self.flashLayer = nil
            }
        }

        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.values = [0.0, CaptureAnimation.flashPeakOpacity, 0.0]
        animation.keyTimes = [0.0, 0.3, 1.0]
        animation.duration = CaptureAnimation.flashDuration
        flash.add(animation, forKey: "flash")

        CATransaction.commit()
    }
    
    func layoutCaptureAnimationLayers() {
        guard flashLayer != nil else { return }

        CATransaction.begin()
        CATransaction.disableActions()

        flashLayer?.frame = bounds

        CATransaction.commit()
    }

}
