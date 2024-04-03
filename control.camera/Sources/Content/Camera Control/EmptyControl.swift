//
//  EmptyControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 26.03.2024.
//

import UIKit

class EmptyControl: UIViewController, SwitchControlModuleInput {
    
    var imageView: UIImageView?
    var controlIndex: Int!
    
    weak var output: SwitchControlModuleOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNewModuleSubview()
    }
    
    func addNewModuleSubview() {
        imageView = UIImageView(image: UIImage(named: "Module"))
        view.addSubview(imageView!)
        imageView?.pinViewToEdgesOfSuperview(topOffset: 3.0, bottomOffset: 3.0)
        imageView?.isHidden = true
        imageView?.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        imageView?.addGestureRecognizer(tapGesture)
        
    }
    
    func setupSwitch(for control: CameraControl) { }
    
    func setEnabled(_ isEnabled: Bool) { }
    
    func updateTitle(_ title: String) { }
    
    func setArrangeModeActive(_ isActive: Bool) {
        imageView?.isHidden = !isActive
        imageView?.isUserInteractionEnabled = isActive
    }
    
    func setControl(index: Int) {
        controlIndex = index
    }
    
    @objc
    func onTap() {
        TapticEngineGenerator.generateFeedback(.light)
        output?.onArrangeButtonTap(on: controlIndex)
    }

}
