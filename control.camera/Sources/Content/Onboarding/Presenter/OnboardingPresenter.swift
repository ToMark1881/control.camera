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
        
        
        let props: OnboardingViewProps = .init(cameraButtonStyle: cameraButtonStyle,
                                               shouldShowCameraPermissionButton: shouldShowCameraPermissionButton,
                                               shouldShowGalleryPermissionButton: shouldShowGalleryPermissionButton)
        
        view.setup(with: props)
    }
    
    func openApplicationSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
}
