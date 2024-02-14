//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeSwitchControlRouter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class RangeSwitchControlRouter: BaseRouter {
    
    // MARK: - Injected
    weak var output: RangeSwitchControlRouterOutputProtocol!
    weak var view: BaseViewControllerProtocol!
    
}

extension RangeSwitchControlRouter: RangeSwitchControlRouterInputProtocol {
    
    // MARK: - Present
    
    // MARK: - Dismiss
    
}
