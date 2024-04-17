//
//  FormatCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.04.2024.
//

import Foundation
import AVFoundation

class FormatCameraControl: CameraControl {
    
    enum PhotoFormat: String {
        case jpeg = "JPEG"
        case heic = "HEIC"
        case raw = "RAW"
    }
    
    var controlType: ControlType {
        return .format
    }
    
    var elementHeight: CGFloat? {
        return 100.0
    }
    
    var valueType: CameraControlValueType! = .array(ArrayControlValue(array: [PhotoFormat.jpeg.rawValue,
                                                                              PhotoFormat.heic.rawValue,
                                                                              PhotoFormat.raw.rawValue],
                                                           selected: nil))
    
    var photoFormat: PhotoFormat {
        guard let value = controlValue.selected else {
            return .jpeg
        }
        
        let selectedAspectRatio = PhotoFormat(rawValue: value) ?? .jpeg
        
        return selectedAspectRatio
    }
}

private extension FormatCameraControl {
    
    var controlValue: ArrayControlValue {
        guard case let .array(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        return value
    }
    
}
