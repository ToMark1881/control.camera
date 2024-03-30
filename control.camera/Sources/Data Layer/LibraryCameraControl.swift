//
//  LibraryCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 29.02.2024.
//

import Foundation

class LibraryCameraControl: CameraControl {
    
    var controlType: ControlType {
        return .library
    }
    
    var valueType: CameraControlValueType!
    
    init(action: @escaping (() -> Void)) {
        self.valueType = .action(ActionControlValue(action: action))
    }
    
}
