//
//  ShutterButtonCellViewModel.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.03.2024.
//

import Foundation

class ShutterButtonCellViewModel: BaseCollectionCellViewModel<ShutterButtonCollectionViewCell> {
    
    var action: (() -> Void)
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    override func setup(on cell: CellType) {
        cell.output = self
    }
    
}

extension ShutterButtonCellViewModel: ShutterButtonCellOutput {
    
    func onShutterButtonTap() {
        action()
    }
    
}
