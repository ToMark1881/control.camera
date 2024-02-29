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
    
    var type: CameraControlType {
        didSet {
            if let selected = controlValue.range.selected {
                focusType = .locked(lensPosition: selected)
            } else {
                focusType = .auto
            }
        }
    }
    
    var isLightControl: Bool {
        return true
    }
    
    var focusType: FocusType
    
    init(min: CGFloat, max: CGFloat, focus: FocusType) {
        var lensPosition: CGFloat?
        
        if case .locked(let lens) = focus {
            lensPosition = lens
        }
        
        let range = RangeControlValue(min: min, max: max, step: 0.01, selected: lensPosition)
        self.type = .rangeWithDefault(RangeWithDefaultControlValue(defaultValue: "Auto", range: range))
        self.focusType = focus
    }
    
}

extension FocusCameraControl {
    
    var controlValue: RangeWithDefaultControlValue {
        guard case let .rangeWithDefault(value) = type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
    
}
