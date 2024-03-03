//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ArrayWithDefaultSwitchControlRouter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class ArrayWithDefaultSwitchControlRouter: BaseRouter {
    
    // MARK: - Injected
    weak var output: ArrayWithDefaultSwitchControlRouterOutputProtocol!
    weak var view: BaseViewControllerProtocol!
    
}

extension ArrayWithDefaultSwitchControlRouter: ArrayWithDefaultSwitchControlRouterInputProtocol {
    
    // MARK: - Present
    
    // MARK: - Dismiss
    
}
