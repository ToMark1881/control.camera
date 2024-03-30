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
    
    weak var moduleOutput: ControlsListModuleOutput?
    
    var selectedControl: ControlType!
    
}

// MARK: - Module Input
extension ControlsListPresenter: ControlsListModuleInput {
    
    func setup(with selectedControl: ControlType) {
        self.selectedControl = selectedControl
    }
    
}

// MARK: - View - Presenter
extension ControlsListPresenter: ControlsListViewOutput {
    
    func onViewDidLoad() {
        let sections = builder.buildSections(for: ControlType.allCases, selectedControl: selectedControl)
        
        view.update(with: sections)
    }
    
}

// MARK: - Router - Presenter
extension ControlsListPresenter: ControlsListRouterOutput {
    
}
