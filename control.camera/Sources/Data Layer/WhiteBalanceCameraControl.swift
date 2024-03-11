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
    
    var title: String {
        return "White Balance"
    }
    
    var type: CameraControlType! {
        didSet {
            if let selected = controlValue.range.selected {
                let value = Int(selected)
                whiteBalanceType = .locked(kelvinTemp: value)
            } else {
                whiteBalanceType = .auto
            }
        }
    }
    
    var isLightControl: Bool {
        return true
    }
    
    var whiteBalanceType: WhiteBalanceType
    
    init(type: WhiteBalanceType) {
        self.whiteBalanceType = type
        
        var currentWhiteBalance: CGFloat?
        
        if case .locked(let value) = type {
            currentWhiteBalance = CGFloat(value)
        }
        
        let rangeControlValue = RangeControlValue(min: 2_000, max: 10_000, step: 200, selected: currentWhiteBalance)
        
        self.type = .rangeWithDefault(RangeWithDefaultControlValue(defaultValue: "Auto",
                                                                   range: rangeControlValue))
    }
    
    
}

extension WhiteBalanceCameraControl {
    
    var controlValue: RangeWithDefaultControlValue {
        guard case let .rangeWithDefault(value) = type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
    
}
