//  VIPER Template created by Vladyslav Vdovychenko
//  
//  OnboardingWireframe.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class OnboardingWireframe: BaseWireframe {
    
    override func storyboardName() -> String {
        return "Onboarding"
    }
    
    override func identifier() -> String {
        return "OnboardingViewController"
    }
    
    func pushFrom(_ parent: UINavigationController?,
                  moduleOutput: OnboardingModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        self.presentedViewController = viewController
        parent.pushViewController(viewController, animated: true)
    }
    
    func presentIn(_ parent: UIViewController?,
                   moduleOutput: OnboardingModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.presentedViewController = viewController
        
        navigationController.modalPresentationStyle = .fullScreen
        parent.present(navigationController, animated: true, completion: nil)
    }
    
    func createModule(moduleOutput: OnboardingModuleOutput?) -> OnboardingViewController? {
        guard let view: OnboardingViewController = initializeController() else { return nil }
        let presenter = OnboardingPresenter()
        let router = OnboardingRouter()
        let dataSource = CollectionViewDataSource()
        let builder = MainCameraModulesBuilderImplementation()
        let mainCameraRouter = MainCameraRouter()
        
        builder.router = mainCameraRouter
        builder.parent = presenter
        mainCameraRouter.view = view
        
        presenter.view = view
        presenter.router = router
        presenter.builder = builder
        
        view.output = presenter
        view.dataSource = dataSource
        
        router.output = presenter
        
        router.view = view
        presenter.moduleOutput = moduleOutput
                
        return view
    }
    
}
