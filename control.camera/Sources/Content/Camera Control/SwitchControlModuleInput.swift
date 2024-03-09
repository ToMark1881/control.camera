//
//  SwitchControlModuleInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 03.03.2024.
//

import Foundation

protocol SwitchControlModuleInput {
    func setupSwitch(for control: CameraControl)
    func updateSwitch(for control: CameraControl)
    func setEnabled(_ isEnabled: Bool)
}

extension SwitchControlModuleInput {
    
    func updateSwitch(for control: CameraControl) {
        setupSwitch(for: control)
    }
    
}
