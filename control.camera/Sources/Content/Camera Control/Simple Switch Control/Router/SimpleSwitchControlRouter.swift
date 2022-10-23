//  VIPER Template created by Vladyslav Vdovychenko
//  
//  SimpleSwitchControlRouter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class SimpleSwitchControlRouter: BaseRouter {
    
    // MARK: - Injected
    weak var output: SimpleSwitchControlRouterOutputProtocol!
    weak var view: BaseViewControllerProtocol!
    
}

extension SimpleSwitchControlRouter: SimpleSwitchControlRouterInputProtocol {
    
    // MARK: - Present
    
    // MARK: - Dismiss
    
}
