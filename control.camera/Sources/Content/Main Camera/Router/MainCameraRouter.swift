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
    private lazy var actionSwitchWireframe = { ActionSwitchControlWireframe() }()
    private lazy var rangeWithDefaultWireframe = { RangeWithDefaultSwitchControlWireframe() }()
    private lazy var arrayWithDefaultWireframe = { ArrayWithDefaultSwitchControlWireframe() }()
    
}

extension MainCameraRouter: MainCameraRouterInputProtocol {
    
    // MARK: - Present
    func setupLightControl(for view: UIView,
                           moduleInput: inout SimpleSwitchControlModuleInput?,
                           moduleOutput: SwitchControlModuleOutput) {
        simpleSwitchWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
    }
    
    func setupFormControl(for view: UIView,
                          moduleInput: inout ArraySwitchControlModuleInput?,
                          moduleOutput: SwitchControlModuleOutput) {
        arraySwitchWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
    }
    
    func setupDeviceControl(for view: UIView,
                            moduleInput: inout ArraySwitchControlModuleInput?,
                            moduleOutput: SwitchControlModuleOutput) {
        arraySwitchWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
    }
    
    func setupZoomControl(for view: UIView,
                          moduleInput: inout RangeSwitchControlModuleInput?,
                          moduleOutput: SwitchControlModuleOutput) {
        rangeSwitchWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
    }
    
    func setupFocusControl(for view: UIView,
                           moduleInput: inout RangeWithDefaultSwitchControlModuleInput?,
                           moduleOutput: SwitchControlModuleOutput) {
        rangeWithDefaultWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
    }
    
    func setupExposureControl(for view: UIView,
                              moduleInput: inout ArrayWithDefaultSwitchControlModuleInput?,
                              moduleOutput: SwitchControlModuleOutput) {
        arrayWithDefaultWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
    }
    
    func setupISOControl(for view: UIView,
                         moduleInput: inout ArrayWithDefaultSwitchControlModuleInput?,
                         moduleOutput: SwitchControlModuleOutput) {
        arrayWithDefaultWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
    }
    
    func setupWhiteBalanceControl(for view: UIView,
                                  moduleInput: inout RangeWithDefaultSwitchControlModuleInput?,
                                  moduleOutput: SwitchControlModuleOutput) {
        rangeWithDefaultWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
    }
    
    func setupUIControl(for view: UIView,
                        moduleInput: inout SimpleSwitchControlModuleInput?,
                        moduleOutput: SwitchControlModuleOutput) {
        simpleSwitchWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
    }
    
    func setupLibraryControl(for view: UIView,
                             moduleInput: inout ActionSwitchControlModuleInput?,
                             moduleOutput: SwitchControlModuleOutput) {
        actionSwitchWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
    }
    
    func setupArrangeControl(for view: UIView,
                             moduleInput: inout ActionSwitchControlModuleInput?,
                             moduleOutput: SwitchControlModuleOutput) {
        actionSwitchWireframe.embeddedIn(self.view, view: view, moduleInput: &moduleInput, moduleOutput: moduleOutput)
    }
    
    func setupEmptyControl(for view: UIView,
                           moduleInput: inout SwitchControlModuleInput?,
                           moduleOutput: SwitchControlModuleOutput) {
        let viewController = EmptyControl()
        moduleInput = viewController
        viewController.output = moduleOutput
        
        let parent = self.view
        
        parent?.addChild(viewController)
        viewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: parent)
    }
    
    // MARK: - Dismiss
    
}
