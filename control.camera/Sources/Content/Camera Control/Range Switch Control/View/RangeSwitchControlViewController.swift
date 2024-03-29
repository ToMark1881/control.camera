//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeSwitchControlViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class RangeSwitchControlViewController: BaseViewController {
    
    private enum Constants {
        static let segueIdentifier = "RangePickerViewSegue"
    }
    
    //MARK: - Injected
    
    var output: RangeSwitchControlViewOutputProtocol!

    @IBOutlet weak var switchNameLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var linesImageView: UIImageView!
    
    // MARK: - SwitchControlArrangeable
    @IBOutlet weak var arrangeButton: UIButton!
    
    private var rangeData: [String] = [String]()
    private var rangePickerView: RangePickerViewController?
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

extension RangeSwitchControlViewController: RangeSwitchControlViewInputProtocol {
    
    func update(with props: RangeSwitchViewProps) {
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
    
    func setArrangeable(disabled: Bool) {
        rangePickerView?.view.isUserInteractionEnabled = !disabled
    }
    
}

extension RangeSwitchControlViewController: RangePickerDataSource {
    
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

extension RangeSwitchControlViewController: RangePickerDelegate {
    
    func rangePickerView(_ rangePicker: RangePickerViewController, didSelectRow row: Int) {
        output.didSelect(index: row)
    }
    
    func rangePickerView(_ rangePicker: RangePickerViewController, willSelectRow row: Int) {
        output.willSelect(index: row)
    }
    
}
