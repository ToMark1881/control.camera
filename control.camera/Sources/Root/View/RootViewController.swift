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
    
    // MARK: - Outlet

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var logoEllipseImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateEllipse()
    }

}

extension RootViewController: RootViewInputProtocol {

}

private extension RootViewController {
    
    func animateEllipse() {
        let startTransformation = CGAffineTransform(scaleX: 0.6, y: 0.6)
        let finalTransformation = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.3,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: { [weak self] in
            self?.logoEllipseImageView.transform = startTransformation
        }) { [weak self] _ in
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 0.3,
                           options: [],
                           animations: { [weak self] in
                self?.logoEllipseImageView.transform = finalTransformation
            }) { [weak self] _ in
                self?.output.didCompleteInitialisation()
            }
        }
    }
    
}
