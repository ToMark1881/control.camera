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
    
    var valueType: CameraControlValueType! = .simple(SimpleControlValue(isActive: false))
    
    var flashMode: AVCaptureDevice.FlashMode {
        return controlValue.isActive ? .on : .off
    }
}

private extension FlashCameraControl {
    
    var controlValue: SimpleControlValue {
        guard case let .simple(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        return value
    }
    
}
