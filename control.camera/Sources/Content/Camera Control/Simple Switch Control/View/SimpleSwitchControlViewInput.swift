//  VIPER Template created by Vladyslav Vdovychenko
//  
//  SimpleSwitchControlViewInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol SimpleSwitchControlViewInputProtocol: BaseViewControllerProtocol, SwitchControlArrangable {
    func update(with props: SimpleSwitchViewProps)
    func reactOnControlChange()
    func setEnabled(_ isEnabled: Bool)
}
