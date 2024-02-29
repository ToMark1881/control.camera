//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeWithDefaultSwitchControlViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class RangeWithDefaultSwitchControlViewController: BaseViewController {
    
    private enum Constants {
        static let segueIdentifier = "RangePickerViewSegue"
    }
    
    //MARK: - Injected
    
    var output: RangeWithDefaultSwitchControlViewOutputProtocol!
    

    @IBOutlet weak var rangePickerViewContainer: UIView!
    @IBOutlet weak var switchNameLabel: UILabel!
    @IBOutlet weak var switchDefaultValueLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var linesImageView: UIImageView!
    
    private var rangeData: [String] = [String]()
    private var rangePickerView: RangePickerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.onViewDidLoad()
        setupDoubleTapGesture()
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
    
    func setupDoubleTapGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(doubleTap)
    }
    
    @objc
    func onDoubleTap() {
        output.onDoubleTap()
    }

}

extension RangeWithDefaultSwitchControlViewController: RangeWithDefaultSwitchControlViewInputProtocol {
    
    func update(with props: RangeWithDefaultSwitchViewProps) {
        switchNameLabel.text = props.title
        rangeData = props.array
        
        rangePickerView?.reloadData()
        rangePickerView?.setValueHidden(props.isDefaultValuePresented)
        switchDefaultValueLabel.isHidden = !props.isDefaultValuePresented
        switchDefaultValueLabel.text = props.defaultValue
        
        if let index = props.selectedIndex {
            rangePickerView?.selectRow(at: index)
        }
    }
    
    func reactOnControlChange() {
        TapticEngineGenerator.generateFeedback(.light)
    }
    
}

extension RangeWithDefaultSwitchControlViewController: RangePickerDataSource {
    
    func rangePickerView(numbersOfRowsForRangePicker rangePicker: RangePickerViewController) -> Int {
        return rangeData.count
    }
    
    func rangePickerView(_ rangePicker: RangePickerViewController, titleForRow row: Int) -> String? {
        return rangeData[safe: row]
    }
    
    func rangePickerView(_ rangePicker: RangePickerViewController, heightForRow row: Int) -> CGFloat {
        return 20.0
    }
    
}

extension RangeWithDefaultSwitchControlViewController: RangePickerDelegate {
    
    func rangePickerView(_ rangePicker: RangePickerViewController, didSelectRow row: Int) {
        output.didSelect(index: row)
    }
    
    func rangePickerView(_ rangePicker: RangePickerViewController, willSelectRow row: Int) {
        rangePicker.setValueHidden(false)
        switchDefaultValueLabel.isHidden = true
        output.willSelect(index: row)
    }
    
}
