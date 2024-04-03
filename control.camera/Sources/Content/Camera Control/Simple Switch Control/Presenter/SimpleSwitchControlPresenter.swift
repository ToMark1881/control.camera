//  VIPER Template created by Vladyslav Vdovychenko
//  
//  SimpleSwitchControlPresenter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

class SimpleSwitchControlPresenter: BasePresenter {
    
    // MARK: - Injected
    
    weak var view: SimpleSwitchControlViewInputProtocol!
    var router: SimpleSwitchControlRouterInputProtocol!
    weak var moduleOutput: SwitchControlModuleOutput?
    
    var switchControl: CameraControl!
    
    private var controlValue: SimpleControlValue {
        guard case let .simple(value) = switchControl.valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        return value
    }
    
    private var controlIndex: Int!
}

// MARK: - Module Input
extension SimpleSwitchControlPresenter: SimpleSwitchControlModuleInput {
    
    func setControl(index: Int) {
        controlIndex = index
    }
    
    func setArrangeModeActive(_ isActive: Bool) {
        if switchControl.couldBeArranged {
            view.setArrangeModeActive(isActive)
        }
        
        if switchControl.shouldBeBlockedDuringArrangement {
            view.setArrangeable(disabled: isActive)
        }
    }
    
    func setupSwitch(for control: CameraControl) {
        guard case .simple = control.valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        switchControl = control
        reloadView()
        
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
    func setEnabled(_ isEnabled: Bool) {
        view.setEnabled(isEnabled)
    }
    
    func updateTitle(_ title: String) {
        view.updateTitle(title)
    }
    
}

// MARK: - View - Presenter
extension SimpleSwitchControlPresenter: SimpleSwitchControlViewOutputProtocol {
    
    func onViewDidLoad() {}
    
    func didChangeSimpleSwitchValue() {
        switchControl.valueType = .simple(SimpleControlValue(isActive: !controlValue.isActive))
        reloadView()
        view.reactOnControlChange()
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
    func onArrangeButtonTap() {
        moduleOutput?.onArrangeButtonTap(on: controlIndex)
    }
    
}

// MARK: - Router - Presenter
extension SimpleSwitchControlPresenter: SimpleSwitchControlRouterOutputProtocol {
    
}

private extension SimpleSwitchControlPresenter {
    
    func reloadView() {
        let currentValueDescription = controlValue.isActive ? "On" : "Off"
        
        let props: SimpleSwitchViewProps = .init(title: switchControl.title,
                                                 currentValue: currentValueDescription)
        
        view?.update(with: props)
    }
    
}
