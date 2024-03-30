//
//  CameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 12.02.2024.
//

import Foundation

protocol CameraControl {
    var title: String { get }
    var controlType: ControlType { get }
    var valueType: CameraControlValueType! { get set }
    /// If isLightControl = true than control will be applied on willSelect(index). Property used for controls with RangePickerView
    var isLightControl: Bool { get }
    /// Row height for RangeSpinner
    var elementHeight: CGFloat? { get }
    /// RangePicker default (pre-selected) index. Used for Array/Range switch controls with default value
    var defaultIndex: Range<Int>.Index? { get }
    var shouldBeBlockedDuringArrangement: Bool { get }
}

extension CameraControl {
    
    var title: String {
        return controlType.title
    }
    
    var isLightControl: Bool {
        return true
    }
    
    var elementHeight: CGFloat? {
        return nil
    }
    
    var defaultIndex: Range<Int>.Index? {
        return nil
    }
    
    var shouldBeBlockedDuringArrangement: Bool {
        return true
    }
    
}
