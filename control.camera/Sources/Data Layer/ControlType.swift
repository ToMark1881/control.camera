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
    case format
    case frame
    case borderColor
    case noise
    case empty
    
    var title: String {
        switch self {
        case .flash:
            "Light"
        case .form:
            "Form"
        case .device:
            "Lens"
        case .zoom:
            "Zoom"
        case .ui:
            "UI"
        case .library:
            "Library"
        case .focus:
            "Focus"
        case .exposure:
            "Shutter Speed"
        case .iso:
            "ISO"
        case .whiteBalance:
            "White Balance"
        case .shutter:
            "Shutter"
        case .arrange:
            "Arrange"
        case .format:
            "File Format"
        case .frame:
            "Border"
        case .borderColor:
            "Border Color"
        case .noise:
            "Noise"
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
