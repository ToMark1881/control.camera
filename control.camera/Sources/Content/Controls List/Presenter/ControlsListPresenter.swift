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
    
    weak var moduleOutput: ControlsListModuleOutput?
    
}

// MARK: - Module Input
extension ControlsListPresenter: ControlsListModuleInput {
    
}

// MARK: - View - Presenter
extension ControlsListPresenter: ControlsListViewOutput {
    
}

// MARK: - Router - Presenter
extension ControlsListPresenter: ControlsListRouterOutput {
    
}
