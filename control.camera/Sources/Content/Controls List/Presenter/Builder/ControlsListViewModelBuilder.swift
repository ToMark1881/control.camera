//
//  ControlsListViewModelBuilder.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 29.03.2024.
//

import Foundation

protocol ControlsListViewModelBuilder {
    func buildSections(for controls: [ControlType], selectedControl: ControlType) -> [TableSectionModel]
}

class ControlsListViewModelBuilderImplementation: ControlsListViewModelBuilder {
    
    func buildSections(for controls: [ControlType], selectedControl: ControlType) -> [TableSectionModel] {
        let viewModels = controls.map({ ControlCellViewModel(isSelected: $0 == selectedControl, name: $0.title) })
        let section = TableSectionModel(with: viewModels)
        
        return [section]
    }
    
}
