//
//  PresetCellViewModel.swift
//  control.camera
//

import UIKit

class PresetCellViewModel: BaseTableCellViewModel<PresetTableViewCell> {

    let name: String
    let parametersDescription: String
    let onRename: ((String) -> Void)

    init(name: String,
         parametersDescription: String,
         onRename: @escaping ((String) -> Void)) {
        self.name = name
        self.parametersDescription = parametersDescription
        self.onRename = onRename
    }

    override func setup(on cell: CellType) {
        super.setup(on: cell)

        cell.nameTextField.text = name
        cell.parametersLabel.text = parametersDescription
        cell.onRename = onRename
    }

}
