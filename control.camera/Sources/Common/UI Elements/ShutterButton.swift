//
//  ShutterButton.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class ShutterButton: BounceButton {
    
    override func shrinkAllowAnimation() {
        TapticEngineGenerator.shared.generateFeedback(.light)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.6),
                       initialSpringVelocity: CGFloat(25.0),
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
    
    override func restoreAllowAnimation() {
        TapticEngineGenerator.shared.generateFeedback(.medium)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.6),
                       initialSpringVelocity: CGFloat(10.0),
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
                        self.transform = CGAffineTransform.identity
        })
    }
    
    override func shrink() {
        if isCurrentOutside == true {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.6),
                           initialSpringVelocity: CGFloat(15.0),
                           options: [.curveEaseOut],
                           animations: {
                            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: { _ in self.isCurrentOutside = false})
        }
    }
}
