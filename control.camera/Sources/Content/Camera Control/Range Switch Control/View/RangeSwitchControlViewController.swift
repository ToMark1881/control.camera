//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeSwitchControlViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class RangeSwitchControlViewController: BaseViewController {
    
    //MARK: - Injected
    
    var output: RangeSwitchControlViewOutputProtocol!

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var switchNameLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var linesImageView: UIImageView!
    
    var rangeData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.onViewDidLoad()
    }

}

extension RangeSwitchControlViewController: RangeSwitchControlViewInputProtocol {
    
    func update(with props: RangeSwitchViewProps) {
        switchNameLabel.text = props.title
        rangeData = props.range
        pickerView.reloadAllComponents()
        
        pickerView.selectRow(props.selectedIndex, inComponent: 0, animated: false)
    }
    
}

extension RangeSwitchControlViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        output.didSelect(index: row)
    }
    
}

extension RangeSwitchControlViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rangeData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if #available(iOS 14.0, *) { pickerView.subviews[1].backgroundColor = .clear }

        let modeLabel = UILabel()
        modeLabel.font = UIFont(name: "Touch Sans One Regular", size: 16.0)
        modeLabel.textColor = .white
        modeLabel.text = rangeData[row]
        modeLabel.textAlignment = .center
        
        return modeLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return (pickerView.frame.height * 2) / 3
    }
    
}
