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
    
    var type: CameraControlType {
        didSet {
            //            if let selected = controlValue.array.selected {
            //                exposureType = .locked(duration: selected)
            //            } else {
            //                exposureType = .auto
            //            }
        }
    }
    
    var isLightControl: Bool {
        return true
    }
    
    var elementHeight: CGFloat? {
        return 6.0
    }
    
    var exposureType: ExposureType
    
    init(min: CMTime, max: CMTime, exposure: ExposureType) {
        var currentExposureDuration: CMTime?
        
        if case .locked(let duration) = exposure {
            currentExposureDuration = duration
        }
        
        //        let range = RangeControlValue(min: min, max: max, step: 0.01, selected: lensPosition)
        //        self.type = .rangeWithDefault(RangeWithDefaultControlValue(defaultValue: "Auto", range: range))
        self.type = .arrayWithDefault(ArrayWithDefaultControlValue(defaultValue: "Auto",
                                                                   array: ArrayControlValue(array: ["1, 1000"],
                                                                                            selected: nil)))
        self.exposureType = exposure
    }
    
}

extension ExposureCameraControl {
    
    var controlValue: ArrayWithDefaultControlValue {
        guard case let .arrayWithDefault(value) = type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
    
    var timescaleArray: [Int] {
        [
            10_000,
            8_000,
            6_400,
            5_000,
            4_000,
            3_200,
            2_500,
            2_000,
            1+600,
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
