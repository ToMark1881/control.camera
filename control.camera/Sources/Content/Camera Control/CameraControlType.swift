//
//  CameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

struct ActionControlValue {
    let action: (() -> Void)
}

struct SimpleControlValue {
    let isActive: Bool
}

struct ArrayControlValue {
    let array: [String]
    
    let selected: String?
}

struct ArrayWithDefaultControlValue {
    let defaultValue: String
    let array: ArrayControlValue
    
    var isDefaultSelected: Bool {
        array.selected == nil
    }
}

struct RangeControlValue {
    let min: CGFloat
    let max: CGFloat
    let step: CGFloat
    
    let selected: CGFloat?
    
    var range: [CGFloat] {
        var items = [CGFloat]()
        
        for index in stride(from: min, to: max, by: step) {
            items.append(index)
        }
        
        return items
    }
}

struct RangeWithDefaultControlValue {
    let defaultValue: String
    let range: RangeControlValue
    
    var isDefaultSelected: Bool {
        range.selected == nil
    }
}

enum CameraControlType: Equatable {
    case simple(_ value: SimpleControlValue)
    case array(_ array: ArrayControlValue)
    case arrayWithDefault(_ array: ArrayWithDefaultControlValue)
    case range(_ range: RangeControlValue)
    case rangeWithDefault(_ range: RangeWithDefaultControlValue)
    case action(_ action: ActionControlValue)
    
    private var id: Int {
        switch self {
        case .simple:
            return 0
        case .array:
            return 1
        case .range:
            return 2
        case .rangeWithDefault:
            return 3
        case .action:
            return 4
        case .arrayWithDefault:
            return 5
        }
    }
    
    static func == (lhs: CameraControlType, rhs: CameraControlType) -> Bool {
        lhs.id == rhs.id
    }
}
