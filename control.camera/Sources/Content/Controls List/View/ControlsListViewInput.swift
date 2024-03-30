//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ControlsListViewInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 29.03.2024.
//

import UIKit

protocol ControlsListViewInput: BaseViewControllerProtocol {
    func update(with sections: [TableSectionModel])
}
