//
//  MainCameraParentDisplayable.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.03.2024.
//

import Foundation

protocol MainCameraParentDisplayable: AnyObject {    
    var lightModuleInput: SimpleSwitchControlModuleInput? { get set }
    var formModuleInput: ArraySwitchControlModuleInput? { get set }
    var deviceModuleInput: ArraySwitchControlModuleInput? { get set }
    var zoomModuleInput: RangeSwitchControlModuleInput? { get set }
    var focusModuleInput: RangeWithDefaultSwitchControlModuleInput? { get set }
    var exposureModuleInput: ArrayWithDefaultSwitchControlModuleInput? { get set }
    var isoModuleInput: ArrayWithDefaultSwitchControlModuleInput? { get set }
    var whiteBalanceModuleInput: RangeWithDefaultSwitchControlModuleInput? { get set }
    var uiModuleInput: SimpleSwitchControlModuleInput? { get set }
    var libraryModuleInput: ActionSwitchControlModuleInput? { get set }
    var shutterButtonInput: ShutterButtonCellInput? { get set }
    var arrangeModuleInput: ActionSwitchControlModuleInput? { get set }
    
    var emptyModuleInputMulticast: MulticastDelegate<SwitchControlModuleInput?> { get set }
    
    var shutterButtonAction: (() -> Void) { get set }
}
