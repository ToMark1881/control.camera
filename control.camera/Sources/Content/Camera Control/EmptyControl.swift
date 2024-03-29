//
//  EmptyControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 26.03.2024.
//

import UIKit

class EmptyControl: UIViewController, SwitchControlModuleInput {
    
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNewModuleSubview()
    }
    
    func addNewModuleSubview() {
        imageView = UIImageView(image: UIImage(named: "Module"))
        view.addSubview(imageView!)
        imageView?.pinViewToEdgesOfSuperview()
        imageView?.isHidden = true
    }
    
    func setupSwitch(for control: CameraControl) { }
    
    func setEnabled(_ isEnabled: Bool) { }
    
    func setArrangeModeActive(_ isActive: Bool) {
        imageView?.isHidden = !isActive
    }

}
