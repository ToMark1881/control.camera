//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class MainCameraViewController: BaseViewController {
    
    //MARK: - Injected
    var output: MainCameraViewOutputProtocol!

    @IBOutlet weak var shutterButton: ShutterButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapOnShutterButton(_ sender: Any) {
        
    }
}

extension MainCameraViewController: MainCameraViewInputProtocol {

}
