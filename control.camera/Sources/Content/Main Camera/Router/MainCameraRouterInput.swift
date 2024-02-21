//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraRouterInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol MainCameraRouterInputProtocol: AnyObject {
    func setupLightControl(controlValue: CameraControl,
                           for view: UIView,
                           moduleInput: inout SimpleSwitchControlModuleInput?,
                           moduleOutput: SwitchControlModuleOutput)
    
    func setupFormControl(controlValue: CameraControl,
                          for view: UIView,
                          moduleInput: inout ArraySwitchControlModuleInput?,
                          moduleOutput: SwitchControlModuleOutput)
}
