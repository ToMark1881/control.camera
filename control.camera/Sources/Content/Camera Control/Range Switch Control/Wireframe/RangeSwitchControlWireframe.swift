//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeSwitchControlWireframe.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class RangeSwitchControlWireframe: BaseWireframe {
    
    override func storyboardName() -> String {
        return "RangeSwitchControl"
    }
    
    override func identifier() -> String {
        return "RangeSwitchControlViewController"
    }
    
    func pushFrom(_ parent: UINavigationController?,
                  moduleInput: inout RangeSwitchControlModuleInput?,
                  moduleOutput: SwitchControlModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleInput: &moduleInput,
                                                     moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        self.presentedViewController = viewController
        parent.pushViewController(viewController, animated: true)
    }
    
    func presentIn(_ parent: UIViewController?,
                   moduleInput: inout RangeSwitchControlModuleInput?,
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
                    moduleInput: inout RangeSwitchControlModuleInput?,
                    moduleOutput: SwitchControlModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleInput: &moduleInput,
                                                     moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        parent.addChild(viewController)
        viewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: parent)
    }
    
    func createModule(moduleInput: inout RangeSwitchControlModuleInput?,
                      moduleOutput: SwitchControlModuleOutput?) -> RangeSwitchControlViewController? {
        guard let view: RangeSwitchControlViewController = initializeController() else { return nil }
        let presenter = RangeSwitchControlPresenter()
        let router = RangeSwitchControlRouter()
        
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
