//
//  CameraContainerView.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 23.02.2024.
//

import UIKit

class CameraContainerView: UIView {
    
    var cameraLayer: CALayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        #if !targetEnvironment(simulator)
        
        // If the view is animating apply the animation to the sublayer
        CATransaction.begin()
        if let animation = layer.animation(forKey: "position") {
            CATransaction.setAnimationDuration(animation.duration)
            CATransaction.setAnimationTimingFunction(animation.timingFunction)
        } else {
            CATransaction.disableActions()
        }
        
        if cameraLayer.superlayer == layer {
            cameraLayer.frame = bounds
        }
        
        CATransaction.commit()
        #endif
    }
    
}
