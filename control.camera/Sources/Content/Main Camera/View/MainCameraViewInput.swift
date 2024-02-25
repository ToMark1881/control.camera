//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraViewInput.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

protocol MainCameraViewInputProtocol: BaseViewControllerProtocol {
    var flashView: UIView! { get }
    var formView: UIView! { get }
    var deviceView: UIView! { get }
    
    var zoomView: UIView! { get }
}
