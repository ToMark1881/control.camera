//
//  ControlContainerCellViewModel.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.03.2024.
//

import UIKit

class ControlContainerCellViewModel: BaseCollectionCellViewModel<ControlContainerCollectionViewCell> {
    
    var embeddedView: UIView
    
    init(embeddedView: UIView) {
        self.embeddedView = embeddedView
    }
    
    override func setup(on cell: CellType) {
        super.setup(on: cell)
        
        cell.contentView.backgroundColor = .clear
        cell.contentView.addSubview(embeddedView)
        embeddedView.pinViewToEdgesOfSuperview()
    }
    
}
