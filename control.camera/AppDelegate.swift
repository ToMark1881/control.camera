//
//  AppDelegate.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                        
        self.configureRootViewController()
        
        return true
    }
    
}

// MARK: - Additional Methods
extension AppDelegate {
    
    fileprivate func configureRootViewController() {
        let rootWireframe = RootWireframe()
        var input: RootModuleInput?
        let viewController = rootWireframe.createModule(moduleInput: &input,
                                                        moduleOutput: nil)
        
        if let window = self.window {
            window.rootViewController = viewController
        }
    }
    
}

