//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeSwitchControlViewInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol RangeSwitchControlViewInputProtocol: BaseViewControllerProtocol, SwitchControlArrangable {
    func update(with props: RangeSwitchViewProps)
    func setEnabled(_ isEnabled: Bool)
}
