//
//  CameraLiveApplier.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 22.02.2024.
//

import UIKit

protocol CameraLiveApplier {
    func applyControlIfNeeded(_ control: CameraControl)
}

class CameraLiveApplierImplementation: CameraLiveApplier {
    
    weak var view: CameraViewConfiguration!
    weak var camera: CameraConfiguration!
    
    func applyControlIfNeeded(_ control: CameraControl) {
        switch control {
        case is FormCameraControl:
            applyFormControl(control as? FormCameraControl)
        case is VideoDeviceCameraControl:
            applyDeviceControl(control as? VideoDeviceCameraControl)
        default:
            break
        }
    }
    
}

private extension CameraLiveApplierImplementation {
    
    func applyFormControl(_ control: FormCameraControl?) {
        guard let control = control else {
            return
        }
        
        let updatedAspectRatio = control.aspectRatio.aspectRatio
        let updatedFormConstraint = view.cameraContainerAspectRatioConstraint.constraintWithMultiplier(updatedAspectRatio)
        view.cameraContainerView.removeConstraint(view.cameraContainerAspectRatioConstraint)
        view.cameraContainerView.addConstraint(updatedFormConstraint)
        view.cameraContainerAspectRatioConstraint = updatedFormConstraint
        
        UIView.animate(withDuration: 0.3) {
            self.view.view.layoutIfNeeded()
        }
    }
    
    func applyDeviceControl(_ control: VideoDeviceCameraControl?) {
        guard let selectedDevice = control?.selectedDevice else {
            return
        }
        
        camera.changeDevice(selectedDevice.type)
    }
    
}
