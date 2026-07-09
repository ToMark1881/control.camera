//  VIPER Template created by Vladyslav Vdovychenko
//
//  ManagePresetsViewInput.swift
//  control.camera
//

import UIKit

struct ManagePresetsViewProperties {
    let sections: [TableSectionModel]
    let isEmptyStateVisible: Bool
}

protocol ManagePresetsViewInput: BaseViewControllerProtocol {
    func update(with properties: ManagePresetsViewProperties)
}
