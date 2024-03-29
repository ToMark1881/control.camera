//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ActionSwitchControlViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class ActionSwitchControlViewController: BaseViewController {
    
    //MARK: - Injected
    var output: ActionSwitchControlViewOutputProtocol!

    @IBOutlet weak var switchValueLabel: UILabel!
    @IBOutlet weak var switchNameLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var linesImageView: UIImageView!
    
    // MARK: - SwitchControlArrangable
    @IBOutlet weak var arrangeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.onViewDidLoad()
        setupControllerForActionSwitch()
    }
    
    @IBAction func didTapOnArrangeButton(_ sender: Any) {
        output.onArrangeButtonTap()
    }
    
}

extension ActionSwitchControlViewController: ActionSwitchControlViewInputProtocol {
    
    func update(with props: ActionSwitchViewProps) {
        switchNameLabel.text = props.title
        switchValueLabel.text = props.description
    }
    
    func reactOnControlChange() {
        TapticEngineGenerator.generateFeedback(.light)
    }
    
    func setEnabled(_ isEnabled: Bool) {
        switchValueLabel.textColor = isEnabled ? .white : .gray
        switchNameLabel.textColor = isEnabled ? .white : .gray
        view.isUserInteractionEnabled = isEnabled
    }
    
    func setArrangable(disabled: Bool) {
        if disabled {
            view.gestureRecognizers?.forEach({ view.removeGestureRecognizer($0) })
        } else {
            setupControllerForActionSwitch()
        }
    }
    
}

private extension ActionSwitchControlViewController {
    
    func setupControllerForActionSwitch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnSwitch))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func didTapOnSwitch(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        output.didTapOnSwitch()
    }
    
}
