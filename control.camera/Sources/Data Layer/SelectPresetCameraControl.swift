//
//  SelectPresetCameraControl.swift
//  control.camera
//

import Foundation

class SelectPresetCameraControl: CameraControl {

    var controlType: ControlType {
        return .selectPreset
    }

    var valueType: CameraControlValueType!

    var elementHeight: CGFloat? {
        return 100.0
    }

    // Lives in the dock row, so it can not be rearranged
    var couldBeArranged: Bool {
        return false
    }

    /// nil when the virtual "Off" preset is selected
    var selectedPresetName: String? {
        guard let selected = controlValue.selected,
              selected != PresetConstants.virtualOffPresetName else {
            return nil
        }

        return selected
    }

    init(presetNames: [String], selected: String?) {
        let array = ArrayControlValue(array: [PresetConstants.virtualOffPresetName] + presetNames,
                                      selected: selected ?? PresetConstants.virtualOffPresetName)
        self.valueType = .array(array)
    }

}

extension SelectPresetCameraControl {

    var controlValue: ArrayControlValue {
        guard case let .array(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }

        return value
    }

}
