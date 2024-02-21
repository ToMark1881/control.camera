//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ArraySwitchControlRouter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class ArraySwitchControlRouter: BaseRouter {
    
    // MARK: - Injected
    weak var output: ArraySwitchControlRouterOutputProtocol!
    weak var view: BaseViewControllerProtocol!
    
}

extension ArraySwitchControlRouter: ArraySwitchControlRouterInputProtocol {
    
    // MARK: - Present
    
    // MARK: - Dismiss
    
}
