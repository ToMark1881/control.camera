//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ArrayWithDefaultSwitchControlWireframe.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class ArrayWithDefaultSwitchControlWireframe: BaseWireframe {
    
    override func storyboardName() -> String {
        return "ArrayWithDefaultSwitchControl"
    }
    
    override func identifier() -> String {
        return "ArrayWithDefaultSwitchControlViewController"
    }
    
    func pushFrom(_ parent: UINavigationController?,
                  moduleInput: inout ArrayWithDefaultSwitchControlModuleInput?,
                  moduleOutput: SwitchControlModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleInput: &moduleInput,
                                                     moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        self.presentedViewController = viewController
        parent.pushViewController(viewController, animated: true)
    }
    
    func presentIn(_ parent: UIViewController?,
                   moduleInput: inout ArrayWithDefaultSwitchControlModuleInput?,
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
                    moduleInput: inout ArrayWithDefaultSwitchControlModuleInput?,
                    moduleOutput: SwitchControlModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleInput: &moduleInput,
                                                     moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        parent.addChild(viewController)
        viewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: parent)
    }
    
    func createModule(moduleInput: inout ArrayWithDefaultSwitchControlModuleInput?,
                      moduleOutput: SwitchControlModuleOutput?) -> ArrayWithDefaultSwitchControlViewController? {
        guard let view: ArrayWithDefaultSwitchControlViewController = initializeController() else { return nil }
        let presenter = ArrayWithDefaultSwitchControlPresenter()
        let router = ArrayWithDefaultSwitchControlRouter()
        
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
