//
//  CameraSettingsStorage.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 12.02.2024.
//

import Foundation

protocol CameraSettingsStorage {
    var flashControl: FlashCameraControl! { get }
    var formControl: FormCameraControl! { get }
    
    func store(_ control: CameraControl)
}

final class CameraSettingsStorageImplementation: CameraSettingsStorage {
    
    static let `default` = CameraSettingsStorageImplementation()
    
    var flashControl: FlashCameraControl!
    var formControl: FormCameraControl!
    
    func store(_ control: CameraControl) {
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
