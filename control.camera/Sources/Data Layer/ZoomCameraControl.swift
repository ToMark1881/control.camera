//
//  ZoomCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 25.02.2024.
//

import Foundation

class ZoomCameraControl: CameraControl {
    
    var title: String {
        return "Zoom"
    }
    
    var isLightControl: Bool {
        return true
    }
    
    var elementHeight: CGFloat? {
        return 20.0
    }
    
    var type: CameraControlType!
    
    init(min: CGFloat, max: CGFloat, step: CGFloat, selected: CGFloat?) {
        let rangeControlValue = RangeControlValue(min: min, max: max, step: step, selected: selected)
        self.type = .range(rangeControlValue)
    }
    
}

extension ZoomCameraControl {
    
    var controlValue: RangeControlValue {
        guard case let .range(value) = type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
    
}
