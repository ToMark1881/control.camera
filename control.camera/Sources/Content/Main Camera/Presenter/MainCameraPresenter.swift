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
    weak var focusModuleInput: RangeWithDefaultSwitchControlModuleInput?
    weak var exposureModuleInput: ArrayWithDefaultSwitchControlModuleInput?
    weak var isoModuleInput: ArrayWithDefaultSwitchControlModuleInput?
    weak var whiteBalanceModuleInput: RangeWithDefaultSwitchControlModuleInput?
    
    weak var uiModuleInput: SimpleSwitchControlModuleInput?
    weak var libraryModuleInput: ActionSwitchControlModuleInput?
    
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
        resetFocusControl()
        resetISOControl()
        resetExposureControl()
        resetWhiteBalanceControl()
    }
    
    func didSetAutoISO() {
        resetExposureControl()
    }
    
    func didSetAutoExposure() {
        resetISOControl()
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
        setupFocusControl()
        setupExposureControl()
        setupISOControl()
        setupWhiteBalanceControl()
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
        guard camera.settings.isLockedFocusSupported else {
            zoomModuleInput?.setEnabled(false)
            return
        }
        
        let maxZoom = min(10.0, camera.settings.maxZoom)
        
        let controlValue = ZoomCameraControl(min: camera.settings.minZoom,
                                             max: maxZoom,
                                             step: 0.1,
                                             selected: camera.settings.minZoom)
        
        zoomModuleInput?.updateSwitch(for: controlValue)
        zoomModuleInput?.setEnabled(true)
    }
    
    // MARK: - Focus
    func setupFocusControl() {
        guard camera.settings.isLockedFocusSupported else {
            return
        }
        
        let controlValue = FocusCameraControl(min: camera.settings.minLensPosition,
                                              max: camera.settings.maxLensPosition,
                                              focus: .auto)
        
        router.setupFocusControl(controlValue: controlValue,
                                 for: view.focusView,
                                 moduleInput: &focusModuleInput,
                                 moduleOutput: self)
    }
    
    func resetFocusControl() {
        guard camera.settings.isLockedFocusSupported else {
            focusModuleInput?.setEnabled(false)
            return
        }
        
        let controlValue = FocusCameraControl(min: camera.settings.minLensPosition,
                                              max: camera.settings.maxLensPosition,
                                              focus: .auto)
        
        focusModuleInput?.setEnabled(true)
        focusModuleInput?.updateSwitch(for: controlValue)
    }
    
    // MARK: - Exposure
    func setupExposureControl() {
        guard camera.settings.isCustomExposureSupported else {
            return
        }
        
        let controlValue = ExposureCameraControl(min: camera.settings.minExposure,
                                                 max: camera.settings.maxExposure,
                                                 exposure: .auto)
        
        router.setupExposureControl(controlValue: controlValue,
                                    for: view.exposureView,
                                    moduleInput: &exposureModuleInput,
                                    moduleOutput: self)
    }
    
    func resetExposureControl() {
        guard camera.settings.isCustomExposureSupported else {
            exposureModuleInput?.setEnabled(false)
            return
        }
        
        let controlValue = ExposureCameraControl(min: camera.settings.minExposure,
                                                 max: camera.settings.maxExposure,
                                                 exposure: .auto)
        
        exposureModuleInput?.setEnabled(true)
        exposureModuleInput?.updateSwitch(for: controlValue)
    }
    
    // MARK: - ISO
    func setupISOControl() {
        guard camera.settings.isCustomExposureSupported else {
            return
        }
        
        let controlValue = ISOCameraControl(min: camera.settings.minISO,
                                            max: camera.settings.maxISO,
                                            iso: .auto)
        
        router.setupISOControl(controlValue: controlValue,
                               for: view.isoView,
                               moduleInput: &isoModuleInput,
                               moduleOutput: self)
    }
    
    func resetISOControl() {
        guard camera.settings.isCustomExposureSupported else {
            isoModuleInput?.setEnabled(false)
            return
        }
        
        let controlValue = ISOCameraControl(min: camera.settings.minISO,
                                            max: camera.settings.maxISO,
                                            iso: .auto)
        isoModuleInput?.setEnabled(true)
        isoModuleInput?.updateSwitch(for: controlValue)
    }
    
    // MARK: - White balance
    func setupWhiteBalanceControl() {
        guard camera.settings.isLockedWhiteBalanceSupported else {
            return
        }
        
        let controlValue = WhiteBalanceCameraControl(type: .auto)
        
        router.setupWhiteBalanceControl(controlValue: controlValue,
                                        for: view.whiteBalanceView,
                                        moduleInput: &whiteBalanceModuleInput,
                                        moduleOutput: self)
    }
    
    func resetWhiteBalanceControl() {
        guard camera.settings.isLockedWhiteBalanceSupported else {
            whiteBalanceModuleInput?.setEnabled(false)
            return
        }
        
        let controlValue = WhiteBalanceCameraControl(type: .auto)
        
        whiteBalanceModuleInput?.setEnabled(true)
        whiteBalanceModuleInput?.updateSwitch(for: controlValue)
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
        
        router.setupLibraryControl(controlValue: controlValue,
                                   for: view.libraryView,
                                   moduleInput: &libraryModuleInput,
                                   moduleOutput: self)
    }
    
    func openLibrary() {
        print(#function)
    }
    
}
