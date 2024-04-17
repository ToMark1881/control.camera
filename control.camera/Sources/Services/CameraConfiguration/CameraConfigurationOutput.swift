//
//  CameraConfigurationOutput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

protocol CameraConfigurationOutput: AnyObject {
    func didChangeInputDevice()
    func didChangePhotoFormat()
    
    func didSetAutoISO()
    func didSetAutoExposure()
    
    func willCapture()
    func didCapture()
}
