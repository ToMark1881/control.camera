//  VIPER Template created by Vladyslav Vdovychenko
//
//  ManagePresetsPresenter.swift
//  control.camera
//

import Foundation

final class ManagePresetsPresenter: BasePresenter {

    weak var view: ManagePresetsViewInput!
    var router: ManagePresetsRouterInput!
    
    var presetsStorage: PresetsStorage!
    var presetMapper: PresetMapper!

    weak var moduleOutput: ManagePresetsModuleOutput?
    
}

// MARK: - View - Presenter
extension ManagePresetsPresenter: ManagePresetsViewOutput {

    func onViewDidLoad() {
        reloadUI()
    }

    func didRenamePreset(at index: Int, to name: String) {
        guard let preset = presetsStorage.presets[safe: index] else { return }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        // Names identify presets in the select control, so empty and
        // duplicated names are rejected, as well as the reserved "Off"
        guard !trimmedName.isEmpty,
              trimmedName != PresetConstants.virtualOffPresetName,
              trimmedName == preset.name || presetsStorage.preset(named: trimmedName) == nil else {
            reloadUI()
            return
        }

        guard trimmedName != preset.name else { return }

        presetsStorage.renamePreset(id: preset.id, name: trimmedName)
        moduleOutput?.didUpdatePresets()
        reloadUI()
    }

    func didDeletePreset(at index: Int) {
        guard let preset = presetsStorage.presets[safe: index] else { return }

        presetsStorage.deletePreset(id: preset.id)
        moduleOutput?.didUpdatePresets()
        reloadUI()
    }

}

// MARK: - Router - Presenter
extension ManagePresetsPresenter: ManagePresetsRouterOutput {

}

private extension ManagePresetsPresenter {

    func reloadUI() {
        let viewModels = presetsStorage.presets.enumerated().map { index, preset in
            PresetCellViewModel(name: preset.name,
                                parametersDescription: parametersDescription(for: preset),
                                onRename: { [weak self] name in
                                    self?.didRenamePreset(at: index, to: name)
                                })
        }

        let properties = ManagePresetsViewProperties(sections: [TableSectionModel(with: viewModels)],
                                                     isEmptyStateVisible: viewModels.isEmpty)
        view.update(with: properties)
    }

    func parametersDescription(for preset: CameraPreset) -> String {
        let items: [String] = presetMapper.presetableControlTypes.compactMap { type in
            guard let value = preset.values[type.rawValue] else {
                return nil
            }

            return "\(type.title): \(presetMapper.displayValue(for: value))"
        }

        return items.isEmpty ? "Base settings" : items.joined(separator: " · ")
    }

}
