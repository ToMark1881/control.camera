//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ActionSwitchControlViewInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol ActionSwitchControlViewInputProtocol: BaseViewControllerProtocol {
    func update(with props: ActionSwitchViewProps)
    func reactOnControlChange()
    func setEnabled(_ isEnabled: Bool)
}
