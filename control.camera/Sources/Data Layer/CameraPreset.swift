//
//  CameraPreset.swift
//  control.camera
//

import Foundation

enum PresetConstants {

    /// The name of the virtual "zero" preset. It is not stored in
    /// PresetsStorage: the select preset control always shows it as the
    /// first drum item, and choosing it resets every effect to the base
    /// values. User presets must never take this name, otherwise
    /// the select control could not tell them apart
    static let virtualOffPresetName = "Off"

}

/// A saved look. Only the values that differ from the base
/// settings are stored, keyed by ControlType.rawValue
struct CameraPreset: Codable {
    let id: UUID
    var name: String
    var values: [String: PresetValue]
    var updatedAt: Date
}

enum PresetValue: Codable, Equatable {
    case number(CGFloat)
    case string(String)
    case bool(Bool)
}
