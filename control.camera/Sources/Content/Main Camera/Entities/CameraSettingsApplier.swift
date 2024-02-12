//
//  CameraSettingsApplier.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 12.02.2024.
//

import Foundation

protocol CameraSettingsApplier {
    var flashControl: FlashCameraControl! { get }
    
    func apply(_ control: CameraControl)
}

final class CameraSettingsApplierImplementation: CameraSettingsApplier {
    
    static let `default` = CameraSettingsApplierImplementation()
    
    var flashControl: FlashCameraControl!
    
    func apply(_ control: CameraControl) {
        switch control {
        case is FlashCameraControl:
            flashControl = control as? FlashCameraControl
        default:
            break
        }
    }
    
}
