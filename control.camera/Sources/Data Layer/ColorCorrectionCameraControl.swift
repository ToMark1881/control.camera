//
//  ColorCorrectionCameraControl.swift
//  control.camera
//

import Foundation

class ColorCorrectionCameraControl: CameraControl {

    enum Channel {
        case contrast
        case red
        case green
        case blue

        var controlType: ControlType {
            switch self {
            case .contrast:
                return .contrast
            case .red:
                return .red
            case .green:
                return .green
            case .blue:
                return .blue
            }
        }
    }

    let channel: Channel

    var controlType: ControlType {
        return channel.controlType
    }

    var valueType: CameraControlValueType!

    var elementHeight: CGFloat? {
        return 12.0
    }

    /// Selected level (-10...10), 0 when neutral
    var selectedLevel: CGFloat {
        return controlValue.range.selected ?? 0
    }

    var isNeutral: Bool {
        return selectedLevel == 0
    }

    /// Normalized level (-1...1) for the color correction service
    var normalizedLevel: CGFloat {
        return selectedLevel / 10.0
    }

    init(channel: Channel, selected: CGFloat?) {
        self.channel = channel

        let range = RangeControlValue(min: -10, max: 10, step: 1, selected: selected)
        self.valueType = .rangeWithDefault(RangeWithDefaultControlValue(defaultValue: "0", range: range))
    }

}

extension ColorCorrectionCameraControl {

    var controlValue: RangeWithDefaultControlValue {
        guard case let .rangeWithDefault(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }

        return value
    }

}
