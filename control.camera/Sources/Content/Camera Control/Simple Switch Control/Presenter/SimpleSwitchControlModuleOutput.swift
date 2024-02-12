//  VIPER Template created by Vladyslav Vdovychenko
//  
//  SimpleSwitchControlModuleOutput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

protocol SimpleSwitchControlModuleOutput: AnyObject {
    func didChangeSwitch(for control: CameraControl)
}
