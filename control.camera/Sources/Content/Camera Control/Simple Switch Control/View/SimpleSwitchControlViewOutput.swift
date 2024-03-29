//  VIPER Template created by Vladyslav Vdovychenko
//  
//  SimpleSwitchControlViewOutput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol SimpleSwitchControlViewOutputProtocol: AnyObject {
    func onViewDidLoad()
    func didChangeSimpleSwitchValue()
    func onArrangeButtonTap()
}
