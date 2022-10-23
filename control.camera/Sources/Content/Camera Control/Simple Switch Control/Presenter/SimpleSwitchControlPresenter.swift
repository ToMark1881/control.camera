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
    weak var moduleOutput: SimpleSwitchControlModuleOutput?
    
    var switchType: CameraControlType!
    var switchValue: Bool!
    
}

// MARK: - Module Input
extension SimpleSwitchControlPresenter: SimpleSwitchControlModuleInput {
    
    func setupSwitch(for type: CameraControlType, defaultValue: Bool) {
        switchType = type
        switchValue = defaultValue
        reloadView()
    }
    
}

// MARK: - View - Presenter
extension SimpleSwitchControlPresenter: SimpleSwitchControlViewOutputProtocol {
    
    func onViewDidLoad() { }
    
    func didChangeSimpleSwitchValue() {
        switchValue.toggle()
        reloadView()
        view.reactOnControlChange()
        moduleOutput?.didChangeSwitch(for: switchType,
                                      value: switchValue)
    }
    
}

// MARK: - Router - Presenter
extension SimpleSwitchControlPresenter: SimpleSwitchControlRouterOutputProtocol {
    
}

private extension SimpleSwitchControlPresenter {
    
    func reloadView() {
        let currentValueDescription = switchValue ? "On" : "Off"
        
        let props: SimpleSwitchViewProps = .init(title: switchType.title,
                                                 currentValue: currentValueDescription)
        
        view?.update(with: props)
    }
    
}
