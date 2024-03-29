//
//  ExposureCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 03.03.2024.
//

import Foundation
import AVFoundation

enum ExposureType {
    case auto
    case locked(duration: CMTime)
}

class ExposureCameraControl: CameraControl {
    
    var title: String {
        return "Exposure"
    }
    
    var controlType: ControlType {
        return .exposure
    }
    
    var valueType: CameraControlValueType! {
        didSet {
            if let selected = controlValue.array.selected {
                let numbers = selected.components(separatedBy: "/") // should be 2 numbers
                if numbers.count != 2 { return }
                let numerator = CMTimeValue(Int(numbers.first!)!)
                let denominator = CMTimeScale(Int(numbers.last!)!)
                
                let time = CMTime(value: numerator, timescale: denominator)
                exposureType = .locked(duration: time)
            } else {
                exposureType = .auto
            }
        }
    }
    
    var elementHeight: CGFloat? {
        return 25.0
    }
    
    var defaultIndex: Range<Int>.Index? {
        return exposureArray.firstIndex(where: { $0 == 200 })
    }
    
    var exposureType: ExposureType
    var min: CMTime
    var max: CMTime
    
    init(min: CMTime, max: CMTime, exposure: ExposureType) {
        var currentExposureDuration: CMTime?
        
        if case .locked(let duration) = exposure {
            currentExposureDuration = duration
        }
        
        self.exposureType = exposure
        self.min = min
        self.max = max
        
        let array = exposureArray.map { value in
            return "1/\(value.description)"
        }
        
        var selectedExposureDuration: String?
        if let currentExposureDuration {
            selectedExposureDuration = "\(Int(currentExposureDuration.seconds))/\(Int(currentExposureDuration.timescale))"
        }
        
        let arrayControlValue = ArrayControlValue(array: array, selected: selectedExposureDuration)
        self.valueType = .arrayWithDefault(ArrayWithDefaultControlValue(defaultValue: "Auto",
                                                                   array: arrayControlValue))
    }
    
}

extension ExposureCameraControl {
    
    var controlValue: ArrayWithDefaultControlValue {
        guard case let .arrayWithDefault(value) = valueType else {
            fatalError("Wrong CameraControlValueType")
        }
        
        return value
    }
    
    var exposureArray: [Int] {
        [
            10_000,
            8_000,
            6_400,
            5_000,
            4_000,
            3_200,
            2_500,
            2_000,
            1_600,
            1_250,
            1_000,
            800,
            640,
            500,
            400,
            320,
            250,
            200,
            160,
            125,
            100,
            80,
            60,
            50,
            45,
            40,
            30,
            25,
            20,
            15,
            13,
            10,
            8,
            6,
            5,
            4,
            3,
            2,
            1
        ]
    }
    
}
