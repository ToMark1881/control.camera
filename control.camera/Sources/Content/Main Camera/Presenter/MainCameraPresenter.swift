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
    
    weak var moduleOutput: MainCameraModuleOutput?
    weak var lightModuleInput: SimpleSwitchControlModuleInput?
    
    var camera: CameraConfiguration!
    var settingsApplier: CameraSettingsApplier!
    
}

// MARK: - Module Input
extension MainCameraPresenter: MainCameraModuleInput {
    
}

// MARK: - View - Presenter
extension MainCameraPresenter: MainCameraViewOutputProtocol {
    
    func onViewDidLoad() {
        camera.configure()
        camera.settings.logSettings()
        
        setupControls()
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

// MARK: - SimpleSwitchControlModuleOutput
extension MainCameraPresenter: SimpleSwitchControlModuleOutput {
    
    func didChangeSwitch(for control: CameraControl) {
        settingsApplier.apply(control)
    }
    
}

private extension MainCameraPresenter {
    
    func setupControls() {
        setupLightControl()
    }
    
    func setupLightControl() {
        guard camera.settings.isFlashAvailable else {
            return
        }
        
        let controlValue = SimpleControlValue(isActive: false)
        
        router.setupLightControl(controlValue: controlValue,
                                 for: view.exampleView,
                                 moduleInput: &lightModuleInput,
                                 moduleOutput: self)
    }
    
}
