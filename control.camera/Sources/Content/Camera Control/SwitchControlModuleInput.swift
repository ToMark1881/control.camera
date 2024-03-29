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
    func setEnabled(_ isEnabled: Bool)
    func setArrangeModeActive(_ isActive: Bool)
    func setControl(index: Int)
}

extension SwitchControlModuleInput {
    
    func updateSwitch(for control: CameraControl) {
        setupSwitch(for: control)
    }
    
}
