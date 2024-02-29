//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ActionSwitchControlRouter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class ActionSwitchControlRouter: BaseRouter {
    
    // MARK: - Injected
    weak var output: ActionSwitchControlRouterOutputProtocol!
    weak var view: BaseViewControllerProtocol!
    
}

extension ActionSwitchControlRouter: ActionSwitchControlRouterInputProtocol {
    
    // MARK: - Present
    
    // MARK: - Dismiss
    
}
