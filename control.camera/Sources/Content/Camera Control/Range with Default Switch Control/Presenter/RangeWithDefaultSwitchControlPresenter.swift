//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RangeWithDefaultSwitchControlPresenter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

class RangeWithDefaultSwitchControlPresenter: BasePresenter {
    
    // MARK: - Injected
    
    weak var view: RangeWithDefaultSwitchControlViewInputProtocol!
    var router: RangeWithDefaultSwitchControlRouterInputProtocol!
    weak var moduleOutput: SwitchControlModuleOutput?
    
    var switchControl: CameraControl!
    
    private var controlValue: RangeWithDefaultControlValue {
        guard case let .rangeWithDefault(value) = switchControl.type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
}

// MARK: - Module Input
extension RangeWithDefaultSwitchControlPresenter: RangeWithDefaultSwitchControlModuleInput {
    
    func setupSwitch(for control: CameraControl) {
        guard case .rangeWithDefault = control.type else {
            fatalError("Wrong CameraControlType")
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
extension RangeWithDefaultSwitchControlPresenter: RangeWithDefaultSwitchControlViewOutputProtocol {
    
    func onViewDidLoad() {}
    
    func onDoubleTap() {
        let rangeControlValue = RangeControlValue(min: controlValue.range.min,
                                                  max: controlValue.range.max,
                                                  step: controlValue.range.step,
                                                  selected: nil)
        let rangeWithDefaultValue = RangeWithDefaultControlValue(defaultValue: controlValue.defaultValue,
                                                                 range: rangeControlValue)
        switchControl.type = .rangeWithDefault(rangeWithDefaultValue)
        moduleOutput?.didChangeSwitch(for: switchControl)
        reloadView()
        view.reactOnControlChange()
    }
    
    func didSelect(index: Range<Int>.Index) {
        guard !switchControl.isLightControl else {
            return
        }
        
        let selectedValue = controlValue.range.range[index]
        let rangeControlValue = RangeControlValue(min: controlValue.range.min,
                                                  max: controlValue.range.max,
                                                  step: controlValue.range.step,
                                                  selected: selectedValue)
        
        let rangeWithDefaultValue = RangeWithDefaultControlValue(defaultValue: controlValue.defaultValue,
                                                                 range: rangeControlValue)
        
        switchControl.type = .rangeWithDefault(rangeWithDefaultValue)
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
    func willSelect(index: Range<Int>.Index) {
        guard switchControl.isLightControl else {
            return
        }
        
        let selectedValue = controlValue.range.range[index]
        
        let rangeControlValue = RangeControlValue(min: controlValue.range.min,
                                                  max: controlValue.range.max,
                                                  step: controlValue.range.step,
                                                  selected: selectedValue)
        
        let rangeWithDefaultValue = RangeWithDefaultControlValue(defaultValue: controlValue.defaultValue,
                                                                 range: rangeControlValue)
        
        switchControl.type = .rangeWithDefault(rangeWithDefaultValue)
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
}

// MARK: - Router - Presenter
extension RangeWithDefaultSwitchControlPresenter: RangeWithDefaultSwitchControlRouterOutputProtocol {
    
}

private extension RangeWithDefaultSwitchControlPresenter {
    
    func reloadView() {
        let selectedIndex = controlValue.range.range.firstIndex(where: { $0 == controlValue.range.selected })
        let arrayOfStrings = controlValue.range.range.map { value in
            let rounded = Double(value).rounded(toPlaces: 2).description
            
            return rounded
        }
        
        let props: RangeWithDefaultSwitchViewProps = .init(title: switchControl.title,
                                                           array: arrayOfStrings,
                                                           selectedIndex: selectedIndex,
                                                           elementHeight: switchControl.elementHeight,
                                                           isDefaultValuePresented: controlValue.isDefaultSelected,
                                                           defaultValue: controlValue.defaultValue)
        view?.update(with: props)
    }
    
}
