//  VIPER Template created by Vladyslav Vdovychenko
//  
//  OnboardingRouter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class OnboardingRouter: BaseRouter {
    
    // MARK: - Injected
    weak var output: OnboardingRouterOutputProtocol!
    weak var view: BaseViewControllerProtocol!
    
}

extension OnboardingRouter: OnboardingRouterInputProtocol {
    
    // MARK: - Present
    
    // MARK: - Dismiss
    
}
