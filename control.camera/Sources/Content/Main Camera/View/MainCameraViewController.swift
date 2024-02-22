//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class CameraContainerView: UIView {
    
    var cameraLayer: CALayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
    }
    
}

class MainCameraViewController: BaseViewController {
    
    // MARK: - Injected
    
    var output: MainCameraViewOutputProtocol!

    @IBOutlet weak var cameraContainerContainer: UIView!
    @IBOutlet weak var cameraContainerView: CameraContainerView!
    @IBOutlet weak var flashView: UIView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var controlsContainerView: UIView!
    @IBOutlet weak var shutterButton: ShutterButton!
    
    @IBOutlet weak var cameraContainerAspectRatioConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.onViewDidLoad()
    }

    @IBAction func didTapOnShutterButton(_ sender: Any) {
        output.didTapOnShutter()
    }
}

extension MainCameraViewController: MainCameraViewInputProtocol {

}

extension MainCameraViewController: CameraViewConfiguration {
    
    func setupCameraLayer(_ layer: CALayer) {
        cameraContainerView.layer.addSublayer(layer)
        cameraContainerView.cameraLayer = layer
        layer.frame = cameraContainerView.layer.frame
        
        view.bringSubviewToFront(shutterButton)
        view.bringSubviewToFront(controlsContainerView)
        
        output.didSetupCameraLayer()
        shutterButton.isEnabled = true
    }
    
}
