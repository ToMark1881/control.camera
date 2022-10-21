//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RootPresenter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 30.08.2022.
//

import Foundation

class RootPresenter: BasePresenter {
    
    // MARK: - Injected
    
    weak var view: RootViewInputProtocol!
    var router: RootRouterInputProtocol!
    weak var moduleOutput: RootModuleOutput?
    
}

// MARK: - Module Input
extension RootPresenter: RootModuleInput {
    
}

// MARK: - View - Presenter
extension RootPresenter: RootViewOutputProtocol {
    
    func didCompleteInitialisation() {
        router.presentOnboarding(with: self)
    }
    
}

// MARK: - Router - Presenter
extension RootPresenter: RootRouterOutputProtocol {
    
}

extension RootPresenter: OnboardingModuleOutput {
    
    func didFinishOnboarding() {
        router.presentMainCamera()
    }
    
}
