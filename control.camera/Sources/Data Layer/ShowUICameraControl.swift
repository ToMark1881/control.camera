//
//  ShowUICameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 29.02.2024.
//

import Foundation

class ShowUICameraControl: CameraControl {
    
    var title: String {
        return "UI"
    }
    
    var controlType: ControlType {
        return .ui
    }
    
    var valueType: CameraControlValueType! = .simple(SimpleControlValue(isActive: true))
    
    var isLightControl: Bool {
        return true
    }
    
    var controlValue: SimpleControlValue {
        guard case let .simple(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        return value
    }
    
}
