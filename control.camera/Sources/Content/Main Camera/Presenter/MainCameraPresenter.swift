//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraPresenter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

class MainCameraPresenter: BasePresenter {
    
    // MARK: - Injected
    
    weak var view: MainCameraViewInputProtocol!
    var router: MainCameraRouterInputProtocol!
    var camera: CameraConfiguration!
    weak var moduleOutput: MainCameraModuleOutput?
    
    weak var lightModuleInput: SimpleSwitchControlModuleInput?
    
}

// MARK: - Module Input
extension MainCameraPresenter: MainCameraModuleInput {
    
}

// MARK: - View - Presenter
extension MainCameraPresenter: MainCameraViewOutputProtocol {
    
    func onViewDidLoad() {
        camera.configure()
        router.setupLightControl(for: view.exampleView,
                                 moduleInput: &lightModuleInput,
                                 moduleOutput: self)
        
        camera.getCameraSettings().logSettings()
    }
    
    func didSetupCameraLayer() {
        camera.startSession()
    }
    
    func didTapOnShutter() {
        camera.capturePhoto()
    }
    
}

// MARK: - Router - Presenter
extension MainCameraPresenter: MainCameraRouterOutputProtocol {
    
}

// MARK: - Camera - Presenter
extension MainCameraPresenter: CameraConfigurationOutput {
    
}

extension MainCameraPresenter: SimpleSwitchControlModuleOutput {
    
    func didChangeSwitch(for type: CameraControlType, value: Bool) {
        print(type.title, value)
    }
    
}
