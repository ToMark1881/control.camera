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
    
    // MARK: - SwitchControlArrangable
    @IBOutlet weak var arrangeButton: UIButton!
    
    private var rangePickerView: RangePickerViewController?
    private var rangeData: [String] = [String]()
    private var elementHeight: CGFloat?
    
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

    @IBAction func didTapOnArrangeButton(_ sender: Any) {
        output.onArrangeButtonTap()
    }
}

extension ArraySwitchControlViewController: ArraySwitchControlViewInputProtocol {
    
    func update(with props: ArraySwitchViewProps) {
        switchNameLabel.text = props.title
        rangeData = props.array
        elementHeight = props.elementHeight
        
        rangePickerView?.reloadData()
        rangePickerView?.selectRow(at: props.selectedIndex)
    }
    
    func setEnabled(_ isEnabled: Bool) {
        switchNameLabel.textColor = isEnabled ? .white : .gray
        rangePickerView?.setEnabled(isEnabled)
        view.isUserInteractionEnabled = isEnabled
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
        return elementHeight ?? 10.0
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
