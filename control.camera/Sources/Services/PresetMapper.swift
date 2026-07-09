//
//  PresetMapper.swift
//  control.camera
//

import Foundation

/// Single source of truth for what is preset-able, what the base values
/// are, and how preset values turn back into control models
protocol PresetMapper {
    var presetableControlTypes: [ControlType] { get }

    /// Values that currently differ from the base settings
    func snapshot(from storage: CameraSettingsStorage) -> [String: PresetValue]

    /// Control model for restoring: from the preset value,
    /// or the base value when the preset does not include it
    func makeControl(for type: ControlType, from value: PresetValue?) -> CameraControl?

    /// Human-readable value for the manage screen
    func displayValue(for value: PresetValue) -> String
}

class PresetMapperImplementation: PresetMapper {

    var presetableControlTypes: [ControlType] {
        return [.frame, .borderColor, .noise, .contrast, .red, .green, .blue, .blackWhite]
    }

    func snapshot(from storage: CameraSettingsStorage) -> [String: PresetValue] {
        var values = [String: PresetValue]()

        for type in presetableControlTypes {
            guard let value = currentValue(for: type, in: storage),
                  value != defaultValue(for: type) else {
                continue
            }

            values[type.rawValue] = value
        }

        return values
    }

    func makeControl(for type: ControlType, from value: PresetValue?) -> CameraControl? {
        let value = value ?? defaultValue(for: type)

        switch (type, value) {
        case (.frame, .number(let width)):
            return FrameCameraControl(selected: width)

        case (.borderColor, .string(let colorName)):
            let control = BorderColorCameraControl()

            if case let .array(existing) = control.valueType {
                control.valueType = .array(ArrayControlValue(array: existing.array, selected: colorName))
            }

            return control

        case (.noise, .number(let level)):
            return NoiseCameraControl(selected: level)

        case (.contrast, .number(let level)):
            return ColorCorrectionCameraControl(channel: .contrast, selected: level)

        case (.red, .number(let level)):
            return ColorCorrectionCameraControl(channel: .red, selected: level)

        case (.green, .number(let level)):
            return ColorCorrectionCameraControl(channel: .green, selected: level)

        case (.blue, .number(let level)):
            return ColorCorrectionCameraControl(channel: .blue, selected: level)

        case (.blackWhite, .bool(let isActive)):
            let control = BlackWhiteCameraControl()
            control.valueType = .simple(SimpleControlValue(isActive: isActive))

            return control

        default:
            return nil
        }
    }

    func displayValue(for value: PresetValue) -> String {
        switch value {
        case .number(let number):
            return Int(number).description
        case .string(let string):
            return string
        case .bool(let isActive):
            return isActive ? "On" : "Off"
        }
    }

}

private extension PresetMapperImplementation {

    func defaultValue(for type: ControlType) -> PresetValue {
        switch type {
        case .borderColor:
            return .string(BorderColorCameraControl.BorderColor.white.rawValue)
        case .blackWhite:
            return .bool(false)
        default:
            return .number(0)
        }
    }

    func currentValue(for type: ControlType, in storage: CameraSettingsStorage) -> PresetValue? {
        switch type {
        case .frame:
            return (storage.frameControl).map { .number($0.selectedWidth) }
        case .borderColor:
            return (storage.borderColorControl).map { .string($0.selectedColor.rawValue) }
        case .noise:
            return (storage.noiseControl).map { .number($0.selectedLevel) }
        case .contrast:
            return (storage.contrastControl).map { .number($0.selectedLevel) }
        case .red:
            return (storage.redControl).map { .number($0.selectedLevel) }
        case .green:
            return (storage.greenControl).map { .number($0.selectedLevel) }
        case .blue:
            return (storage.blueControl).map { .number($0.selectedLevel) }
        case .blackWhite:
            return (storage.blackWhiteControl).map { .bool($0.isActive) }
        default:
            return nil
        }
    }

}
