//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraPresenter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

class MainCameraPresenter: BasePresenter {
    
    // MARK: - Injected
    
    weak var view: MainCameraViewInputProtocol!
    var router: MainCameraRouterInputProtocol!
    weak var moduleOutput: MainCameraModuleOutput?
    
}

// MARK: - Module Input
extension MainCameraPresenter: MainCameraModuleInput {
    
}

// MARK: - View - Presenter
extension MainCameraPresenter: MainCameraViewOutputProtocol {
    
}

// MARK: - Router - Presenter
extension MainCameraPresenter: MainCameraRouterOutputProtocol {
    
}
