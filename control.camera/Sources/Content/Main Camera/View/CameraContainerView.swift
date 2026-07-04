//
//  CameraContainerView.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 23.02.2024.
//

import UIKit

class CameraContainerView: UIView {
    
    var cameraLayer: CALayer?

    override func layoutSubviews() {
        super.layoutSubviews()

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
    
}
