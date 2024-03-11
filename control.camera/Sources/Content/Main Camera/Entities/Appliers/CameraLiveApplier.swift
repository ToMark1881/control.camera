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
        case is ZoomCameraControl:
            applyZoomControl(control as? ZoomCameraControl)
        case is ShowUICameraControl:
            applyUIControl(control as? ShowUICameraControl)
        case is FocusCameraControl:
            applyFocusControl(control as? FocusCameraControl)
        case is ExposureCameraControl:
            applyExposureControl(control as? ExposureCameraControl)
        case is ISOCameraControl:
            applyISOControl(control as? ISOCameraControl)
        case is WhiteBalanceCameraControl:
            applyWhiteBalanceControl(control as? WhiteBalanceCameraControl)
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
    
    func applyZoomControl(_ control: ZoomCameraControl?) {
        guard let selectedValue = control?.controlValue.selected else {
            return
        }
        
        camera.setZoomFactor(selectedValue)
    }
    
    func applyUIControl(_ control: ShowUICameraControl?) {
        guard let isActive = control?.controlValue.isActive else {
            return
        }
        
        view.showControlContainer(isActive)
    }
    
    func applyFocusControl(_ control: FocusCameraControl?) {
        guard let control = control else {
            return
        }
        
        switch control.focusType {
        case .auto:
            camera.setAutoFocus()
            
        case .locked(let lensPosition):
            camera.setLockedFocus(with: lensPosition)
        }
    }
    
    func applyExposureControl(_ control: ExposureCameraControl?) {
        guard let control = control else {
            return
        }
        
        switch control.exposureType {
        case .auto:
            camera.setAutoExposure()
        case .locked(let duration):
            camera.setCustomExposure(duration)
        }
    }
    
    func applyISOControl(_ control: ISOCameraControl?) {
        guard let control = control else {
            return
        }
        
        switch control.isoType {
        case .auto:
            camera.setAutoISO()
        case .locked(let iso):
            camera.setCustomISO(iso)
        }
    }
    
    func applyWhiteBalanceControl(_ control: WhiteBalanceCameraControl?) {
        guard let control = control else {
            return
        }
        
        switch control.whiteBalanceType {
        case .auto:
            camera.setAutoWhiteBalance()
        case .locked(let kelvinTemp):
            camera.setCustomWhiteBalance(kelvinTemp)
        }
    }
    
}
