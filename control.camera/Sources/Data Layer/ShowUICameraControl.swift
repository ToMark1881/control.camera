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
    
    var type: CameraControlType = .simple(SimpleControlValue(isActive: true))
    
    var isLightControl: Bool {
        return true
    }
    
    var controlValue: SimpleControlValue {
        guard case let .simple(value) = type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
    
}
