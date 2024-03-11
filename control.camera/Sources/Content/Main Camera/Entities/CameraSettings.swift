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
    
    // MARK: - White balance
    let maxWhiteBalanceGain: Float
    let isLockedWhiteBalanceSupported: Bool
    
    // MARK: - Flash
    let isFlashAvailable: Bool
    
    func logSettings() { dump(self) }
}
