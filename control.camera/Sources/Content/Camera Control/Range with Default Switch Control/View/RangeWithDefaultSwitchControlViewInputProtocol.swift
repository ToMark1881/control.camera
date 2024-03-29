//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeWithDefaultSwitchControlViewInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol RangeWithDefaultSwitchControlViewInputProtocol: BaseViewControllerProtocol, SwitchControlArrangable {
    func update(with props: RangeWithDefaultSwitchViewProps)
    func reactOnControlChange()
    func setEnabled(_ isEnabled: Bool)
    func preselect(index: Range<Int>.Index)
}
