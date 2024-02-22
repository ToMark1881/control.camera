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
    weak var formModuleInput: ArraySwitchControlModuleInput?
    
    var camera: CameraConfiguration!
    var liveApplier: CameraLiveApplier!
    var settingsStorage: CameraSettingsStorage!
    
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

// MARK: - SwitchControlModuleOutput
extension MainCameraPresenter: SwitchControlModuleOutput {
    
    func didChangeSwitch(for control: CameraControl) {
        settingsStorage.store(control)
        
        liveApplier.applyControlIfNeeded(control)
    }
    
}

private extension MainCameraPresenter {
    
    func setupControls() {
        setupLightControl()
        setupFormControl()
    }
    
    func setupLightControl() {
        guard camera.settings.isFlashAvailable else {
            return
        }
        
        let controlValue = FlashCameraControl()
        
        router.setupLightControl(controlValue: controlValue,
                                 for: view.flashView,
                                 moduleInput: &lightModuleInput,
                                 moduleOutput: self)
    }
    
    func setupFormControl() {
        let controlValue = FormCameraControl()
        
        router.setupFormControl(controlValue: controlValue,
                                for: view.formView,
                                moduleInput: &formModuleInput,
                                moduleOutput: self)
    }
    
}
