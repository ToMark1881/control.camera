//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ArraySwitchControlViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class ArraySwitchControlViewController: BaseViewController {
    
    private enum Constants {
        static let segueIdentifier = "RangePickerViewSegue"
    }
    
    //MARK: - Injected
    
    var output: ArraySwitchControlViewOutputProtocol!

    @IBOutlet weak var switchNameLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var linesImageView: UIImageView!
    
    private var rangePickerView: RangePickerViewController?
    var rangeData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.onViewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueIdentifier,
           let controller = segue.destination as? RangePickerViewController {
            rangePickerView = controller
            
            rangePickerView?.delegate = self
            rangePickerView?.dataSource = self
        }
        
        super.prepare(for: segue, sender: sender)
    }

}

extension ArraySwitchControlViewController: ArraySwitchControlViewInputProtocol {
    
    func update(with props: ArraySwitchViewProps) {
        switchNameLabel.text = props.title
        rangeData = props.array
        rangePickerView?.reloadData()
        rangePickerView?.selectRow(at: props.selectedIndex)
    }
    
}

extension ArraySwitchControlViewController: RangePickerDataSource {
    
    func rangePickerView(numbersOfRowsForRangePicker rangePicker: RangePickerViewController) -> Int {
        return rangeData.count
    }
    
    func rangePickerView(_ rangePicker: RangePickerViewController, titleForRow row: Int) -> String? {
        return rangeData[safe: row]
    }
    
    func rangePickerView(_ rangePicker: RangePickerViewController, heightForRow row: Int) -> CGFloat {
        return 100.0
    }
    
}

extension ArraySwitchControlViewController: RangePickerDelegate {
    
    func rangePickerView(_ rangePicker: RangePickerViewController, didSelectRow row: Int) {
        output.didSelect(index: row)
    }
    
    func rangePickerView(_ rangePicker: RangePickerViewController, willSelectRow row: Int) {
        output.willSelect(index: row)
    }
    
}

extension ArraySwitchControlViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        output.didSelect(index: row)
    }
    
}
