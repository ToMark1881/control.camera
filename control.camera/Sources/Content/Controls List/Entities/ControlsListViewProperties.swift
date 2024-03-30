//
//  ControlsListViewProperties.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 30.03.2024.
//

import Foundation

struct ControlsListViewProperties {
    let sections: [TableSectionModel]
    let shouldShowRemoveButton: Bool
    let removeButtonStyle: ControlCameraButtonStyle = .accentYellow
}
