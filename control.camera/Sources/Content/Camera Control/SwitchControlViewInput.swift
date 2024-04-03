//
//  SwitchControlViewInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 31.03.2024.
//

import Foundation

protocol SwitchControlViewInput {
    func setEnabled(_ isEnabled: Bool)
    func updateTitle(_ title: String)
    func reactOnControlChange()
}

extension SwitchControlViewInput {
    
    func reactOnControlChange() {
        TapticEngineGenerator.generateFeedback(.light)
    }
    
}
