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
    
    func setupDeviceControl(controlValue: CameraControl,
                            for view: UIView,
                            moduleInput: inout ArraySwitchControlModuleInput?,
                            moduleOutput: SwitchControlModuleOutput)
    
    func setupZoomControl(controlValue: CameraControl,
                          for view: UIView,
                          moduleInput: inout RangeSwitchControlModuleInput?,
                          moduleOutput: SwitchControlModuleOutput)
    
    func setupFocusControl(controlValue: CameraControl,
                           for view: UIView,
                           moduleInput: inout RangeWithDefaultSwitchControlModuleInput?,
                           moduleOutput: SwitchControlModuleOutput)
    
    func setupExposureControl(controlValue: CameraControl,
                              for view: UIView,
                              moduleInput: inout ArrayWithDefaultSwitchControlModuleInput?,
                              moduleOutput: SwitchControlModuleOutput)
    
    func setupISOControl(controlValue: CameraControl,
                         for view: UIView,
                         moduleInput: inout ArrayWithDefaultSwitchControlModuleInput?,
                         moduleOutput: SwitchControlModuleOutput)
    
    func setupWhiteBalanceControl(controlValue: CameraControl,
                                  for view: UIView,
                                  moduleInput: inout RangeWithDefaultSwitchControlModuleInput?,
                                  moduleOutput: SwitchControlModuleOutput)
    
    func setupUIControl(controlValue: CameraControl,
                        for view: UIView,
                        moduleInput: inout SimpleSwitchControlModuleInput?,
                        moduleOutput: SwitchControlModuleOutput)
    
    func setupLibraryControl(controlValue: CameraControl,
                             for view: UIView,
                             moduleInput: inout ActionSwitchControlModuleInput?,
                             moduleOutput: SwitchControlModuleOutput)
}
