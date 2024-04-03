//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeWithDefaultSwitchControlViewInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol RangeWithDefaultSwitchControlViewInputProtocol: BaseViewControllerProtocol, SwitchControlArrangeable, SwitchControlViewInput {
    func update(with props: RangeWithDefaultSwitchViewProps)
    func preselect(index: Range<Int>.Index)
}
