//
//  FlashCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 12.02.2024.
//

import Foundation
import AVFoundation

class FlashCameraControl: CameraControl {
    
    var title: String {
        return "Light"
    }
    
    var isLightControl: Bool {
        return true
    }
    
    var type: CameraControlType = .simple(SimpleControlValue(isActive: false))
    
    var flashMode: AVCaptureDevice.FlashMode {
        return controlValue.isActive ? .on : .off
    }
}

private extension FlashCameraControl {
    
    var controlValue: SimpleControlValue {
        guard case let .simple(value) = type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
    
}
