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
    weak var formatModuleInput: ArraySwitchControlModuleInput?
    weak var arrangeModuleInput: ActionSwitchControlModuleInput?
    
    var emptyModuleInputMulticast: MulticastDelegate<SwitchControlModuleInput?> = MulticastDelegate<SwitchControlModuleInput?>()
    
    weak var uiModuleInput: SimpleSwitchControlModuleInput?
    weak var libraryModuleInput: ActionSwitchControlModuleInput?
    weak var shutterButtonInput: ShutterButtonCellInput?
    
    weak var controlsListModuleInput: ControlsListModuleInput?
    
    var moduleBuilder: MainCameraModulesBuilder!
    var camera: CameraConfiguration!
    var liveApplier: CameraLiveApplier!
    var settingsStorage: CameraSettingsStorage!
    var arrangeService: ControlArrangeService!
    var soundService: ShutterSoundService!
    var volumeButtonService: VolumeButtonListeningService!
    
    lazy var shutterButtonAction: (() -> Void) = {
        self.camera.capturePhoto()
    }
    
    private var allSwitchModuleInputs: [SwitchControlModuleInput?] {
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
            libraryModuleInput,
            formatModuleInput
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
        soundService.prepare()
        
        setupControls()
    }
    
    func didSetupCameraLayer() {
        camera.startSession()
    }
    
    func onViewWillAppear() {
        
    }
    
    func onViewWillDisappear() {
        
    }
    
    func onViewDidAppear() {
        volumeButtonService.start()
    }
    
    func onViewDidDisappear() {
        volumeButtonService.stop()
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
    
    func didChangePhotoFormat() {        
        // zoom
        let isZoomControlEnabled = camera.settings.isLockedFocusSupported && !isInRAWFormat
        
        if isInRAWFormat {
            let maxZoom = min(10.0, camera.settings.maxZoom)
            let controlValue = ZoomCameraControl(min: camera.settings.minZoom,
                                                 max: maxZoom,
                                                 step: 0.1,
                                                 selected: camera.settings.minZoom)
            zoomModuleInput?.updateSwitch(for: controlValue)
        }
        zoomModuleInput?.setEnabled(isZoomControlEnabled)
        
        // form
        let isFormControlEnabled = !isInRAWFormat
        
        if isInRAWFormat {
            let controlValue = FormCameraControl()
            formModuleInput?.updateSwitch(for: controlValue)
        }
        formModuleInput?.setEnabled(isFormControlEnabled)
    }
    
    func didSetAutoISO() {
        resetExposureControl()
    }
    
    func didSetAutoExposure() {
        resetISOControl()
    }
    
    func willCapture() {
        view.setPhotoBorder(active: true)
        soundService.play()
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
        guard let selectedControlType = arrangeService.controlArrangement[safe: index] else {
            return
        }
        
        router.presentControlsList(moduleInput: &controlsListModuleInput,
                                   moduleOutput: self)
        controlsListModuleInput?.setup(with: selectedControlType, at: index)
    }
    
}

private extension MainCameraPresenter {
    
    var isInRAWFormat: Bool {
        settingsStorage.formatControl.photoFormat == .raw
    }
    
    // MARK: - Main controls function
    func setupControls() {
        let sections = moduleBuilder.buildSections(for: arrangeService.controlArrangement)
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
        setupFormatControl()
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
        settingsStorage.store(controlValue)
    }
    
    // MARK: - Form control
    func setupFormControl() {
        let controlValue = FormCameraControl()
        
        formModuleInput?.setupSwitch(for: controlValue)
        settingsStorage.store(controlValue)
    }
    
    func resetFormControl() {
        let isControlEnabled = !isInRAWFormat
        let controlValue = FormCameraControl()
        
        formModuleInput?.updateSwitch(for: controlValue)
        formModuleInput?.setEnabled(isControlEnabled)
    }
    
    // MARK: - Device control
    func setupDeviceControl() {
        let availableDevices = camera.availableDevices
        let controlValue = VideoDeviceCameraControl(for: availableDevices)
        deviceModuleInput?.setupSwitch(for: controlValue)
        settingsStorage.store(controlValue)
    }
    
