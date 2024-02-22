//
//  CameraViewConfiguration.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol CameraViewConfiguration where Self: BaseViewControllerProtocol {
    
    var cameraContainerView: UIView! { get set }
    var cameraContainerAspectRatioConstraint: NSLayoutConstraint! { get set }
    
    func setupCameraLayer(_ layer: CALayer)
}
