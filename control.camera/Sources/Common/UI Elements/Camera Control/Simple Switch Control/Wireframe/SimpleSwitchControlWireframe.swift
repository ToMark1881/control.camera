//  VIPER Template created by Vladyslav Vdovychenko
//  
//  SimpleSwitchControlWireframe.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class SimpleSwitchControlWireframe: BaseWireframe {
    
    override func storyboardName() -> String {
        return "SimpleSwitchControl"
    }
    
    override func identifier() -> String {
        return "SimpleSwitchControlViewController"
    }
    
    func pushFrom(_ parent: UINavigationController?,
                  moduleInput: inout SimpleSwitchControlModuleInput?,
                  moduleOutput: SimpleSwitchControlModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleInput: &moduleInput,
                                                     moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        self.presentedViewController = viewController
        parent.pushViewController(viewController, animated: true)
    }
    
    func presentIn(_ parent: UIViewController?,
                   moduleInput: inout SimpleSwitchControlModuleInput?,
                   moduleOutput: SimpleSwitchControlModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleInput: &moduleInput,
                                                     moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.presentedViewController = viewController
        
        navigationController.modalPresentationStyle = .fullScreen
        parent.present(navigationController, animated: true, completion: nil)
    }
    
    func createModule(moduleInput: inout SimpleSwitchControlModuleInput?,
                      moduleOutput: SimpleSwitchControlModuleOutput?) -> SimpleSwitchControlViewController? {
        guard let view: SimpleSwitchControlViewController = initializeController() else { return nil }
        let presenter = SimpleSwitchControlPresenter()
        let router = SimpleSwitchControlRouter()
        
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
