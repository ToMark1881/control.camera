//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RootViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 30.08.2022.
//

import UIKit

class RootViewController: BaseViewController {
    
    //MARK: - Injected
    var output: RootViewOutputProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension RootViewController: RootViewInputProtocol {

}
