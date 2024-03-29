//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ControlsListWireframe.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 29.03.2024.
//

import Foundation
import UIKit

final class ControlsListWireframe: BaseWireframe {
    
    override func storyboardName() -> String {
        return "ControlsList"
    }
    
    override func identifier() -> String {
        return "ControlsListViewController"
    }
    
    func pushFrom(_ parent: UINavigationController?,
                  moduleInput: inout ControlsListModuleInput?,
                  moduleOutput: ControlsListModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleInput: &moduleInput,
                                                     moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        self.presentedViewController = viewController
        parent.pushViewController(viewController, animated: true)
    }
    
    func presentIn(_ parent: UIViewController?,
                   moduleInput: inout ControlsListModuleInput?,
                   moduleOutput: ControlsListModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleInput: &moduleInput,
                                                     moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.presentedViewController = viewController
        
        parent.present(navigationController, animated: true, completion: nil)
    }
    
    func createModule(moduleInput: inout ControlsListModuleInput?,
                      moduleOutput: ControlsListModuleOutput?) -> ControlsListViewController? {
        guard let view: ControlsListViewController = initializeController() else { return nil }
        let presenter = ControlsListPresenter()
        let router = ControlsListRouter()
        
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
