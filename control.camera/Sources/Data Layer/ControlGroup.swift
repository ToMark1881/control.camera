//
//  ControlGroup.swift
//  control.camera
//

import Foundation

/// Semantic groups of the camera controls. The order of the cases
/// defines the order of the sections in the controls list
enum ControlGroup: CaseIterable {
    case camera
    case composition
    case effects
    case presets
    case interface

    var title: String {
        switch self {
        case .camera:
            return "Camera"
        case .composition:
            return "Composition"
        case .effects:
            return "Effects"
        case .presets:
            return "Presets"
        case .interface:
            return "Interface"
        }
    }
}

extension ControlType {

    var group: ControlGroup {
        switch self {
        case .flash, .device, .zoom, .focus, .exposure, .iso, .whiteBalance:
            return .camera
        case .form, .format, .frame, .borderColor:
            return .composition
        case .contrast, .red, .green, .blue, .blackWhite, .noise:
            return .effects
        case .savePreset, .selectPreset, .managePresets:
            return .presets
        case .ui, .library, .arrange, .shutter, .empty:
            return .interface
        }
    }

}
