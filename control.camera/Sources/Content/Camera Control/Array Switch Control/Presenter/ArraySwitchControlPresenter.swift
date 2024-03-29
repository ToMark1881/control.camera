//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ArraySwitchControlPresenter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

class ArraySwitchControlPresenter: BasePresenter {
    
    // MARK: - Injected
    
    weak var view: ArraySwitchControlViewInputProtocol!
    var router: ArraySwitchControlRouterInputProtocol!
    weak var moduleOutput: SwitchControlModuleOutput?
    
    var switchControl: CameraControl!
    
    private var controlValue: ArrayControlValue {
        guard case let .array(value) = switchControl.valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        return value
    }
}

// MARK: - Module Input
extension ArraySwitchControlPresenter: ArraySwitchControlModuleInput {
    
    func setArrangeModeActive(_ isActive: Bool) {
        view.setArrangeModeActive(isActive)
    }
    
    func setupSwitch(for control: CameraControl) {
        guard case .array = control.valueType else {
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
extension ArraySwitchControlPresenter: ArraySwitchControlViewOutputProtocol {
    
    func onViewDidLoad() {}
    
    func didSelect(index: Array<Int>.Index) {
        guard !switchControl.isLightControl else {
            return
        }
        
        let selectedValue = controlValue.array[index]
        let arrayControlValue = ArrayControlValue(array: controlValue.array,
                                                  selected: selectedValue)
        
        switchControl.valueType = .array(arrayControlValue)
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
    func willSelect(index: Array<Int>.Index) {
        guard switchControl.isLightControl else {
            return
        }
        
        let selectedValue = controlValue.array[index]
        let arrayControlValue = ArrayControlValue(array: controlValue.array,
                                                  selected: selectedValue)
        
        switchControl.valueType = .array(arrayControlValue)
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
    func onArrangeButtonTap() {
        moduleOutput?.onArrangeButtonTap()
    }
    
}

// MARK: - Router - Presenter
extension ArraySwitchControlPresenter: ArraySwitchControlRouterOutputProtocol {
    
}

private extension ArraySwitchControlPresenter {
    
    func reloadView() {
        let selectedIndex = controlValue.array.firstIndex(where: { $0 == controlValue.selected }) ?? 0
        let arrayOfStrings = controlValue.array.map({ $0 })
        
        let props: ArraySwitchViewProps = .init(title: switchControl.title,
                                                array: arrayOfStrings,
                                                selectedIndex: selectedIndex,
                                                elementHeight: switchControl.elementHeight)
        
        view?.update(with: props)
    }
    
}
