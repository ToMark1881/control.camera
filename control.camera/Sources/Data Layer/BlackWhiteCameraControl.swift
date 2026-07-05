//
//  BlackWhiteCameraControl.swift
//  control.camera
//

import Foundation

class BlackWhiteCameraControl: CameraControl {

    var controlType: ControlType {
        return .blackWhite
    }

    var valueType: CameraControlValueType! = .simple(SimpleControlValue(isActive: false))

    var isActive: Bool {
        return controlValue.isActive
    }

    var controlValue: SimpleControlValue {
        guard case let .simple(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }

        return value
    }

}
