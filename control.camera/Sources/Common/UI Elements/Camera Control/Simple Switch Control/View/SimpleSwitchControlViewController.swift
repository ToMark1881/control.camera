//  VIPER Template created by Vladyslav Vdovychenko
//  
//  SimpleSwitchControlViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class SimpleSwitchControlViewController: BaseViewController {
    
    //MARK: - Injected
    var output: SimpleSwitchControlViewOutputProtocol!

    @IBOutlet weak var switchValueLabel: UILabel!
    @IBOutlet weak var switchNameLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.onViewDidLoad()
        setupControllerForSimpleSwitch()
    }

}

extension SimpleSwitchControlViewController: SimpleSwitchControlViewInputProtocol {
    
    func update(with props: SimpleSwitchViewProps) {
        switchNameLabel.text = props.title
        switchValueLabel.text = props.currentValue
    }
    
}

private extension SimpleSwitchControlViewController {
    
    func setupControllerForSimpleSwitch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnSwitch))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func didTapOnSwitch(_ sender: UITapGestureRecognizer) {
        output.didChangeSimpleSwitchValue()
    }
    
}
