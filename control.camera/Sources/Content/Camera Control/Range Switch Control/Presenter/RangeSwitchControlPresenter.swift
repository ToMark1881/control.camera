//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeSwitchControlPresenter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

class RangeSwitchControlPresenter: BasePresenter {
    
    // MARK: - Injected
    
    weak var view: RangeSwitchControlViewInputProtocol!
    var router: RangeSwitchControlRouterInputProtocol!
    weak var moduleOutput: SwitchControlModuleOutput?
    
    var switchControl: CameraControl!
    
    private var controlValue: RangeControlValue {
        guard case let .range(value) = switchControl.valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        return value
    }
    
    private var controlIndex: Int!
}

// MARK: - Module Input
extension RangeSwitchControlPresenter: RangeSwitchControlModuleInput {
    
    func setControl(index: Int) {
        controlIndex = index
    }
    
    func setArrangeModeActive(_ isActive: Bool) {
        view.setArrangeModeActive(isActive)
    }
    
    func setupSwitch(for control: CameraControl) {
        guard case .range = control.valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        switchControl = control
        reloadView()
        
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
    func setEnabled(_ isEnabled: Bool) {
        view.setEnabled(isEnabled)
    }
    
}

// MARK: - View - Presenter
extension RangeSwitchControlPresenter: RangeSwitchControlViewOutputProtocol {
    
    func onViewDidLoad() {}
    
    func didSelect(index: Range<Int>.Index) {
        guard !switchControl.isLightControl else {
            return
        }
        
        let selectedValue = controlValue.range[index]
        let arrayControlValue = RangeControlValue(min: controlValue.min,
                                                  max: controlValue.max,
                                                  step: controlValue.step,
                                                  selected: selectedValue)
        
        switchControl.valueType = .range(arrayControlValue)
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
    func willSelect(index: Range<Int>.Index) {
        guard switchControl.isLightControl else {
            return
        }
        
        let selectedValue = controlValue.range[index]
        let arrayControlValue = RangeControlValue(min: controlValue.min,
                                                  max: controlValue.max,
                                                  step: controlValue.step,
                                                  selected: selectedValue)
        
        switchControl.valueType = .range(arrayControlValue)
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
    func onArrangeButtonTap() {
        moduleOutput?.onArrangeButtonTap(on: controlIndex)
    }
    
}

// MARK: - Router - Presenter
extension RangeSwitchControlPresenter: RangeSwitchControlRouterOutputProtocol {
    
}

private extension RangeSwitchControlPresenter {
    
    func reloadView() {
        let selectedIndex = controlValue.range.firstIndex(where: { $0 == controlValue.selected }) ?? 0        
        let arrayOfStrings: [String]
        
        if controlValue.step > 1 {
            arrayOfStrings =  controlValue.range.map { value in
                let rounded = Int(value).description
                
                return rounded
            }
        } else {
            arrayOfStrings = controlValue.range.map { value in
                let rounded = Double(value).rounded(toPlaces: 2).description
                
                return rounded
            }
        }
        
        let props: RangeSwitchViewProps = .init(title: switchControl.title,
                                                array: arrayOfStrings,
                                                selectedIndex: selectedIndex,
                                                elementHeight: switchControl.elementHeight)
        
        view?.update(with: props)
    }
    
}
