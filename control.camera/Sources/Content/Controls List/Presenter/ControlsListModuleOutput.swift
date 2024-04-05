//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ControlsListModuleOutput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 29.03.2024.
//

import Foundation

protocol ControlsListModuleOutput: AnyObject {
    func didUpdate(control: ControlType)
}
