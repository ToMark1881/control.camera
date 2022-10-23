//
//  CameraControlType.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

enum CameraControlType {
//    case simpleSwitch // on, off
//    case set // 0, 3, 5, 10, 20
//    case range // 0-100
//    case rangeWithDefault // auto, 0-100
    case light
    case delayTime
    case exposure
    case ISO
    
    var title: String {
        switch self {
        case .light:
            return "Light"
        case .delayTime:
            return ""
        case .exposure:
            return "Exposure"
        case .ISO:
            return "ISO"
        }
    }
}
