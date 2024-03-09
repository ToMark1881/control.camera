//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ArrayWithDefaultSwitchControlPresenter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

class ArrayWithDefaultSwitchControlPresenter: BasePresenter {
    
    // MARK: - Injected
    
    weak var view: ArrayWithDefaultSwitchControlViewInputProtocol!
    var router: ArrayWithDefaultSwitchControlRouterInputProtocol!
    weak var moduleOutput: SwitchControlModuleOutput?
    
    var switchControl: CameraControl!
    
    private var controlValue: ArrayWithDefaultControlValue {
        guard case let .arrayWithDefault(value) = switchControl.type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
}

// MARK: - Module Input
extension ArrayWithDefaultSwitchControlPresenter: ArrayWithDefaultSwitchControlModuleInput {
    
    func setupSwitch(for control: CameraControl) {
        guard case .arrayWithDefault = control.type else {
            fatalError("Wrong CameraControlType")
        }
        
        if let preselectedIndex = control.defaultIndex {
            view.preselect(index: preselectedIndex)
        }
        
        switchControl = control
        reloadView()
        
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
    func updateSwitch(for control: CameraControl) {
        guard case .arrayWithDefault = control.type else {
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
extension ArrayWithDefaultSwitchControlPresenter: ArrayWithDefaultSwitchControlViewOutputProtocol {
    
    func onViewDidLoad() {}
    
    func onDoubleTap() {
        let rangeControlValue = ArrayControlValue(array: controlValue.array.array, selected: nil)
        let arrayWithDefaultValue = ArrayWithDefaultControlValue(defaultValue: controlValue.defaultValue,
                                                                 array: rangeControlValue)
        switchControl.type = .arrayWithDefault(arrayWithDefaultValue)
        moduleOutput?.didChangeSwitch(for: switchControl)
        reloadView()
        view.reactOnControlChange()
    }
    
    func didSelect(index: Range<Int>.Index) {
        guard !switchControl.isLightControl else {
            return
        }
        
        let selectedValue = controlValue.array.array[index]
        let arrayControlValue = ArrayControlValue(array: controlValue.array.array,
                                                  selected: selectedValue)
        
        let arrayWithDefaultValue = ArrayWithDefaultControlValue(defaultValue: controlValue.defaultValue,
                                                                 array: arrayControlValue)
        
        switchControl.type = .arrayWithDefault(arrayWithDefaultValue)
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
    func willSelect(index: Range<Int>.Index) {
        guard switchControl.isLightControl else {
            return
        }
        
        let selectedValue = controlValue.array.array[index]
        
        let arrayControlValue = ArrayControlValue(array: controlValue.array.array,
                                                  selected: selectedValue)
        
        let arrayWithDefaultValue = ArrayWithDefaultControlValue(defaultValue: controlValue.defaultValue,
                                                                 array: arrayControlValue)
        
        switchControl.type = .arrayWithDefault(arrayWithDefaultValue)
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
}

// MARK: - Router - Presenter
extension ArrayWithDefaultSwitchControlPresenter: ArrayWithDefaultSwitchControlRouterOutputProtocol {
    
}

private extension ArrayWithDefaultSwitchControlPresenter {
    
    func reloadView() {
        let selectedIndex = controlValue.array.array.firstIndex(where: { $0 == controlValue.array.selected })
        let arrayOfStrings = controlValue.array.array.map({ $0 })
        
        let props: ArrayWithDefaultSwitchViewProps = .init(title: switchControl.title,
                                                           array: arrayOfStrings,
                                                           selectedIndex: selectedIndex,
                                                           elementHeight: switchControl.elementHeight,
                                                           isDefaultValuePresented: controlValue.isDefaultSelected,
                                                           defaultValue: controlValue.defaultValue)
        view?.update(with: props)
    }
    
}
