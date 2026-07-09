//
//  PresetsStorage.swift
//  control.camera
//

import Foundation

protocol PresetsStorage: AnyObject {
    var presets: [CameraPreset] { get }
    var selectedPresetId: UUID? { get set }
    var selectedPreset: CameraPreset? { get }

    @discardableResult
    func createPreset(values: [String: PresetValue]) -> CameraPreset
    func updatePreset(id: UUID, values: [String: PresetValue])
    func renamePreset(id: UUID, name: String)
    func deletePreset(id: UUID)
    func preset(named name: String) -> CameraPreset?
}

final class PresetsStorageImplementation: PresetsStorage {

    private enum Constants {
        static let presetsKey = "userDefaultsPresetsKey"
        static let selectedPresetKey = "userDefaultsSelectedPresetKey"
        static let defaultNamePrefix = "Preset"
    }

    static let `default` = PresetsStorageImplementation()

    private(set) lazy var presets: [CameraPreset] = loadPresets()

    var selectedPresetId: UUID? {
        get {
            return UserDefaults.standard.string(forKey: Constants.selectedPresetKey).flatMap(UUID.init)
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue.uuidString, forKey: Constants.selectedPresetKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.selectedPresetKey)
            }
        }
    }

    var selectedPreset: CameraPreset? {
        return presets.first(where: { $0.id == selectedPresetId })
    }

    @discardableResult
    func createPreset(values: [String: PresetValue]) -> CameraPreset {
        let preset = CameraPreset(id: UUID(),
                                  name: nextAvailableName(),
                                  values: values,
                                  updatedAt: Date())
        presets.append(preset)
        saveToStorage()

        return preset
    }

    func updatePreset(id: UUID, values: [String: PresetValue]) {
        guard let index = presets.firstIndex(where: { $0.id == id }) else { return }

        presets[index].values = values
        presets[index].updatedAt = Date()
        saveToStorage()
    }

    func renamePreset(id: UUID, name: String) {
        guard let index = presets.firstIndex(where: { $0.id == id }) else { return }

        presets[index].name = name
        presets[index].updatedAt = Date()
        saveToStorage()
    }

    func deletePreset(id: UUID) {
        presets.removeAll(where: { $0.id == id })

        if selectedPresetId == id {
            selectedPresetId = nil
        }

        saveToStorage()
    }

    func preset(named name: String) -> CameraPreset? {
        return presets.first(where: { $0.name == name })
    }

}

private extension PresetsStorageImplementation {

    func loadPresets() -> [CameraPreset] {
        guard let data = UserDefaults.standard.data(forKey: Constants.presetsKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([CameraPreset].self, from: data)
        } catch let error {
            print(error)
            return []
        }
    }

    func saveToStorage() {
        do {
            let data = try JSONEncoder().encode(presets)
            UserDefaults.standard.set(data, forKey: Constants.presetsKey)
        } catch let error {
            print(error)
        }
    }

    /// Preset names must stay unique, because the select control
    /// identifies presets by name
    func nextAvailableName() -> String {
        var number = presets.count + 1

        while preset(named: "\(Constants.defaultNamePrefix) \(number)") != nil {
            number += 1
        }

        return "\(Constants.defaultNamePrefix) \(number)"
    }

}
