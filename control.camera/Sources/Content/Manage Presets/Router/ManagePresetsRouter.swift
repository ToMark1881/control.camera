//  VIPER Template created by Vladyslav Vdovychenko
//
//  ManagePresetsRouter.swift
//  control.camera
//

import Foundation
import UIKit

protocol ManagePresetsRouterInput: AnyObject {

}

protocol ManagePresetsRouterOutput: AnyObject {

}

final class ManagePresetsRouter: BaseRouter {

    weak var output: ManagePresetsRouterOutput!
    weak var view: BaseViewControllerProtocol!

}

extension ManagePresetsRouter: ManagePresetsRouterInput {

    // MARK: - Present

    // MARK: - Dismiss

}
