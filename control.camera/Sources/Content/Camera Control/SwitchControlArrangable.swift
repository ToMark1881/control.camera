//
//  SwitchControlArrangable.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 26.03.2024.
//

import UIKit

protocol SwitchControlArrangable where Self: UIViewController {
    var arrangeButton: UIButton! { get set }
    
    func didTapOnArrangeButton(_ sender: Any)
    func setArrangeModeActive(_ isActive: Bool)
}

extension SwitchControlArrangable {
    
    func setArrangeModeActive(_ isActive: Bool) {
        arrangeButton?.isHidden = !isActive
        
        view.layoutIfNeeded()
    }
    
}
