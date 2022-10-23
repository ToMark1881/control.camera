//
//  CameraSettings.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 23.10.2022.
//

import Foundation
import AVFoundation

struct CameraSettings {
    let minISO: Float
    let maxISO: Float
    
    let minExposure: CMTime
    let maxExposure: CMTime
    
    func logSettings() { dump(self) }
}
