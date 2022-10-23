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
    
}

extension MainCameraRouter: MainCameraRouterInputProtocol {
    
    // MARK: - Present
    func setupLightControl(for view: UIView,
                           moduleInput: inout SimpleSwitchControlModuleInput?,
                           moduleOutput: SimpleSwitchControlModuleOutput) {
        simpleSwitchWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
        moduleInput?.setupSwitch(for: .light, defaultValue: true)
    }
    // MARK: - Dismiss
    
}
