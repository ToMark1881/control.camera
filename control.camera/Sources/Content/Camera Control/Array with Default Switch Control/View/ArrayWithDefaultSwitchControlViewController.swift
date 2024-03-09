//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ArrayWithDefaultSwitchControlViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class ArrayWithDefaultSwitchControlViewController: BaseViewController {
    
    private enum Constants {
        static let segueIdentifier = "RangePickerViewSegue"
    }
    
    //MARK: - Injected
    
    var output: ArrayWithDefaultSwitchControlViewOutputProtocol!
    

    @IBOutlet weak var rangePickerViewContainer: UIView!
    @IBOutlet weak var switchNameLabel: UILabel!
    @IBOutlet weak var switchDefaultValueLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var linesImageView: UIImageView!
    
    private var rangeData: [String] = [String]()
    private var elementHeight: CGFloat?
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

extension ArrayWithDefaultSwitchControlViewController: ArrayWithDefaultSwitchControlViewInputProtocol {
    
    func update(with props: ArrayWithDefaultSwitchViewProps) {
        switchNameLabel.text = props.title
        rangeData = props.array
        elementHeight = props.elementHeight
        
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
    
    func setEnabled(_ isEnabled: Bool) {
        switchNameLabel.textColor = isEnabled ? .white : .gray
        switchDefaultValueLabel.textColor = isEnabled ? .white : .gray
        rangePickerView?.setEnabled(isEnabled)
        view.isUserInteractionEnabled = isEnabled
    }
    
    func preselect(index: Range<Int>.Index) {
        rangePickerView?.preselectRow(at: index)
    }
    
}

extension ArrayWithDefaultSwitchControlViewController: RangePickerDataSource {
    
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

extension ArrayWithDefaultSwitchControlViewController: RangePickerDelegate {
    
    func rangePickerView(_ rangePicker: RangePickerViewController, didSelectRow row: Int) {
        output.didSelect(index: row)
    }
    
    func rangePickerView(_ rangePicker: RangePickerViewController, willSelectRow row: Int) {
        rangePicker.setValueHidden(false)
        switchDefaultValueLabel.isHidden = true
        output.willSelect(index: row)
    }
    
}
