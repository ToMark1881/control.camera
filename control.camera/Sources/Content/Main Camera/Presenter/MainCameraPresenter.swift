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
    weak var deviceModuleInput: ArraySwitchControlModuleInput?
    weak var zoomModuleInput: RangeSwitchControlModuleInput?
    weak var uiModuleInput: SimpleSwitchControlModuleInput?
    
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
    
    func didChangeInputDevice() {
        resetZoomControl()
    }
    
}

// MARK: - SwitchControlModuleOutput
extension MainCameraPresenter: SwitchControlModuleOutput {
    
    func didChangeSwitch(for control: CameraControl) {
        settingsStorage.store(control)
        
        liveApplier.applyControlIfNeeded(control)
    }
    
}

private extension MainCameraPresenter {
    
    // MARK: - Main controls function
    func setupControls() {
        setupLightControl()
        setupFormControl()
        setupDeviceControl()
        setupZoomControl()
        setupUIControl()
        setupLibraryControl()
    }
    
    // MARK: - Light control
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
    
    // MARK: - Form control
    func setupFormControl() {
        let controlValue = FormCameraControl()
        
        router.setupFormControl(controlValue: controlValue,
                                for: view.formView,
                                moduleInput: &formModuleInput,
                                moduleOutput: self)
    }
    
    // MARK: - Device control
    func setupDeviceControl() {
        let availableDevices = camera.availableDevices
        let controlValue = VideoDeviceCameraControl(for: availableDevices)
                
        router.setupDeviceControl(controlValue: controlValue,
                                  for: view.deviceView,
                                  moduleInput: &deviceModuleInput,
                                  moduleOutput: self)
    }
    
    // MARK: - Zoom control
    func setupZoomControl() {
        let maxZoom = min(10.0, camera.settings.maxZoom)
        
        let controlValue = ZoomCameraControl(min: camera.settings.minZoom,
                                             max: maxZoom,
                                             step: 0.1,
                                             selected: camera.settings.minZoom)
        
        router.setupZoomControl(controlValue: controlValue,
                                for: view.zoomView,
                                moduleInput: &zoomModuleInput,
                                moduleOutput: self)
    }
    
    func resetZoomControl() {
        let maxZoom = min(10.0, camera.settings.maxZoom)
        
        let controlValue = ZoomCameraControl(min: camera.settings.minZoom,
                                             max: maxZoom,
                                             step: 0.1,
                                             selected: camera.settings.minZoom)
        
        zoomModuleInput?.setupSwitch(for: controlValue)
    }
    
    // MARK: - UI control
    func setupUIControl() {
        let controlValue = ShowUICameraControl()
        
        router.setupUIControl(controlValue: controlValue,
                              for: view.showUIView,
                              moduleInput: &uiModuleInput,
                              moduleOutput: self)
    }
    
    // MARK: - Library control
    func setupLibraryControl() {
        let action: (() -> Void) = { [weak self] in
            self?.openLibrary()
        }
        
        let controlValue = LibraryCameraControl(action: action)
    }
    
    func openLibrary() {
        print(#function)
    }
    
}
