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
    @IBOutlet weak var linesImageView: UIImageView!
    
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
    
    func reactOnControlChange() {
        TapticEngineGenerator.generateFeedback(.light)
    }
    
}

private extension SimpleSwitchControlViewController {
    
    func setupControllerForSimpleSwitch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnSwitch))
        self.view.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPanOnSwitch))
        self.view.addGestureRecognizer(pan)
    }
    
    @objc func didTapOnSwitch(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        output.didChangeSimpleSwitchValue()
    }
    
    @objc func didPanOnSwitch(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        output.didChangeSimpleSwitchValue()
    }
    
}
