//
//  CameraViewConfiguration.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol CameraViewConfiguration: AnyObject {
    func setupCameraLayer(_ layer: CALayer)
}
