//
//  FormCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 13.02.2024.
//

import Foundation

class FormCameraControl: CameraControl {
    
    enum PhotoAspectRatio: String {
        case threeByFour = "3:4"
        case oneByOne = "1:1"
        case nineBySixteen = "9:16"
        case tenBySixteen = "10:16"
        
        var aspectRatio: CGFloat {
            switch self {
            case .threeByFour:
                return 3/4
            case .oneByOne:
                return 1
            case .nineBySixteen:
                return 9/16
            case .tenBySixteen:
                return 10/16
            }
        }
    }
    
    var title: String {
        return "Form"
    }
    
    var type: CameraControlType = .array(ArrayControlValue(array: [PhotoAspectRatio.threeByFour.rawValue,
                                                                   PhotoAspectRatio.tenBySixteen.rawValue,
                                                                   PhotoAspectRatio.nineBySixteen.rawValue,
                                                                   PhotoAspectRatio.oneByOne.rawValue],
                                                           selected: nil))
    
    var aspectRatio: PhotoAspectRatio {
        guard let value = controlValue.selected else {
            return .threeByFour
        }
        
        let selectedAspectRatio = PhotoAspectRatio(rawValue: value) ?? .threeByFour
        
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
