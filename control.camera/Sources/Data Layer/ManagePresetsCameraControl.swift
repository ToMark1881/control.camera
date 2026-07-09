//
//  ManagePresetsCameraControl.swift
//  control.camera
//

import Foundation

class ManagePresetsCameraControl: CameraControl {

    var controlType: ControlType {
        return .managePresets
    }

    var valueType: CameraControlValueType!

    init(action: @escaping (() -> Void)) {
        self.valueType = .action(ActionControlValue(action: action))
    }

}
