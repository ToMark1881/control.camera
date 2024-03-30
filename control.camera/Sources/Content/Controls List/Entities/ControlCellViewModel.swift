//
//  ControlCellViewModel.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 29.03.2024.
//

import UIKit

class ControlCellViewModel: BaseTableCellViewModel<ControlTableViewCell> {
    
    let isSelected: Bool
    let type: ControlType
    
    enum Constants {
        static let radioButtonOnImage = UIImage(named: "Radio Button On")!
        static let radioButtonOffImage = UIImage(named: "Radio Button Off")!
    }
    
    init(isSelected: Bool, type: ControlType) {
        self.isSelected = isSelected
        self.type = type
    }
    
    override func setup(on cell: CellType) {
        super.setup(on: cell)
        
        cell.radioButtonImageView.image = isSelected ? Constants.radioButtonOnImage : Constants.radioButtonOffImage
        cell.nameLabel.text = type.title
    }
    
}
