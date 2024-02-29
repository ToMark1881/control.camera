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
    
    var type: CameraControlType
    
    var isLightControl: Bool {
        return true
    }
    
    init(action: @escaping (() -> Void)) {
        self.type = .action(ActionControlValue(action: action))
    }
    
}
