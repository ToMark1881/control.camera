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
        guard case let .simple(value) = switchControl.type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
}

// MARK: - Module Input
extension SimpleSwitchControlPresenter: SimpleSwitchControlModuleInput {
    
    func setupSwitch(for control: CameraControl) {
        guard case .simple = control.type else {
            fatalError("Wrong CameraControlType")
        }
        
        switchControl = control
        reloadView()
        
        moduleOutput?.didChangeSwitch(for: switchControl)
    }
    
}

// MARK: - View - Presenter
extension SimpleSwitchControlPresenter: SimpleSwitchControlViewOutputProtocol {
    
    func onViewDidLoad() {}
    
    func didChangeSimpleSwitchValue() {
        switchControl.type = .simple(SimpleControlValue(isActive: !controlValue.isActive))
        reloadView()
        view.reactOnControlChange()
        moduleOutput?.didChangeSwitch(for: switchControl)
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
