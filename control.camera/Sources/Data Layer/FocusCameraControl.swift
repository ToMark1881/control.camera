//
//  FocusCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 29.02.2024.
//

import Foundation

enum FocusType {
    case auto
    case locked(lensPosition: CGFloat)
}

class FocusCameraControl: CameraControl {
    
    var title: String {
        return "Focus"
    }
    
    var type: CameraControlType
    
    var isLightControl: Bool {
        return true
    }
    
    init(min: CGFloat, max: CGFloat, focus: FocusType) {
        var lensPosition: CGFloat?
        
        if case .locked(let lens) = focus {
            lensPosition = lens
        }
        
        let range = RangeControlValue(min: min, max: max, step: 0.01, selected: lensPosition)
        self.type = .rangeWithDefault(RangeWithDefaultValue(defaultValue: "Auto", range: range))
    }
    
}
