//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraRouter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation
import UIKit

class MainCameraRouter: BaseRouter {
    
    // MARK: - Injected
    weak var output: MainCameraRouterOutputProtocol!
    weak var view: BaseViewControllerProtocol!
    
}

extension MainCameraRouter: MainCameraRouterInputProtocol {
    
    // MARK: - Present
    
    // MARK: - Dismiss
    
}
