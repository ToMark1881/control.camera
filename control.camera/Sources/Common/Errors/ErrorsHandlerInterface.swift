//
//  ErrorsHandlerInterface.swift
//  TemplateApplication
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import Foundation

protocol ErrorsHandlerInterface: AnyObject {
    
    func handleError(_ error: NSError?)
    
    func handleWarning(_ title: String?, message: String?, proceed: @escaping () -> Void, cancel: @escaping () -> Void)
    
}
