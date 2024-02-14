//
//  CameraSettingsApplier.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 12.02.2024.
//

import Foundation

protocol CameraSettingsApplier {
    var flashControl: FlashCameraControl! { get }
    var formControl: FormCameraControl! { get }
    
    func apply(_ control: CameraControl)
}

final class CameraSettingsApplierImplementation: CameraSettingsApplier {
    
    static let `default` = CameraSettingsApplierImplementation()
    
    var flashControl: FlashCameraControl!
    var formControl: FormCameraControl!
    
    func apply(_ control: CameraControl) {
        switch control {
        case is FlashCameraControl:
            flashControl = control as? FlashCameraControl
        case is FormCameraControl:
            formControl = control as? FormCameraControl
        default:
            break
        }
    }
    
}
