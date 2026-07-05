//
//  NoiseCameraControl.swift
//  control.camera
//

import Foundation

class NoiseCameraControl: CameraControl {

    var controlType: ControlType {
        return .noise
    }

    var valueType: CameraControlValueType!

    var elementHeight: CGFloat? {
        return 12.0
    }

    /// Grain level selected by the user (1...10), 0 when the control is off
    var selectedLevel: CGFloat {
        return controlValue.range.selected ?? 0
    }

    var isActive: Bool {
        return selectedLevel > 0
    }

    /// Normalized grain intensity (0...1) for the film grain service
    var grainIntensity: CGFloat {
        return selectedLevel / 10.0
    }

    /// Grain particle scale. Fixed for now, a dedicated control
    /// may drive it in a later iteration
    let grainSize: CGFloat = 1.0

    init(selected: CGFloat?) {
        let range = RangeControlValue(min: 1, max: 10, step: 1, selected: selected)
        self.valueType = .rangeWithDefault(RangeWithDefaultControlValue(defaultValue: "Off", range: range))
    }

}

extension NoiseCameraControl {

    var controlValue: RangeWithDefaultControlValue {
        guard case let .rangeWithDefault(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }

        return value
    }

}
