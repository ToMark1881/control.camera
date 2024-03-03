//
//  VideoDeviceCameraControl.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 23.02.2024.
//

import Foundation
import AVFoundation

class VideoDeviceCameraControl: CameraControl {
    
    var title: String {
        return "Device"
    }
    
    var isLightControl: Bool {
        return false
    }
    
    var elementHeight: CGFloat? {
        return 100.0
    }
    
    var type: CameraControlType
    var availableDevices: [AvailableVideoDevice]
    
    var selectedDevice: AvailableVideoDevice? {
        guard let selected = controlValue.selected else {
            return nil
        }
        
        return availableDevices.first(where: { $0.type.title == selected })
    }
    
    init(for availableDevices: [AvailableVideoDevice]) {
        let array = ArrayControlValue(array: availableDevices.map({ $0.type.title }),
                                      selected: availableDevices.first?.type.title)
        
        self.availableDevices = availableDevices
        self.type = .array(array)
    }
    
    var controlValue: ArrayControlValue {
        guard case let .array(value) = type else {
            fatalError("Wrong CameraControlType")
        }
        
        return value
    }
    
}

struct AvailableVideoDevice {
    
    enum DeviceType {
        case wide
        case telephoto
        case ultraWide
        case front
        
        var title: String {
            switch self {
            case .wide:
                return "Wide"
            case .telephoto:
                return "Tele"
            case .ultraWide:
                return "Ultra Wide"
            case .front:
                return "Front"
            }
        }
    }
    
    var type: DeviceType
    var captureDevice: AVCaptureDevice.DeviceType
    
}
