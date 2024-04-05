//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ControlsListPresenter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 29.03.2024.
//

import Foundation

final class ControlsListPresenter: BasePresenter {
    
    weak var view: ControlsListViewInput!
    var router: ControlsListRouterInput!
    var builder: ControlsListViewModelBuilder!
    var arrangeService: ControlArrangeService!
    
    weak var moduleOutput: ControlsListModuleOutput?
    
    var selectedControl: ControlType!
    var selectedIndex: Int!
    
}

// MARK: - Module Input
extension ControlsListPresenter: ControlsListModuleInput {
    
    func setup(with selectedControl: ControlType, at index: Int) {
        self.selectedControl = selectedControl
        self.selectedIndex = index
    }
    
}

// MARK: - View - Presenter
extension ControlsListPresenter: ControlsListViewOutput {
    
    func onViewDidLoad() {
        reloadUI()
    }
    
    func onRemoveControlTap() {
        update(control: .empty)
    }
    
    func didSelect(model: TableCellViewModel) {
        guard let model = model as? ControlCellViewModel else {
            return
        }
        
        let updatedControl = model.type
        update(control: updatedControl)
    }
    
}

// MARK: - Router - Presenter
extension ControlsListPresenter: ControlsListRouterOutput {
    
}

private extension ControlsListPresenter {
    
    func reloadUI() {
        let sections = builder.buildSections(for: ControlType.allCases,
                                             selectedControl: selectedControl,
                                             shouldIgnoreEmptyControl: true)
        
        let shouldShowRemoveButton = selectedControl != .empty
        let properties: ControlsListViewProperties = .init(sections: sections,
                                                           shouldShowRemoveButton: shouldShowRemoveButton)
        view.update(with: properties)
    }
    
    func update(control: ControlType) {
        arrangeService.update(control: control, at: selectedIndex)
        moduleOutput?.didUpdate(control: control)
        
        selectedControl = control
        reloadUI()
        
        view.dismiss(animated: true)
    }
    
}
