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
        
        navigationController.modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            if let sheet = navigationController.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
            }
        }
        
        navigationController.isNavigationBarHidden = true
        
        parent.present(navigationController, animated: true, completion: nil)
    }
    
    func createModule(moduleInput: inout ControlsListModuleInput?,
                      moduleOutput: ControlsListModuleOutput?) -> ControlsListViewController? {
        guard let view: ControlsListViewController = initializeController() else { return nil }
        let presenter = ControlsListPresenter()
        let router = ControlsListRouter()
        let dataSource = TableViewDataSource()
        let builder = ControlsListViewModelBuilderImplementation()
        
        presenter.view = view
        presenter.router = router
        presenter.builder = builder
        
        view.output = presenter
        view.dataSource = dataSource
        
        router.output = presenter
        
        router.view = view
        presenter.moduleOutput = moduleOutput
                
        moduleInput = presenter
        
        return view
    }
    
}
