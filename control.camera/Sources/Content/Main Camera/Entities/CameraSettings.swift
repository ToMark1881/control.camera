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
    
    static var simulatorSettings = CameraSettings(minISO: 40,
                                                  maxISO: 12_000,
                                                  isAutoExposureSupported: true,
                                                  isCustomExposureSupported: true,
                                                  minExposure: CMTime(value: 1, timescale: 10000),
                                                  maxExposure: CMTime(value: 1, timescale: 1),
                                                  minZoom: 1.0,
                                                  maxZoom: 10.0,
                                                  isLockedFocusSupported: true,
                                                  isAutoFocusSupported: true,
                                                  minLensPosition: 0.0,
                                                  maxLensPosition: 1.0,
                                                  maxWhiteBalanceGain: 1_000,
                                                  isLockedWhiteBalanceSupported: true,
                                                  isFlashAvailable: true)
}
