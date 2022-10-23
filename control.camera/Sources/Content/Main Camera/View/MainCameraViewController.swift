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

    @IBOutlet weak var exampleView: UIView!
    @IBOutlet weak var controlsContainerView: UIView!
    @IBOutlet weak var shutterButton: ShutterButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.onViewDidLoad()
    }

    @IBAction func didTapOnShutterButton(_ sender: Any) {
        output.didTapOnShutter()
    }
}

extension MainCameraViewController: MainCameraViewInputProtocol {

}

extension MainCameraViewController: CameraViewConfiguration {
    
    func setupCameraLayer(_ layer: CALayer) {
        view.layer.addSublayer(layer)
        layer.frame = view.layer.frame        
        view.bringSubviewToFront(shutterButton)
        view.bringSubviewToFront(controlsContainerView)
        
        output.didSetupCameraLayer()
        shutterButton.isEnabled = true
    }
    
}
