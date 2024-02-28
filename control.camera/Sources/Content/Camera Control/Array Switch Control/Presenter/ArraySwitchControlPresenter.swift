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
        guard case let .array(value) = switchControl.type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
}

// MARK: - Module Input
extension ArraySwitchControlPresenter: ArraySwitchControlModuleInput {
    
    func setupSwitch(for control: CameraControl) {
        guard case .array = control.type else {
            fatalError("Wrong CameraControlType")
        }
        
        switchControl = control
        reloadView()
        
        moduleOutput?.didChangeSwitch(for: switchControl)
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
        
        switchControl.type = .array(arrayControlValue)
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
    func willSelect(index: Array<Int>.Index) {
        guard switchControl.isLightControl else {
            return
        }
        
        let selectedValue = controlValue.array[index]
        let arrayControlValue = ArrayControlValue(array: controlValue.array,
                                                  selected: selectedValue)
        
        switchControl.type = .array(arrayControlValue)
        moduleOutput?.didChangeSwitch(for: switchControl)
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
                                                selectedIndex: selectedIndex)
        
        view?.update(with: props)
    }
    
}
