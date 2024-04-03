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
        guard case let .action(action) = switchControl.valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        return action
    }
    
    private var controlIndex: Int!
}

// MARK: - Module Input
extension ActionSwitchControlPresenter: ActionSwitchControlModuleInput {
    
    func setControl(index: Int) {
        controlIndex = index
    }
    
    func setArrangeModeActive(_ isActive: Bool) {
        if switchControl.couldBeArranged {
            view.setArrangeModeActive(isActive)
        }
        
        if switchControl.shouldBeBlockedDuringArrangement {
            view.setArrangeable(disabled: isActive)
        } else {
            view.changeAppearanceDuringArrangement(isActive)
        }
    }
    
    func setupSwitch(for control: CameraControl) {
        guard case .action = control.valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        switchControl = control
        reloadView()
    }
    
    func setEnabled(_ isEnabled: Bool) {
        view.setEnabled(isEnabled)
    }
    
    func updateTitle(_ title: String) {
        view.updateTitle(title)
    }
    
}

// MARK: - View - Presenter
extension ActionSwitchControlPresenter: ActionSwitchControlViewOutputProtocol {
    
    func onViewDidLoad() {}
    
    func didTapOnSwitch() {
        view.reactOnControlChange()
        controlValue.action()
    }
    
    func onArrangeButtonTap() {
        moduleOutput?.onArrangeButtonTap(on: controlIndex)
    }
    
}

// MARK: - Router - Presenter
extension ActionSwitchControlPresenter: ActionSwitchControlRouterOutputProtocol {
    
}

private extension ActionSwitchControlPresenter {
    
    func reloadView() {
        let props: ActionSwitchViewProps = .init(title: switchControl.title,
                                                 description: "")
        
        view?.update(with: props)
    }
    
}
