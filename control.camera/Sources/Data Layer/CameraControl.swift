//
//  CameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 12.02.2024.
//

import Foundation

protocol CameraControl {
    var title: String { get }
    var type: CameraControlType { get set }
    var isLightControl: Bool { get } 
    var elementHeight: CGFloat? { get }
}

extension CameraControl {
    var elementHeight: CGFloat? {
        return nil
    }
}
