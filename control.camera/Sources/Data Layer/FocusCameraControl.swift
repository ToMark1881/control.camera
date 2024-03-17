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
    
    var valueType: CameraControlValueType! {
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
    
    var elementHeight: CGFloat? {
        return 6.0
    }
    
    var defaultIndex: Range<Int>.Index? {
        return controlValue.range.range.firstIndex(where: { $0 == 0.5 })
    }
    
    var focusType: FocusType
    
    init(min: CGFloat, max: CGFloat, focus: FocusType) {
        var lensPosition: CGFloat?
        
        if case .locked(let lens) = focus {
            lensPosition = lens
        }
        
        let range = RangeControlValue(min: min, max: max, step: 0.01, selected: lensPosition)
        self.valueType = .rangeWithDefault(RangeWithDefaultControlValue(defaultValue: "Auto", range: range))
        self.focusType = focus
    }
    
}

extension FocusCameraControl {
    
    var controlValue: RangeWithDefaultControlValue {
        guard case let .rangeWithDefault(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        return value
    }
    
}
