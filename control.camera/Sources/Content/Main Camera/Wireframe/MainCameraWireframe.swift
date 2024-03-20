//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraWireframe.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class MainCameraWireframe: BaseWireframe {
    
    override func storyboardName() -> String {
        return "MainCamera"
    }
    
    override func identifier() -> String {
        return "MainCameraViewController"
    }
    
    func pushFrom(_ parent: UINavigationController?,
                  moduleOutput: MainCameraModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        self.presentedViewController = viewController
        parent.pushViewController(viewController, animated: true)
    }
    
    func presentIn(_ parent: UIViewController?,
                   moduleOutput: MainCameraModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleOutput: moduleOutput),
              let parent = parent else { return }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.presentedViewController = viewController
        
        navigationController.modalPresentationStyle = .fullScreen
        parent.present(navigationController, animated: true, completion: nil)
    }
    
    func createModule(moduleOutput: MainCameraModuleOutput?) -> MainCameraViewController? {
        guard let view: MainCameraViewController = initializeController() else { return nil }
        let presenter = MainCameraPresenter()
        let router = MainCameraRouter()
        let camera = CameraConfigurationImplementation()
        let storage = CameraSettingsStorageImplementation.default
        let stepByStepApplier = CameraStepByStepPostApplierImplementation()
        let croppingService = CroppingServiceImplementation()
        let liveApplier = CameraLiveApplierImplementation()
        let whiteBalanceService = WhiteBalanceCalculatingServiceImplementation()
        let builder = MainCameraModulesBuilderImplementation()
        let dataSource = CollectionViewDataSource()
        let arrangeService = ControlArrangeServiceImplementation()
        
        liveApplier.view = view
        liveApplier.camera = camera
        
        stepByStepApplier.settingsStorage = storage
        stepByStepApplier.croppingService = croppingService
        
        camera.settingsStorage = storage
        camera.stepByStepApplier = stepByStepApplier
        
        storage.arrangeService = arrangeService
        
        presenter.view = view
        presenter.router = router
        presenter.camera = camera
        presenter.settingsStorage = storage
        presenter.liveApplier = liveApplier
        presenter.moduleBuilder = builder
        
        builder.router = router
        builder.parent = presenter
        
        view.output = presenter
        view.dataSource = dataSource
        
        router.output = presenter
        
        router.view = view
        presenter.moduleOutput = moduleOutput
        
        camera.output = presenter
        camera.view = view
        camera.whiteBalanceService = whiteBalanceService
                
        return view
    }
    
}
