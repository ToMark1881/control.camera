//
//  OnboardingViewProps.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

struct OnboardingViewProps {
    let cameraButtonStyle: ControlCameraButtonStyle
    let shouldShowCameraPermissionButton: Bool
    let shouldShowGalleryPermissionButton: Bool
    
    let sections: [CollectionSectionModel]
}
