//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ArraySwitchControlViewOutput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol ArraySwitchControlViewOutputProtocol: AnyObject {
    func onViewDidLoad()
    func didSelect(index: Array<Int>.Index)
}
