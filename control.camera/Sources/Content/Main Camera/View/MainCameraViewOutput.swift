//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraViewOutput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol MainCameraViewOutputProtocol: AnyObject {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()
    func onViewDidAppear()
    func onViewDidDisappear()
    func didSetupCameraLayer()
}
