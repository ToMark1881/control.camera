//  VIPER Template created by Vladyslav Vdovychenko
//  
//  OnboardingPresenter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit
import AVFoundation
import Photos

class OnboardingPresenter: BasePresenter {
    
    // MARK: - Injected
    
    weak var view: OnboardingViewInputProtocol!
    var router: OnboardingRouterInputProtocol!
    weak var moduleOutput: OnboardingModuleOutput?
    
    var builder: MainCameraModulesBuilder!
    
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
    
    var shutterButtonAction: (() -> Void) = { }
    
}

// MARK: - Module Input
extension OnboardingPresenter: OnboardingModuleInput {
    
}

// MARK: - View - Presenter
extension OnboardingPresenter: OnboardingViewOutputProtocol {
    
    func onViewDidLoad() {
        updateView()
    }
    
    func didTapOnCameraButton() {
        view.dismiss(animated: true) {
            self.moduleOutput?.didFinishOnboarding()
        }
    }
    
    func didTapOnCameraPermissionButton() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
            openApplicationSettings()
            return
        }
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
            if response {
                DispatchQueue.main.async {
                    self?.updateView()
                }
            }
        }
    }
    
    func didTapOnGalleyPermissionButton() {
        var galleryPermission: PHAuthorizationStatus
        if #available(iOS 14, *) {
            galleryPermission = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        } else {
            galleryPermission = PHPhotoLibrary.authorizationStatus()
        }
        
        if galleryPermission == .denied {
            openApplicationSettings()
            return
        }
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                DispatchQueue.main.async {
                    self?.updateView()
                }
            }
        }
    }
    
}

// MARK: - Router - Presenter
extension OnboardingPresenter: OnboardingRouterOutputProtocol {
    
}

extension OnboardingPresenter: MainCameraParentDisplayable, SwitchControlModuleOutput {
    func didChangeSwitch(for control: CameraControl) { }
    func onArrangeButtonTap(on index: Int) {}
}

private extension OnboardingPresenter {
    
    func updateView() {
        let shouldShowCameraPermissionButton = !(AVCaptureDevice.authorizationStatus(for: .video) == .authorized)
        var shouldShowGalleryPermissionButton: Bool
        
        if #available(iOS 14, *) {
            shouldShowGalleryPermissionButton = !(PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized)
        } else {
            shouldShowGalleryPermissionButton = !(PHPhotoLibrary.authorizationStatus() == .authorized)
        }
        
        let cameraButtonStyle: ControlCameraButtonStyle = (!shouldShowCameraPermissionButton && !shouldShowGalleryPermissionButton) ? .accentYellow : .disabled
        
        let sections = builder.buildSections(for: [.flash, .zoom, .whiteBalance])
        
        let props: OnboardingViewProps = .init(cameraButtonStyle: cameraButtonStyle,
                                               shouldShowCameraPermissionButton: shouldShowCameraPermissionButton,
                                               shouldShowGalleryPermissionButton: shouldShowGalleryPermissionButton,
                                               sections: sections)
        
        view.setup(with: props)
        setupControlsForPreview()
    }
    
    func setupControlsForPreview() {
        setupZoomControl()
        setupLightControl()
        setupWhiteBalanceControl()
    }
    
    func setupZoomControl() {
        let controlValue = ZoomCameraControl(min: 1.0,
                                             max: 10.0,
                                             step: 0.1,
                                             selected: 1.0)
        zoomModuleInput?.setupSwitch(for: controlValue)
    }
    
    func setupLightControl() {
        let controlValue = FlashCameraControl()
        lightModuleInput?.setupSwitch(for: controlValue)
    }
    
    func setupWhiteBalanceControl() {
        let controlValue = WhiteBalanceCameraControl(type: .auto)
        
        whiteBalanceModuleInput?.setupSwitch(for: controlValue)
    }
    
    func openApplicationSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
}
