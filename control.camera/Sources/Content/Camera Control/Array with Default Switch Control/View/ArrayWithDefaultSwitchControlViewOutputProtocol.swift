//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ArrayWithDefaultSwitchControlViewOutput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol ArrayWithDefaultSwitchControlViewOutputProtocol: AnyObject {
    func onViewDidLoad()
    func onDoubleTap()
    func didSelect(index: Range<Int>.Index)
    func willSelect(index: Range<Int>.Index)
}
