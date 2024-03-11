//
//  WhiteBalanceCalculatingService.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 11.03.2024.
//

import AVFoundation

protocol WhiteBalanceCalculatingService {
    func normalize(gains: AVCaptureDevice.WhiteBalanceGains, for device: AVCaptureDevice) -> AVCaptureDevice.WhiteBalanceGains
}

class WhiteBalanceCalculatingServiceImplementation: WhiteBalanceCalculatingService {
    
    func normalize(gains: AVCaptureDevice.WhiteBalanceGains, for device: AVCaptureDevice) -> AVCaptureDevice.WhiteBalanceGains {
        let red = min(max(1.0, gains.redGain), device.maxWhiteBalanceGain)
        let green = min(max(1.0, gains.greenGain), device.maxWhiteBalanceGain)
        let blue = min(max(1.0, gains.blueGain), device.maxWhiteBalanceGain)
        
        return .init(redGain: red, greenGain: green, blueGain: blue)
    }
    
}

private extension WhiteBalanceCalculatingServiceImplementation {
    
    
}
