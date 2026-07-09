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

    /// Normalized (0...1) control cell rects within the camera container,
    /// keyed by the control grid index. Used for legibility sampling
    func didUpdateControlRegions(_ regions: [Int: CGRect])
}
