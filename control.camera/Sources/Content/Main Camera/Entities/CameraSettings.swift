//
//  CameraSettings.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 23.10.2022.
//

import Foundation
import AVFoundation

/// Device availabilities. Values shouldn't be changed to variables.
struct CameraSettings {
    let minISO: Float
    let maxISO: Float
    
    let minExposure: CMTime
    let maxExposure: CMTime
    
    let isFlashAvailable: Bool
    
    func logSettings() { dump(self) }
}
