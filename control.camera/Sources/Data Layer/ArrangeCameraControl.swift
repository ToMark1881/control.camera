//
//  ArrangeCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 20.03.2024.
//

import Foundation

class ArrangeCameraControl: CameraControl {
    
    var title: String {
        return "Arrange"
    }
    
    var controlType: ControlType {
        return .arrange
    }
    
    var valueType: CameraControlValueType!
    
    var isLightControl: Bool {
        return true
    }
    
    init(action: @escaping (() -> Void)) {
        self.valueType = .action(ActionControlValue(action: action))
    }
    
}
