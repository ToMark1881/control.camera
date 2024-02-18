//
//  FormCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 13.02.2024.
//

import Foundation

class FormCameraControl: CameraControl {
    
    enum PhotoAspectRatio {
        case sixteenByNine
        case fourByThree
        case oneByOne
    }
    
    var title: String {
        return "Form"
    }
    
    var type: CameraControlType = .range(RangeControlValue(min: 0, max: 100, step: 1, selected: nil))
    
    var aspectRatio: PhotoAspectRatio {
        guard let value = controlValue.selected else {
            return .sixteenByNine
        }
        
        let mod = value % 3
        switch mod {
        case 0:
            return .oneByOne
        case 1:
            return .fourByThree
        case 2:
            return .sixteenByNine
        default:
            return .sixteenByNine
        }
    }
}

private extension FormCameraControl {
    
    var controlValue: RangeControlValue {
        guard case let .range(value) = type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
    
}
