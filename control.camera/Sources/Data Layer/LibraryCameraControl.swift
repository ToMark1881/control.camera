//
//  LibraryCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 29.02.2024.
//

import Foundation

class LibraryCameraControl: CameraControl {
    
    var title: String {
        return "Open Library"
    }
    
    var controlType: ControlType {
        return .library
    }
    
    var valueType: CameraControlValueType!
    
    var isLightControl: Bool {
        return true
    }
    
    init(action: @escaping (() -> Void)) {
        self.valueType = .action(ActionControlValue(action: action))
    }
    
}
