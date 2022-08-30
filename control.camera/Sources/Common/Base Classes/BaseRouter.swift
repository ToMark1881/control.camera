//
//  BaseRouter.swift
//  
//
//  Created by macbook on 22.03.2021.
//

import Foundation

class BaseRouter {
    
    init() {
        Logger.shared.log("🆕 \(self)", type: .lifecycle)
    }
    
    deinit {
        Logger.shared.log("🗑 \(self)", type: .lifecycle)
    }
    
}
