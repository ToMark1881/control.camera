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
        var viewModels = controls.map({ ControlCellViewModel(isSelected: $0 == selectedControl,
                                                             type: $0) })
        if shouldIgnoreEmptyControl {
            viewModels.removeAll(where: { $0.type == .empty })
        }
        
        let section = TableSectionModel(with: viewModels)
        
        return [section]
    }
    
}
