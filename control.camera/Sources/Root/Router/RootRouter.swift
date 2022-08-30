//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RootRouter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 30.08.2022.
//

import Foundation
import UIKit

class RootRouter: BaseRouter {
    
    // MARK: - Injected
    weak var output: RootRouterOutputProtocol!
    weak var view: BaseViewControllerProtocol!
    
}

extension RootRouter: RootRouterInputProtocol {
    
    // MARK: - Present
    
    // MARK: - Dismiss
    
}
