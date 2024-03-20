//
//  ShutterButtonCellViewModel.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.03.2024.
//

import UIKit

protocol ShutterButtonCellInput: AnyObject {
    func setShutterButton(enabled: Bool)
}

class ShutterButtonCellViewModel: BaseCollectionCellViewModel<ShutterButtonCollectionViewCell> {
    
    var action: (() -> Void)
    
    weak var shutterButton: UIButton?
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    override func setup(on cell: CellType) {
        cell.output = self
        shutterButton = cell.shutterButton
    }
    
}

extension ShutterButtonCellViewModel: ShutterButtonCellOutput {
    
    func onShutterButtonTap() {
        action()
    }
    
}

extension ShutterButtonCellViewModel: ShutterButtonCellInput {
    
    func setShutterButton(enabled: Bool) {
        shutterButton?.isEnabled = enabled
    }
    
}
