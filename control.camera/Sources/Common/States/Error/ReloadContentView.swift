//
//  ReloadContentView.swift
//  TemplateApplication
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import Foundation
import UIKit

protocol ReloadContentViewDelegate: AnyObject {
    func didTapOnReloadContentViewButton(_ view: ReloadContentView, sender: UIButton)
}

class ReloadContentView: UIView {
    
    @IBOutlet fileprivate weak var label: UILabel!
    @IBOutlet fileprivate weak var button: UIButton!
    
    weak var delegate: ReloadContentViewDelegate?

    @IBAction fileprivate func tapOnRetryButton(_ sender: UIButton) {
        self.delegate?.didTapOnReloadContentViewButton(self, sender: sender)
    }
}
