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
    var deviceControl: VideoDeviceCameraControl! { get }
    var zoomControl: ZoomCameraControl! { get }
    var focusControl: FocusCameraControl! { get }
    var exposureControl: ExposureCameraControl! { get }
    var isoControl: ISOCameraControl! { get }
    
    func store(_ control: CameraControl)
}

final class CameraSettingsStorageImplementation: CameraSettingsStorage {
    
    static let `default` = CameraSettingsStorageImplementation()
    
    var flashControl: FlashCameraControl!
    var formControl: FormCameraControl!
    var deviceControl: VideoDeviceCameraControl!
    var zoomControl: ZoomCameraControl!
    var focusControl: FocusCameraControl!
    var exposureControl: ExposureCameraControl!
    var isoControl: ISOCameraControl!
    
    func store(_ control: CameraControl) {
        switch control {
        case is FlashCameraControl:
            flashControl = control as? FlashCameraControl
        case is FormCameraControl:
            formControl = control as? FormCameraControl
        case is VideoDeviceCameraControl:
            deviceControl = control as? VideoDeviceCameraControl
        case is ZoomCameraControl:
            zoomControl = control as? ZoomCameraControl
        case is FocusCameraControl:
            focusControl = control as? FocusCameraControl
        case is ExposureCameraControl:
            exposureControl = control as? ExposureCameraControl
        case is ISOCameraControl:
            isoControl = control as? ISOCameraControl
        default:
            break
        }
    }
    
}
