//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class MainCameraViewController: BaseViewController {
    
    // MARK: - Injected
    
    var output: MainCameraViewOutputProtocol!

    @IBOutlet weak var cameraContainerContainer: UIView!
    @IBOutlet weak var cameraContainerView: CameraContainerView!
    
    @IBOutlet weak var flashView: UIView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var deviceView: UIView!
    
    @IBOutlet weak var zoomView: UIView!
    @IBOutlet weak var focusView: UIView!
    @IBOutlet weak var exposureView: UIView!
    
    @IBOutlet weak var isoView: UIView!
    @IBOutlet weak var whiteBalanceView: UIView!
    
    
    @IBOutlet weak var controlsContainerView: UIView!
    
    @IBOutlet weak var shutterButton: ShutterButton!
    @IBOutlet weak var libraryView: UIView!
    @IBOutlet weak var showUIView: UIView!
    
    @IBOutlet weak var cameraContainerAspectRatioConstraint: NSLayoutConstraint!
    
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
        cameraContainerView.layer.addSublayer(layer)
        cameraContainerView.cameraLayer = layer
        layer.frame = cameraContainerView.layer.frame
        
        view.bringSubviewToFront(shutterButton)
        view.bringSubviewToFront(controlsContainerView)
        
        output.didSetupCameraLayer()
        shutterButton.isEnabled = true
    }
    
    func showControlContainer(_ isActive: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.controlsContainerView.isHidden = !isActive
        }
    }
    
}
