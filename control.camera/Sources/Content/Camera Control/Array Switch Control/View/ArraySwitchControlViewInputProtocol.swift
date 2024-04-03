//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ArraySwitchControlViewInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol ArraySwitchControlViewInputProtocol: BaseViewControllerProtocol, SwitchControlArrangeable, SwitchControlViewInput {
    func update(with props: ArraySwitchViewProps)
}
