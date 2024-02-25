//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraRouter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class MainCameraRouter: BaseRouter {
    
    // MARK: - Injected
    weak var output: MainCameraRouterOutputProtocol!
    weak var view: BaseViewControllerProtocol!
    
    private lazy var simpleSwitchWireframe = { SimpleSwitchControlWireframe() }()
    private lazy var arraySwitchWireframe = { ArraySwitchControlWireframe() }()
    private lazy var rangeSwitchWireframe = { RangeSwitchControlWireframe() }()
    
}

extension MainCameraRouter: MainCameraRouterInputProtocol {
    
    // MARK: - Present
    func setupLightControl(controlValue: CameraControl,
                           for view: UIView,
                           moduleInput: inout SimpleSwitchControlModuleInput?,
                           moduleOutput: SwitchControlModuleOutput) {
        simpleSwitchWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
        
        moduleInput?.setupSwitch(for: controlValue)
        
    }
    
    func setupFormControl(controlValue: CameraControl,
                          for view: UIView,
                          moduleInput: inout ArraySwitchControlModuleInput?,
                          moduleOutput: SwitchControlModuleOutput) {
        arraySwitchWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
        
        moduleInput?.setupSwitch(for: controlValue)
    }
    
    func setupDeviceControl(controlValue: CameraControl,
                            for view: UIView,
                            moduleInput: inout ArraySwitchControlModuleInput?,
                            moduleOutput: SwitchControlModuleOutput) {
        arraySwitchWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
        
        moduleInput?.setupSwitch(for: controlValue)
    }
    
    func setupZoomControl(controlValue: CameraControl,
                          for view: UIView,
                          moduleInput: inout RangeSwitchControlModuleInput?,
                          moduleOutput: SwitchControlModuleOutput) {
        rangeSwitchWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
        
        moduleInput?.setupSwitch(for: controlValue)
    }
    
    // MARK: - Dismiss
    
}
