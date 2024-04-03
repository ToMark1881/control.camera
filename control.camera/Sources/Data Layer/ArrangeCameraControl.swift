//
//  ArrangeCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 20.03.2024.
//

import Foundation

class ArrangeCameraControl: CameraControl {
    
    var controlType: ControlType {
        return .arrange
    }
    
    var arrangementModeTitle: String {
        return "Save\nArrange"
    }
    
    var valueType: CameraControlValueType!
    
    var shouldBeBlockedDuringArrangement: Bool {
        return false
    }
    
    var couldBeArranged: Bool {
        return false
    }
    
    init(action: @escaping (() -> Void)) {
        self.valueType = .action(ActionControlValue(action: action))
    }
    
}
