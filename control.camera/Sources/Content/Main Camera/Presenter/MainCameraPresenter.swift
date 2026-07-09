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
    weak var frameModuleInput: RangeWithDefaultSwitchControlModuleInput?
    weak var borderColorModuleInput: ArraySwitchControlModuleInput?
    weak var noiseModuleInput: RangeWithDefaultSwitchControlModuleInput?
    weak var contrastModuleInput: RangeWithDefaultSwitchControlModuleInput?
    weak var redModuleInput: RangeWithDefaultSwitchControlModuleInput?
    weak var greenModuleInput: RangeWithDefaultSwitchControlModuleInput?
    weak var blueModuleInput: RangeWithDefaultSwitchControlModuleInput?
    weak var blackWhiteModuleInput: SimpleSwitchControlModuleInput?
    weak var savePresetModuleInput: ActionSwitchControlModuleInput?
    weak var selectPresetModuleInput: ArraySwitchControlModuleInput?
    weak var managePresetsModuleInput: ActionSwitchControlModuleInput?
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
    var captureEventService: CaptureEventListeningService!
    var presetsStorage: PresetsStorage!
    var presetMapper: PresetMapper!

    /// setupSwitch fires didChangeSwitch synchronously, so programmatic
    /// rebuilds of the select preset control must not re-apply presets
    private var isRebuildingSelectPresetControl = false
    
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
            formatModuleInput,
            frameModuleInput,
            borderColorModuleInput,
            noiseModuleInput,
            contrastModuleInput,
            redModuleInput,
            greenModuleInput,
            blueModuleInput,
            blackWhiteModuleInput,
            savePresetModuleInput,
            selectPresetModuleInput,
            managePresetsModuleInput
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
    }
    
    func didSetupCameraLayer() {
        camera.startSession()
        setupControls()
    }
    
    func onViewWillAppear() {
        
    }
    
    func onViewWillDisappear() {
        
    }
    
    func onViewDidAppear() {
        captureEventService.start()
    }

    func onViewDidDisappear() {
        captureEventService.stop()
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
        
        // border
        let isBorderControlEnabled = !isInRAWFormat
        
        if isInRAWFormat {
            let controlValue = FrameCameraControl(selected: 0)
            frameModuleInput?.updateSwitch(for: controlValue)
        }
        frameModuleInput?.setEnabled(isBorderControlEnabled)
        
        // noise
        let isNoiseControlEnabled = !isInRAWFormat
        if isInRAWFormat {
            let controlValue = NoiseCameraControl(selected: 0)
            noiseModuleInput?.updateSwitch(for: controlValue)
        }
        noiseModuleInput?.setEnabled(isNoiseControlEnabled)
    }
    
    func didSetAutoISO() {
        resetExposureControl()
    }
    
    func didSetAutoExposure() {
        resetISOControl()
    }
    
    func willCapture() {
        view.setCaptureAnimation(active: true)
        soundService.play()
        shutterButtonInput?.setShutterButton(enabled: false)
    }
    
    func didCapture() {
        view.setCaptureAnimation(active: false)
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

        // The border color only makes sense while the border itself is on
        if let frameControl = control as? FrameCameraControl {
            borderColorModuleInput?.setEnabled(frameControl.isActive)
        }

        if let selectPresetControl = control as? SelectPresetCameraControl {
            handlePresetSelection(named: selectPresetControl.selectedPresetName)
        }
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
        setupFrameControl()
        setupBorderColorControl()
        setupNoiseControl()
        setupColorCorrectionControls()
        setupBlackWhiteControl()
        setupSavePresetControl()
        setupSelectPresetControl()
        setupManagePresetsControl()
        setupLibraryControl()
        setupArrangeControl()

        // The selection is persisted, but the effect controls start with the
        // base values, so the last selected preset is re-applied explicitly
        applySelectedPresetIfNeeded()
    }

    func applySelectedPresetIfNeeded() {
        guard let preset = presetsStorage.selectedPreset else {
            return
        }

        apply(values: preset.values)
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
    
    // MARK: - Frame control
    func setupFrameControl() {
        let controlValue = FrameCameraControl(selected: 0)

        frameModuleInput?.setupSwitch(for: controlValue)
        settingsStorage.store(controlValue)
    }

    // MARK: - Border color control
    func setupBorderColorControl() {
        let controlValue = BorderColorCameraControl()

        borderColorModuleInput?.setupSwitch(for: controlValue)
        settingsStorage.store(controlValue)

        borderColorModuleInput?.setEnabled(settingsStorage.frameControl?.isActive ?? false)
    }

    // MARK: - Noise control
    func setupNoiseControl() {
        let controlValue = NoiseCameraControl(selected: 0)

        noiseModuleInput?.setupSwitch(for: controlValue)
        settingsStorage.store(controlValue)
    }

    // MARK: - Color correction controls
    func setupColorCorrectionControls() {
        let channelInputs: [(ColorCorrectionCameraControl.Channel, RangeWithDefaultSwitchControlModuleInput?)] = [
            (.contrast, contrastModuleInput),
            (.red, redModuleInput),
            (.green, greenModuleInput),
            (.blue, blueModuleInput)
        ]

        for (channel, moduleInput) in channelInputs {
            let controlValue = ColorCorrectionCameraControl(channel: channel, selected: 0)

            moduleInput?.setupSwitch(for: controlValue)
            settingsStorage.store(controlValue)
        }
    }

    // MARK: - Black and white control
    func setupBlackWhiteControl() {
        let controlValue = BlackWhiteCameraControl()

        blackWhiteModuleInput?.setupSwitch(for: controlValue)
         settingsStorage.store(controlValue)
    }

    // MARK: - Preset controls
    
    func setupSavePresetControl() {
        let action: (() -> Void) = { [weak self] in
            self?.saveCurrentPreset()
        }

        let controlValue = SavePresetCameraControl(action: action)
        savePresetModuleInput?.setupSwitch(for: controlValue)
    }

    func setupSelectPresetControl() {
        let names = presetsStorage.presets.map({ $0.name })
        let controlValue = SelectPresetCameraControl(presetNames: names,
                                                     selected: presetsStorage.selectedPreset?.name)

        isRebuildingSelectPresetControl = true
        selectPresetModuleInput?.setupSwitch(for: controlValue)
        isRebuildingSelectPresetControl = false
    }

    func setupManagePresetsControl() {
        let action: (() -> Void) = { [weak self] in
            self?.openManagePresets()
        }

        let controlValue = ManagePresetsCameraControl(action: action)
        managePresetsModuleInput?.setupSwitch(for: controlValue)
    }

    func openManagePresets() {
        router.presentManagePresets(moduleOutput: self)
    }

    func saveCurrentPreset() {
        let values = presetMapper.snapshot(from: settingsStorage)

        if let selectedId = presetsStorage.selectedPresetId {
            presetsStorage.updatePreset(id: selectedId, values: values)
        } else {
            let preset = presetsStorage.createPreset(values: values)
            presetsStorage.selectedPresetId = preset.id
        }

        setupSelectPresetControl()
    }

    func handlePresetSelection(named name: String?) {
        guard !isRebuildingSelectPresetControl else {
            return
        }

        guard let name = name else {
            // The virtual "Off" preset: drops the selection
            // and resets every effect to the base values
            presetsStorage.selectedPresetId = nil
            apply(values: [:])
            return
        }

        guard let preset = presetsStorage.preset(named: name),
              preset.id != presetsStorage.selectedPresetId else {
            return
        }

        presetsStorage.selectedPresetId = preset.id
        apply(values: preset.values)
    }

    /// Restores every preset-able control: values from the preset,
    /// everything else back to the base settings
    func apply(values: [String: PresetValue]) {
        for type in presetMapper.presetableControlTypes {
            guard let control = presetMapper.makeControl(for: type, from: values[type.rawValue]) else {
                continue
            }

            settingsStorage.store(control)
            updateModuleInput(for: type, with: control)
        }
    }

    func updateModuleInput(for type: ControlType, with control: CameraControl) {
        switch type {
        case .frame:
            frameModuleInput?.updateSwitch(for: control)
        case .borderColor:
            borderColorModuleInput?.updateSwitch(for: control)
        case .noise:
            noiseModuleInput?.updateSwitch(for: control)
        case .contrast:
            contrastModuleInput?.updateSwitch(for: control)
        case .red:
            redModuleInput?.updateSwitch(for: control)
        case .green:
            greenModuleInput?.updateSwitch(for: control)
        case .blue:
            blueModuleInput?.updateSwitch(for: control)
        case .blackWhite:
            blackWhiteModuleInput?.updateSwitch(for: control)
        default:
            break
        }
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

extension MainCameraPresenter: ManagePresetsModuleOutput {

    func didUpdatePresets() {
        setupSelectPresetControl()
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
        frameModuleInput?.setupSwitch(for: settingsStorage.frameControl)
        borderColorModuleInput?.setupSwitch(for: settingsStorage.borderColorControl)
        borderColorModuleInput?.setEnabled(settingsStorage.frameControl?.isActive ?? false)
        noiseModuleInput?.setupSwitch(for: settingsStorage.noiseControl)
        contrastModuleInput?.setupSwitch(for: settingsStorage.contrastControl)
        redModuleInput?.setupSwitch(for: settingsStorage.redControl)
        greenModuleInput?.setupSwitch(for: settingsStorage.greenControl)
        blueModuleInput?.setupSwitch(for: settingsStorage.blueControl)
        blackWhiteModuleInput?.setupSwitch(for: settingsStorage.blackWhiteControl)
        setupSavePresetControl()
        setupSelectPresetControl()
        setupManagePresetsControl()
        setupLibraryControl()
        setupArrangeControl()
        setupUIControl()
        
        updateArrangeModeAppearance()
    }
    
}

extension MainCameraPresenter: CaptureEventListeningServiceOutput {

    func didReceiveCaptureEvent() {
        camera.capturePhoto()
    }

}
