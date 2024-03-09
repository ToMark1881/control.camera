//
//  RangePickerViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 25.02.2024.
//

import UIKit

protocol RangePickerDelegate: AnyObject {
    func rangePickerView(_ rangePicker: RangePickerViewController, didSelectRow row: Int)
    func rangePickerView(_ rangePicker: RangePickerViewController, willSelectRow row: Int)
}

protocol RangePickerDataSource: AnyObject {
    func rangePickerView(numbersOfRowsForRangePicker rangePicker: RangePickerViewController) -> Int
    func rangePickerView(_ rangePicker: RangePickerViewController, titleForRow row: Int) -> String?
    func rangePickerView(_ rangePicker: RangePickerViewController, heightForRow row: Int) -> CGFloat
}

class RangePickerViewController: BaseViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    private var initialCenter = CGPoint(x: 0, y: 0)
    private var initialRow: Int = 0
    
    private var preselectedRow: Int?
    
    private var selectedRow: Int = 0 {
        didSet(oldValue) {
            if oldValue != selectedRow {
                TapticEngineGenerator.generateFeedback(.light)
                let value = dataSource.rangePickerView(self, titleForRow: selectedRow)
                valueLabel.text = value
                
                delegate?.rangePickerView(self, willSelectRow: selectedRow)
            }
        }
    }
    
    // MARK: - Public
    
    weak var delegate: RangePickerDelegate?
    weak var dataSource: RangePickerDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
    }
    
    public func reloadData() {
        let value = dataSource.rangePickerView(self, titleForRow: selectedRow)
        valueLabel?.text = value
    }
    
    func preselectRow(at index: Range<Int>.Index) {
        preselectedRow = index
    }
    
    func selectRow(at index: Range<Int>.Index) {
        selectedRow = index
    }
    
    func setValueHidden(_ isHidden: Bool) {
        valueLabel.isHidden = isHidden
    }
    
    func setEnabled(_ isEnabled: Bool) {
        valueLabel.textColor = isEnabled ? .white : .gray
        view.isUserInteractionEnabled = isEnabled
    }
    
}

private extension RangePickerViewController {
    
    @IBAction func didChangePan(_ sender: UIPanGestureRecognizer) {
        guard let piece = sender.view else { return }
        let translation = sender.translation(in: piece.superview)
        
        switch sender.state {
        case .began:
            initialCenter = piece.center
            initialRow = preselectedRow ?? selectedRow
            preselectedRow = nil
            
        case .changed:
            handlePanMovement(for: translation)
            
        case .ended:
            handlePanMovement(for: translation)
            delegate?.rangePickerView(self, didSelectRow: selectedRow)
        default:
            break
        }
    }
    
    func handlePanMovement(for point: CGPoint) {
        let step = dataSource.rangePickerView(self, heightForRow: 0)
        let minRow = 0
        let maxRow = dataSource.rangePickerView(numbersOfRowsForRangePicker: self) - 1
        
        let difference = -(initialCenter.y - point.y)
        let differenceDividedByStep = difference / step
        let row = Int(differenceDividedByStep.rounded(.toNearestOrAwayFromZero)) + initialRow
        
        if row >= maxRow {
            selectedRow = maxRow
        } else if row <= minRow {
            selectedRow = minRow
        } else {
            selectedRow = row
        }
    }
    
}
