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
    weak var arrangeModuleInput: ActionSwitchControlModuleInput?
    
    var emptyModuleInputMulticast: MulticastDelegate<SwitchControlModuleInput?> = MulticastDelegate<SwitchControlModuleInput?>()
    
    weak var uiModuleInput: SimpleSwitchControlModuleInput?
    weak var libraryModuleInput: ActionSwitchControlModuleInput?
    weak var shutterButtonInput: ShutterButtonCellInput?
    
    var moduleBuilder: MainCameraModulesBuilder!
    var camera: CameraConfiguration!
    var liveApplier: CameraLiveApplier!
    var settingsStorage: CameraSettingsStorage!
    var arrangeService: ControlArrangeService!
    
    lazy var shutterButtonAction: (() -> Void) = {
        self.camera.capturePhoto()
    }
    
    private var allSwitchModuleInputes: [SwitchControlModuleInput?] {
        return [
            lightModuleInput,
            formModuleInput,
            deviceModuleInput,
            zoomModuleInput,
            focusModuleInput,
            exposureModuleInput,
            isoModuleInput,
            whiteBalanceModuleInput,
            arrangeModuleInput,
            uiModuleInput,
            libraryModuleInput
        ]
    }
    
}

// MARK: - MainCameraParentDisplayable
extension MainCameraPresenter: MainCameraParentDisplayable {
    
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
    
    func willCapture() {
        view.setPhotoBorder(active: true)
        shutterButtonInput?.setShutterButton(enabled: false)
    }
    
    func didCapture() {
        view.setPhotoBorder(active: false)
        shutterButtonInput?.setShutterButton(enabled: true)
    }
    
}

// MARK: - SwitchControlModuleOutput
extension MainCameraPresenter: SwitchControlModuleOutput {
    
    func didChangeSwitch(for control: CameraControl) {
        #if !targetEnvironment(simulator)
        settingsStorage.store(control)
        
        liveApplier.applyControlIfNeeded(control)
        #endif
    }
    
    func onArrangeButtonTap(on index: Int) {
        print(#function, index, settingsStorage.orderedControls[index].rawValue)
    }
    
}

private extension MainCameraPresenter {
    
    // MARK: - Main controls function
    func setupControls() {
        let sections = moduleBuilder.buildSections(for: settingsStorage.orderedControls)
        view.setup(with: sections)
        
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
        setupArrangeControl()
    }
    
    // MARK: - Light control
    func setupLightControl() {
        guard camera.settings.isFlashAvailable else {
            return
        }
        
        let controlValue = FlashCameraControl()
        lightModuleInput?.setupSwitch(for: controlValue)
    }
    
    // MARK: - Form control
    func setupFormControl() {
        let controlValue = FormCameraControl()
        
        formModuleInput?.setupSwitch(for: controlValue)
    }
    
    // MARK: - Device control
    func setupDeviceControl() {
        let availableDevices = camera.availableDevices
        let controlValue = VideoDeviceCameraControl(for: availableDevices)
        deviceModuleInput?.setupSwitch(for: controlValue)
    }
    
    // MARK: - Zoom control
    func setupZoomControl() {
        let maxZoom = min(10.0, camera.settings.maxZoom)
        
        let controlValue = ZoomCameraControl(min: camera.settings.minZoom,
                                             max: maxZoom,
                                             step: 0.1,
                                             selected: camera.settings.minZoom)
        zoomModuleInput?.setupSwitch(for: controlValue)
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
        
        focusModuleInput?.setupSwitch(for: controlValue)
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
        
        exposureModuleInput?.setupSwitch(for: controlValue)
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
        
        isoModuleInput?.setupSwitch(for: controlValue)
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
        
        whiteBalanceModuleInput?.setupSwitch(for: controlValue)
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
        
        uiModuleInput?.setupSwitch(for: controlValue)
    }
    
    // MARK: - Library control
    func setupLibraryControl() {
        let action: (() -> Void) = { [weak self] in
            self?.openLibrary()
        }
        
        let controlValue = LibraryCameraControl(action: action)
        
        libraryModuleInput?.setupSwitch(for: controlValue)
    }
    
    // MARK: - Arrange control
    func setupArrangeControl() {
        let action: (() -> Void) = { [weak self] in
            self?.changeArrangeMode()
        }
        
        let controlValue = ArrangeCameraControl(action: action)
        
        arrangeModuleInput?.setupSwitch(for: controlValue)
    }
    
    func openLibrary() {
        print(#function)
    }
    
    func changeArrangeMode() {
        arrangeService.isArrangeModeActivated.toggle()
        allSwitchModuleInputes.forEach({ $0?.setArrangeModeActive(arrangeService.isArrangeModeActivated) })
        emptyModuleInputMulticast.invoke({ $0?.setArrangeModeActive(arrangeService.isArrangeModeActivated) })
        
        arrangeService.isArrangeModeActivated ? camera.pauseSession() : camera.startSession()
    }
    
}
