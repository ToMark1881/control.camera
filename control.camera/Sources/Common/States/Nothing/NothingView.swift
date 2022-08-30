//
//  NothingView.swift
//  TemplateApplication
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import UIKit

class NothingView: UIView {

    @IBOutlet fileprivate weak var nothingDescriptionLabel: UILabel!
    
    func setNothingView(image: UIImage, title: String = "Хм...", description: String, buttonTitle: String, buttonImage: UIImage? = nil) {

        self.nothingDescriptionLabel.text = description
    }
    
}
