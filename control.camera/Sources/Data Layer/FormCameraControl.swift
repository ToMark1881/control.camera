//
//  FormCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 13.02.2024.
//

import Foundation

class FormCameraControl: CameraControl {
    
    enum PhotoAspectRatio: String {
        case fourByThree = "4:3"
        case oneByOne = "1:1"
        case sixteenByNine = "16:9"
        case sixteenByTen = "16:10"
    }
    
    var title: String {
        return "Form"
    }
    
    var type: CameraControlType = .array(ArrayControlValue(array: [PhotoAspectRatio.fourByThree.rawValue,
                                                                   PhotoAspectRatio.oneByOne.rawValue,
                                                                   PhotoAspectRatio.sixteenByNine.rawValue,
                                                                   PhotoAspectRatio.sixteenByTen.rawValue],
                                                           selected: nil))
    
    var aspectRatio: PhotoAspectRatio {
        guard let value = controlValue.selected else {
            return .fourByThree
        }
        
        let selectedAspectRatio = PhotoAspectRatio(rawValue: value) ?? .fourByThree
        
        return selectedAspectRatio
    }
}

private extension FormCameraControl {
    
    var controlValue: ArrayControlValue {
        guard case let .array(value) = type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
    
}