    // MARK: - Zoom control
    func setupZoomControl() {
        let maxZoom = min(10.0, camera.settings.maxZoom)
        
        let controlValue = ZoomCameraControl(min: camera.settings.minZoom,
                                             max: maxZoom,
                                             step: 0.1,
                                             selected: camera.settings.minZoom)
        zoomModuleInput?.setupSwitch(for: controlValue)
        settingsStorage.store(controlValue)
    }
    
    func resetZoomControl() {
        let isControlEnabled = camera.settings.isLockedFocusSupported && !isInRAWFormat
        let maxZoom = min(10.0, camera.settings.maxZoom)
        
        let controlValue = ZoomCameraControl(min: camera.settings.minZoom,
                                             max: maxZoom,
                                             step: 0.1,
                                             selected: camera.settings.minZoom)
        
        zoomModuleInput?.updateSwitch(for: controlValue)
        zoomModuleInput?.setEnabled(isControlEnabled)
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
        settingsStorage.store(controlValue)
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
        settingsStorage.store(controlValue)
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
        settingsStorage.store(controlValue)
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
        settingsStorage.store(controlValue)
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
        settingsStorage.store(controlValue)
    }
    
    // MARK: - Library control
    func setupLibraryControl() {
        let action: (() -> Void) = { [weak self] in
            self?.openLibrary()
        }
        
        let controlValue = LibraryCameraControl(action: action)
        
        libraryModuleInput?.setupSwitch(for: controlValue)
        settingsStorage.store(controlValue)
    }
    
    // MARK: - Format control
    func setupFormatControl() {
        let controlValue = FormatCameraControl()
        
        formatModuleInput?.setupSwitch(for: controlValue)
        settingsStorage.store(controlValue)
    }
    
    // MARK: - Arrange control
    func setupArrangeControl() {
        let action: (() -> Void) = { [weak self] in
            self?.changeArrangeMode()
        }
        
        let controlValue = ArrangeCameraControl(action: action)
        settingsStorage.store(controlValue)
        
        arrangeModuleInput?.setupSwitch(for: controlValue)
        settingsStorage.store(controlValue)
    }
    
    func changeArrangeMode() {
        arrangeService.isArrangeModeActivated.toggle()
        updateArrangeModeAppearance()
        
        arrangeService.isArrangeModeActivated ? camera.pauseSession() : camera.startSession()
    }
    
    func updateArrangeModeAppearance() {
        allSwitchModuleInputs.forEach({ $0?.setArrangeModeActive(arrangeService.isArrangeModeActivated) })
        emptyModuleInputMulticast.invoke({ $0?.setArrangeModeActive(arrangeService.isArrangeModeActivated) })
        
        let arrangeSwitchTitle = arrangeService.isArrangeModeActivated ? settingsStorage.arrangeControl.arrangementModeTitle : settingsStorage.arrangeControl.title
        arrangeModuleInput?.updateTitle(arrangeSwitchTitle)
    }
    
    // MARK: - Library control
    func openLibrary() {
        print(#function)
    }
    
}

extension MainCameraPresenter: ControlsListModuleOutput {
    
    func didUpdate(control: ControlType) {
        let sections = moduleBuilder.buildSections(for: arrangeService.controlArrangement)
        view.setup(with: sections)
    
        lightModuleInput?.setupSwitch(for: settingsStorage.flashControl)
        formModuleInput?.setupSwitch(for: settingsStorage.formControl)
        deviceModuleInput?.setupSwitch(for: settingsStorage.deviceControl)
        formatModuleInput?.setupSwitch(for: settingsStorage.formatControl)
        zoomModuleInput?.setupSwitch(for: settingsStorage.zoomControl)
        focusModuleInput?.setupSwitch(for: settingsStorage.focusControl)
        exposureModuleInput?.setupSwitch(for: settingsStorage.exposureControl)
        isoModuleInput?.setupSwitch(for: settingsStorage.isoControl)
        whiteBalanceModuleInput?.setupSwitch(for: settingsStorage.whiteBalanceControl)
        setupLibraryControl()
        setupArrangeControl()
        setupUIControl()
        
        updateArrangeModeAppearance()
    }
    
}

extension MainCameraPresenter: VolumeButtonListeningServiceOutput {
    
    func didTapVolumeButton() {
        camera.capturePhoto()
    }
    
}
