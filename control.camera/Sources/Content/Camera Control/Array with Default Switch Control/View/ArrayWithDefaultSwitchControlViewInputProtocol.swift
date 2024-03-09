//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ArrayWithDefaultSwitchControlViewInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol ArrayWithDefaultSwitchControlViewInputProtocol: BaseViewControllerProtocol {
    func preselect(index: Range<Int>.Index)
    func update(with props: ArrayWithDefaultSwitchViewProps)
    func reactOnControlChange()
    func setEnabled(_ isEnabled: Bool)
}
