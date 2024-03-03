//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ActionSwitchControlPresenter.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

class ActionSwitchControlPresenter: BasePresenter {
    
    // MARK: - Injected
    
    weak var view: ActionSwitchControlViewInputProtocol!
    var router: ActionSwitchControlRouterInputProtocol!
    weak var moduleOutput: SwitchControlModuleOutput?
    
    var switchControl: CameraControl!
    
    private var controlValue: ActionControlValue {
        guard case let .action(action) = switchControl.type else {
            fatalError("Wrong CameraControlType")
        }
        
        return action
    }
}

// MARK: - Module Input
extension ActionSwitchControlPresenter: ActionSwitchControlModuleInput {
    
    func setupSwitch(for control: CameraControl) {
        guard case .action = control.type else {
            fatalError("Wrong CameraControlType")
        }
        
        switchControl = control
        reloadView()
    }
    
    func setEnabled(_ isEnabled: Bool) {
        view.setEnabled(isEnabled)
    }
    
}

// MARK: - View - Presenter
extension ActionSwitchControlPresenter: ActionSwitchControlViewOutputProtocol {
    
    func onViewDidLoad() {}
    
    func didTapOnSwitch() {
        view.reactOnControlChange()
        controlValue.action()
    }
    
}

// MARK: - Router - Presenter
extension ActionSwitchControlPresenter: ActionSwitchControlRouterOutputProtocol {
    
}

private extension ActionSwitchControlPresenter {
    
    func reloadView() {
        let props: ActionSwitchViewProps = .init(title: switchControl.title,
                                                 description: "123")
        
        view?.update(with: props)
    }
    
}
