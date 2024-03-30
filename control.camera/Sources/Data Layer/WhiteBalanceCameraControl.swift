//
//  WhiteBalanceCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 11.03.2024.
//

import Foundation

enum WhiteBalanceType {
    case auto
    case locked(kelvinTemp: Int)
}

class WhiteBalanceCameraControl: CameraControl {
    
    var controlType: ControlType {
        return .whiteBalance
    }
    
    var valueType: CameraControlValueType! {
        didSet {
            if let selected = controlValue.range.selected {
                let value = Int(selected)
                whiteBalanceType = .locked(kelvinTemp: value)
            } else {
                whiteBalanceType = .auto
            }
        }
    }
    
    var elementHeight: CGFloat? {
        return 25.0
    }
    
    var defaultIndex: Range<Int>.Index? {
        return controlValue.range.range.firstIndex(where: { $0 == 5800 })
    }
    
    var whiteBalanceType: WhiteBalanceType
    
    init(type: WhiteBalanceType) {
        self.whiteBalanceType = type
        
        var currentWhiteBalance: CGFloat?
        
        if case .locked(let value) = type {
            currentWhiteBalance = CGFloat(value)
        }
        
        let rangeControlValue = RangeControlValue(min: 2_000, max: 10_000, step: 200, selected: currentWhiteBalance)
        
        self.valueType = .rangeWithDefault(RangeWithDefaultControlValue(defaultValue: "Auto",
                                                                   range: rangeControlValue))
    }
    
    
}

extension WhiteBalanceCameraControl {
    
    var controlValue: RangeWithDefaultControlValue {
        guard case let .rangeWithDefault(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        return value
    }
    
}
