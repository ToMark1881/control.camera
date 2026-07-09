//  VIPER Template created by Vladyslav Vdovychenko
//
//  ManagePresetsWireframe.swift
//  control.camera
//

import Foundation
import UIKit

final class ManagePresetsWireframe: BaseWireframe {

    // The screen is built in code with Auto Layout,
    // so the storyboard overrides are intentionally not provided

    func presentIn(_ parent: UIViewController?,
                   moduleOutput: ManagePresetsModuleOutput? = nil) {
        guard let viewController = self.createModule(moduleOutput: moduleOutput),
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

    func createModule(moduleOutput: ManagePresetsModuleOutput?) -> ManagePresetsViewController? {
        let view = ManagePresetsViewController()
        let presenter = ManagePresetsPresenter()
        let router = ManagePresetsRouter()
        let dataSource = TableViewDataSource()

        presenter.view = view
        presenter.router = router
        presenter.presetsStorage = PresetsStorageImplementation.default
        presenter.presetMapper = PresetMapperImplementation()
        presenter.moduleOutput = moduleOutput

        view.output = presenter
        view.dataSource = dataSource

        router.output = presenter
        router.view = view

        return view
    }

}
