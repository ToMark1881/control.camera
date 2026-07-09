//
//  SavePresetCameraControl.swift
//  control.camera
//

import Foundation

class SavePresetCameraControl: CameraControl {

    var controlType: ControlType {
        return .savePreset
    }

    var valueType: CameraControlValueType!

    init(action: @escaping (() -> Void)) {
        self.valueType = .action(ActionControlValue(action: action))
    }

}
