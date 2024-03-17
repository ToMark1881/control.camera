//
//  ISOCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 11.03.2024.
//

import Foundation
import AVFoundation

enum ISOType {
    case auto
    case locked(iso: Float)
}

class ISOCameraControl: CameraControl {
    
    var title: String {
        return "ISO"
    }
    
    var valueType: CameraControlValueType! {
        didSet {
            if let selected = controlValue.array.selected,
            let value = Float(selected) {
                isoType = .locked(iso: value)
            } else {
                isoType = .auto
            }
        }
    }
    
    var isLightControl: Bool {
        return true
    }
    
    var elementHeight: CGFloat? {
        return 25.0
    }
    
    var defaultIndex: Range<Int>.Index? {
        return allISOArray.firstIndex(where: { $0 == 400 })
    }
    
    var isoType: ISOType
    var min: Float
    var max: Float
    
    init(min: Float, max: Float, iso: ISOType) {
        var currentISO: Float?
        
        if case .locked(let value) = iso {
            currentISO = value
        }
        
        self.isoType = iso
        self.min = min
        self.max = max
        
        var currentISOString: String?
        if let currentISO {
            currentISOString = "\(Int(currentISO))"
        }
        
        let array: [String] = availableISOArray.map({ Int($0).description })
        let arrayControlValue = ArrayControlValue(array: array, selected: currentISOString)
        
        self.valueType = .arrayWithDefault(ArrayWithDefaultControlValue(defaultValue: "Auto",
                                                                   array: arrayControlValue))
    }
    
}

extension ISOCameraControl {
    
    var allISOArray: [Float] {
        [21, 40, 50, 64, 80, 100, 125, 160, 200, 250, 320, 400, 500, 640, 800, 1000, 1250, 1600, 3200, 6400, 8000, 12800]
    }
    
    var controlValue: ArrayWithDefaultControlValue {
        guard case let .arrayWithDefault(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        return value
    }
    
    var availableISOArray: [Float] {
        var availableISO = [Float]()
        
        for item in allISOArray {
            if item >= min && item <= max {
                availableISO.append(item)
            }
        }
        
        return availableISO
    }
    
}
