//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ArraySwitchControlViewInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol ArraySwitchControlViewInputProtocol: BaseViewControllerProtocol, SwitchControlArrangeable {
    func update(with props: ArraySwitchViewProps)
    func setEnabled(_ isEnabled: Bool)
}
