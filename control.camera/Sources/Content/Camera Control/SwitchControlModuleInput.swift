//
//  SwitchControlModuleInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 03.03.2024.
//

import Foundation

protocol SwitchControlModuleInput: AnyObject {
    func setupSwitch(for control: CameraControl)
    func updateSwitch(for control: CameraControl)
    func updateTitle(_ title: String)
    func setEnabled(_ isEnabled: Bool)
    func setArrangeModeActive(_ isActive: Bool)
    func setControl(index: Int)
    /// Tells the control it currently sits on light preview content,
    /// so its text should temporarily turn dark to stay legible
    func setOnLightBackground(_ isOnLightBackground: Bool)
}

extension SwitchControlModuleInput {

    func updateSwitch(for control: CameraControl) {
        setupSwitch(for: control)
    }

    func setOnLightBackground(_ isOnLightBackground: Bool) {

    }

}
