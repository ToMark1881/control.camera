//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeSwitchControlModuleInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

protocol RangeSwitchControlModuleInput: BasePresenter {
    func setupSwitch(for control: CameraControl)
}
