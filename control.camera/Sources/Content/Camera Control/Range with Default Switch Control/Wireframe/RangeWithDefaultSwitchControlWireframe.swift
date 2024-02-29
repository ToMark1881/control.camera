//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeWithDefaultSwitchControlWireframe.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class RangeWithDefaultSwitchControlWireframe: BaseWireframe {
    
    override func storyboardName() -> String {
        return "RangeWithDefaultSwitchControl"
    }
    
    override func identifier() -> String {
        return "RangeWithDefaultSwitchControlViewController"
    }
    
    func pushFrom(_ parent: UINavigationController?,
                  moduleInput: inout RangeWithDefaultSwitchControlModuleInput?,
                  moduleOutput: SwitchControlModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleInput: &moduleInput,
                                                     moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        self.presentedViewController = viewController
        parent.pushViewController(viewController, animated: true)
    }
    
    func presentIn(_ parent: UIViewController?,
                   moduleInput: inout RangeWithDefaultSwitchControlModuleInput?,
                   moduleOutput: SwitchControlModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleInput: &moduleInput,
                                                     moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.presentedViewController = viewController
        
        navigationController.modalPresentationStyle = .fullScreen
        parent.present(navigationController, animated: true, completion: nil)
    }
    
    func embeddedIn(_ parent: UIViewController?,
                    view: UIView,
                    moduleInput: inout RangeWithDefaultSwitchControlModuleInput?,
                    moduleOutput: SwitchControlModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleInput: &moduleInput,
                                                     moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        parent.addChild(viewController)
        viewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: parent)
    }
    
    func createModule(moduleInput: inout RangeWithDefaultSwitchControlModuleInput?,
                      moduleOutput: SwitchControlModuleOutput?) -> RangeWithDefaultSwitchControlViewController? {
        guard let view: RangeWithDefaultSwitchControlViewController = initializeController() else { return nil }
        let presenter = RangeWithDefaultSwitchControlPresenter()
        let router = RangeWithDefaultSwitchControlRouter()
        
        presenter.view = view
        presenter.router = router
        
        view.output = presenter
        router.output = presenter
        
        router.view = view
        presenter.moduleOutput = moduleOutput
        
        moduleInput = presenter
        
        return view
    }
    
}
