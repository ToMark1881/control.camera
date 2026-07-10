//
//  ControlGroupHeaderViewModel.swift
//  control.camera
//

import UIKit

class ControlGroupHeaderViewModel: TableSectionHeaderViewModel {

    let title: String

    init(group: ControlGroup) {
        self.title = group.title
    }

    func setup(on view: ControlGroupHeaderView) {
        view.titleLabel.text = title
    }

}
