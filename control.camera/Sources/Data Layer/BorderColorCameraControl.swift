//
//  BorderColorCameraControl.swift
//  control.camera
//

import Foundation
import UIKit

class BorderColorCameraControl: CameraControl {

    enum BorderColor: String {
        case white = "White"
        case black = "Black"

        var cgColor: CGColor {
            switch self {
            case .white:
                return UIColor.white.cgColor
            case .black:
                return UIColor.black.cgColor
            }
        }
    }

    var controlType: ControlType {
        return .borderColor
    }

    var elementHeight: CGFloat? {
        return 100.0
    }

    var valueType: CameraControlValueType! = .array(ArrayControlValue(array: [BorderColor.white.rawValue,
                                                                              BorderColor.black.rawValue],
                                                                      selected: nil))

    var selectedColor: BorderColor {
        guard let value = controlValue.selected else {
            return .white
        }

        return BorderColor(rawValue: value) ?? .white
    }
}

private extension BorderColorCameraControl {

    var controlValue: ArrayControlValue {
        guard case let .array(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }

        return value
    }

}
