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
        return "Exposure"
    }
    
    var type: CameraControlType {
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
        return ExposureCameraControl.timescaleArray.firstIndex(where: { $0 == 200 })
    }
    
    var isoType: ISOType
    
    init(min: Float, max: Float, iso: ISOType) {
        var currentISO: Float?
        
        if case .locked(let value) = iso {
            currentISO = value
        }
        
        self.isoType = iso
        
        var currentISOString: String?
        if let currentISO {
            currentISOString = "\(Int(currentISO))"
        }
        
        let arrayControlValue = ArrayControlValue(array: ["1000", "200"], selected: currentISOString)
        self.type = .arrayWithDefault(ArrayWithDefaultControlValue(defaultValue: "Auto",
                                                                   array: arrayControlValue))
    }
    
}

extension ISOCameraControl {
    
    var controlValue: ArrayWithDefaultControlValue {
        guard case let .arrayWithDefault(value) = type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
    
    static var timescaleArray: [Int] {
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
