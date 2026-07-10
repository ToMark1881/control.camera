//
//  ControlsListViewModelBuilder.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 29.03.2024.
//

import Foundation

protocol ControlsListViewModelBuilder {
    func buildSections(for controls: [ControlType],
                       selectedControl: ControlType,
                       shouldIgnoreEmptyControl: Bool) -> [TableSectionModel]
}

class ControlsListViewModelBuilderImplementation: ControlsListViewModelBuilder {
    
    func buildSections(for controls: [ControlType],
                       selectedControl: ControlType,
                       shouldIgnoreEmptyControl: Bool) -> [TableSectionModel] {
        var controls = controls

        if shouldIgnoreEmptyControl {
            controls.removeAll(where: { $0 == .empty })
        }

        return ControlGroup.allCases.compactMap { group in
            let groupControls = controls.filter({ $0.group == group })

            guard !groupControls.isEmpty else {
                return nil
            }

            let viewModels = groupControls.map({ ControlCellViewModel(isSelected: $0 == selectedControl,
                                                                      type: $0) })

            return TableSectionModel(with: viewModels,
                                     header: ControlGroupHeaderViewModel(group: group))
        }
    }
    
}
