//
//  FormCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 13.02.2024.
//

import Foundation

class FormCameraControl: CameraControl {
    
    var title: String {
        return "Form"
    }
    
    var type: CameraControlType = .range(RangeControlValue(min: 0, max: 100, step: 10, selected: nil))
}

private extension FlashCameraControl {
    
    var controlValue: RangeControlValue {
        guard case let .range(value) = type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
    
}
