//
//  ShutterButtonCollectionViewCell.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.03.2024.
//

import UIKit

protocol ShutterButtonCellOutput: AnyObject {
    func onShutterButtonTap()
}

class ShutterButtonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shutterButton: ShutterButton!
    
    weak var output: ShutterButtonCellOutput?
    
    @IBAction func didTapOnShutterButton(_ sender: Any) {
        output?.onShutterButtonTap()
    }
    
}
