//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ActionSwitchControlViewOutput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol ActionSwitchControlViewOutputProtocol: AnyObject {
    func onViewDidLoad()
    func didTapOnSwitch()
    func onArrangeButtonTap()
}
