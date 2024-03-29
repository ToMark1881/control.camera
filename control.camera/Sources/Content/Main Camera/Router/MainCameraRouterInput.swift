//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraRouterInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol MainCameraRouterInputProtocol: AnyObject {
    func setupLightControl(for view: UIView,
                           moduleInput: inout SimpleSwitchControlModuleInput?,
                           moduleOutput: SwitchControlModuleOutput)
    
    func setupFormControl(for view: UIView,
                          moduleInput: inout ArraySwitchControlModuleInput?,
                          moduleOutput: SwitchControlModuleOutput)
    
    func setupDeviceControl(for view: UIView,
                            moduleInput: inout ArraySwitchControlModuleInput?,
                            moduleOutput: SwitchControlModuleOutput)
    
    func setupZoomControl(for view: UIView,
                          moduleInput: inout RangeSwitchControlModuleInput?,
                          moduleOutput: SwitchControlModuleOutput)
    
    func setupFocusControl(for view: UIView,
                           moduleInput: inout RangeWithDefaultSwitchControlModuleInput?,
                           moduleOutput: SwitchControlModuleOutput)
    
    func setupExposureControl(for view: UIView,
                              moduleInput: inout ArrayWithDefaultSwitchControlModuleInput?,
                              moduleOutput: SwitchControlModuleOutput)
    
    func setupISOControl(for view: UIView,
                         moduleInput: inout ArrayWithDefaultSwitchControlModuleInput?,
                         moduleOutput: SwitchControlModuleOutput)
    
    func setupWhiteBalanceControl(for view: UIView,
                                  moduleInput: inout RangeWithDefaultSwitchControlModuleInput?,
                                  moduleOutput: SwitchControlModuleOutput)
    
    func setupUIControl(for view: UIView,
                        moduleInput: inout SimpleSwitchControlModuleInput?,
                        moduleOutput: SwitchControlModuleOutput)
    
    func setupLibraryControl(for view: UIView,
                             moduleInput: inout ActionSwitchControlModuleInput?,
                             moduleOutput: SwitchControlModuleOutput)
    
    func setupArrangeControl(for view: UIView,
                             moduleInput: inout ActionSwitchControlModuleInput?,
                             moduleOutput: SwitchControlModuleOutput)
    
    func setupEmptyControl(for view: UIView,
                           moduleInput: inout SwitchControlModuleInput?,
                           moduleOutput: SwitchControlModuleOutput)
}
