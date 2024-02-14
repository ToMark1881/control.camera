//  VIPER Template created by Vladyslav Vdovychenko
//  
//  SwitchControlModuleOutput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

protocol SwitchControlModuleOutput: AnyObject {
    func didChangeSwitch(for control: CameraControl)
}
