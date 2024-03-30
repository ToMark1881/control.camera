//
//  ControlType.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.03.2024.
//

import Foundation

enum ControlType: String, CaseIterable, Codable {
    case flash
    case form
    case device
    case zoom
    case ui
    case library
    case focus
    case exposure
    case iso
    case whiteBalance
    case shutter
    case arrange
    case empty
    
    var title: String {
        switch self {
        case .flash:
            "Light"
        case .form:
            "Form"
        case .device:
            "Device"
        case .zoom:
            "Zoom"
        case .ui:
            "UI"
        case .library:
            "Library"
        case .focus:
            "Focus"
        case .exposure:
            "Exposure"
        case .iso:
            "ISO"
        case .whiteBalance:
            "White Balance"
        case .shutter:
            "Shutter"
        case .arrange:
            "Arrange"
        case .empty:
            ""
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let rawString = try container.decode(String.self)
        self = ControlType(rawValue: rawString) ?? .empty
    }
}
