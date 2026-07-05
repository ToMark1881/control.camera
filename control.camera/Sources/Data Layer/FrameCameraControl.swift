//
//  FrameCameraControl.swift
//  control.camera
//

import Foundation

class FrameCameraControl: CameraControl {

    var controlType: ControlType {
        return .frame
    }

    var valueType: CameraControlValueType!

    var elementHeight: CGFloat? {
        return 12.0
    }

    /// Selected border width as a percent of the shorter image side (1...20).
    /// 0 when the control is off
    var selectedWidth: CGFloat {
        return controlValue.range.selected ?? 0
    }

    var isActive: Bool {
        return selectedWidth > 0
    }

    init(selected: CGFloat?) {
        let range = RangeControlValue(min: 1, max: 20, step: 1, selected: selected)
        self.valueType = .rangeWithDefault(RangeWithDefaultControlValue(defaultValue: "Off", range: range))
    }

}

extension FrameCameraControl {

    var controlValue: RangeWithDefaultControlValue {
        guard case let .rangeWithDefault(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }

        return value
    }

}
