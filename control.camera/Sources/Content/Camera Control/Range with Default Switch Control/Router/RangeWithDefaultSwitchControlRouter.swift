//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeWithDefaultSwitchControlRouter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class RangeWithDefaultSwitchControlRouter: BaseRouter {
    
    // MARK: - Injected
    weak var output: RangeWithDefaultSwitchControlRouterOutputProtocol!
    weak var view: BaseViewControllerProtocol!
    
}

extension RangeWithDefaultSwitchControlRouter: RangeWithDefaultSwitchControlRouterInputProtocol {
    
    // MARK: - Present
    
    // MARK: - Dismiss
    
}
