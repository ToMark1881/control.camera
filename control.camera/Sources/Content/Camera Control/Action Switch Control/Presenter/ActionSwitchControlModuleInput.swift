//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ActionSwitchControlModuleInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

protocol ActionSwitchControlModuleInput: BasePresenter {
    func setupSwitch(for control: CameraControl)
}
