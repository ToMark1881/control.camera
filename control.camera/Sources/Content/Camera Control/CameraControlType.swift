//
//  CameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

struct SimpleControlValue {
    let isActive: Bool
}

struct ArrayControlValue {
    let array: [String]
    
    let selected: String?
}

struct RangeControlValue {
    let min: Int
    let max: Int
    let step: Int
    
    let selected: Int?
    
    var range: [Int] {
        var items = [Int]()
        
        for index in stride(from: min, to: max, by: step) {
            items.append(index)
        }
        
        return items
    }
}

struct RangeWithDefaultValue {
    let defaultValue: String
    let range: RangeControlValue
}

enum CameraControlType: Equatable {
    case simple(_ value: SimpleControlValue)
    case array(_ array: ArrayControlValue)
    case range(_ range: RangeControlValue)
    case rangeWithDefault(_ range: RangeWithDefaultValue)
    
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
        }
    }
    
    static func == (lhs: CameraControlType, rhs: CameraControlType) -> Bool {
        lhs.id == rhs.id
    }
}
