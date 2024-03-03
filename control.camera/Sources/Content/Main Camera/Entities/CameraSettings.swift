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
    
    // MARK: - ISO
    let minISO: Float
    let maxISO: Float
    
    // MARK: - Exposure
    let isAutoExposureSupported: Bool
    let isCustomExposureSupported: Bool
    
    let minExposure: CMTime
    let maxExposure: CMTime
    
    // MARK: - Zoom
    let minZoom: CGFloat
    let maxZoom: CGFloat
    
    // MARK: - Focus
    let isLockedFocusSupported: Bool
    let isAutoFocusSupported: Bool
    
    let minLensPosition: CGFloat
    let maxLensPosition: CGFloat
    
    // MARK: - Flash
    let isFlashAvailable: Bool
    
    func logSettings() { dump(self) }
}

// 1, 2, 3, 4, 5, 6, 8, 10, 11, 13, 15, 20, 23, 25, 30, 40, 45, 50, 60, 80, 90, 100, 125, 160, 180, 200, 250, 320, 350, 400, 500, 640
