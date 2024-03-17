//
//  ControlContainerCollectionViewCell.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.03.2024.
//

import UIKit

class ControlContainerCollectionViewCell: UICollectionViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentView.subviews.forEach({ $0.removeFromSuperview() })
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
