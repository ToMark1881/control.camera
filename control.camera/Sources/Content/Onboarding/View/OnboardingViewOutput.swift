//  VIPER Template created by Vladyslav Vdovychenko
//  
//  OnboardingViewOutput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol OnboardingViewOutputProtocol: AnyObject {
    func onViewDidLoad()
    func didTapOnCameraButton()
    func didTapOnCameraPermissionButton()
    func didTapOnGalleyPermissionButton()
}
