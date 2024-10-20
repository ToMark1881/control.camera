//
//  CameraConfiguration.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit
import AVFoundation

protocol CameraConfiguration: AnyObject {
    var settings: CameraSettings { get }
    var availableDevices: [AvailableVideoDevice] { get }
    
    func configure()
    func startSession()
    func pauseSession()
    
    func changeDevice(_ device: AvailableVideoDevice.DeviceType)
    func setZoomFactor(_ zoomFactor: CGFloat)
    
    func setAutoFocus()
    func setLockedFocus(with lensPosition: CGFloat)
    
    func setAutoExposure()
    func setCustomExposure(_ duration: CMTime)
    
    func setAutoISO()
    func setCustomISO(_ iso: Float)
    
    func setAutoWhiteBalance()
    func setCustomWhiteBalance(_ kelvinTemp: Int)
    
    func updatePhotoFormat()
    
    func capturePhoto()
}

class CameraConfigurationImplementation: NSObject, CameraConfiguration {
    
    weak var view: CameraViewConfiguration!
    weak var output: CameraConfigurationOutput!
    
    var settingsStorage: CameraSettingsStorage!
    var whiteBalanceService: WhiteBalanceCalculatingService!
    var stepByStepApplier: CameraStepByStepPostApplier!
    
    var captureSession: AVCaptureSession!
    var wideCamera: AVCaptureDevice?
    var telephotoCamera: AVCaptureDevice?
    var ultraWideCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    
    var currentDevice: AVCaptureDevice!
    
    var stillImageOutput: AVCapturePhotoOutput!
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var settings: CameraSettings {
        #if targetEnvironment(simulator)
        return CameraSettings.simulatorSettings
        #endif
        
        let minISO = currentDevice.activeFormat.minISO
        let maxISO = currentDevice.activeFormat.maxISO
        
        let minExposure = currentDevice.activeFormat.minExposureDuration
        let maxExposure = currentDevice.activeFormat.maxExposureDuration
        
        let isFlashAvailable = currentDevice.isFlashAvailable
        
        let minZoom = currentDevice.minAvailableVideoZoomFactor
        let maxZoom = currentDevice.maxAvailableVideoZoomFactor
        
        let isLockedFocusSupported = currentDevice.isFocusModeSupported(.locked)
        let isAutoFocusSupported = currentDevice.isFocusModeSupported(.autoFocus)
        
        let minLensPosition: CGFloat = 0.0
        let maxLensPosition: CGFloat = 1.0
        
        let isAutoExposureSupported = currentDevice.isExposureModeSupported(.continuousAutoExposure)
        let isCustomExposureSupported = currentDevice.isExposureModeSupported(.custom)
        
        let isLockedWhiteBalanceSupported = currentDevice.isWhiteBalanceModeSupported(.locked)
        let maxWhiteBalanceGain = currentDevice.maxWhiteBalanceGain
                                
        let settings: CameraSettings = .init(minISO: minISO,
                                             maxISO: maxISO,
                                             isAutoExposureSupported: isAutoExposureSupported,
                                             isCustomExposureSupported: isCustomExposureSupported,
                                             minExposure: minExposure,
                                             maxExposure: maxExposure,
                                             minZoom: minZoom,
                                             maxZoom: maxZoom,
                                             isLockedFocusSupported: isLockedFocusSupported,
                                             isAutoFocusSupported: isAutoFocusSupported,
                                             minLensPosition: minLensPosition,
                                             maxLensPosition: maxLensPosition,
                                             maxWhiteBalanceGain: maxWhiteBalanceGain,
                                             isLockedWhiteBalanceSupported: isLockedWhiteBalanceSupported,
                                             isFlashAvailable: isFlashAvailable)
        
        return settings
    }
    
    var availableDevices: [AvailableVideoDevice] {
        var devices = [AvailableVideoDevice]()
        
        if let wide = wideCamera {
            devices.append(AvailableVideoDevice(type: .wide, captureDevice: wide.deviceType))
        }
        
        if let telephoto = telephotoCamera {
            devices.append(AvailableVideoDevice(type: .telephoto, captureDevice: telephoto.deviceType))
        }
        
        if let ultraWide = ultraWideCamera {
            devices.append(AvailableVideoDevice(type: .ultraWide, captureDevice: ultraWide.deviceType))
        }
        
        if let front = frontFacingCamera {
            devices.append(AvailableVideoDevice(type: .front, captureDevice: front.deviceType))
        }
        
        return devices
    }
    
    func configure() {
        #if !targetEnvironment(simulator)
        // Preset the session for taking photo in full resolution
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        // Get the front and back-facing camera for taking photos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera,
                                                                                    .builtInTelephotoCamera,
                                                                                    .builtInUltraWideCamera,
                                                                                    .builtInDualCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .unspecified)
        
        for device in deviceDiscoverySession.devices {
            if device.position == .front {
                frontFacingCamera = device
                continue
            }
            
            switch device.deviceType {
            case .builtInWideAngleCamera:
                wideCamera = device
            case .builtInTelephotoCamera:
                telephotoCamera = device
            case .builtInUltraWideCamera:
                ultraWideCamera = device
            default:
                break
            }
        }
        
        currentDevice = wideCamera
        
        
        // Configure the session with the output for capturing still images
        stillImageOutput = AVCapturePhotoOutput()
        
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else {
            return
        }
        
        // Configure the session with the input and the output devices
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(stillImageOutput)
        
        // Provide a camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.setupCameraLayer(cameraPreviewLayer!)
        #endif
    }
    
    func startSession() {
        self.view.setCameraLayer(hidden: false)
        #if !targetEnvironment(simulator)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
        #endif
    }
    
    func pauseSession() {
        self.view.setCameraLayer(hidden: true)
        #if !targetEnvironment(simulator)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.stopRunning()
        }
        #endif
    }
    
    func changeDevice(_ device: AvailableVideoDevice.DeviceType) {
        var tempDevice: AVCaptureDevice?
        
        switch device {
        case .wide:
            tempDevice = wideCamera
        case .telephoto:
            tempDevice = telephotoCamera
        case .ultraWide:
            tempDevice = ultraWideCamera
        case .front:
            tempDevice = frontFacingCamera
        }
        
        if tempDevice == currentDevice {
            return
        }
        
        guard let device = tempDevice,
              let captureDeviceInput = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        
        captureSession.inputs.forEach({ captureSession.removeInput($0) })
        captureSession.addInput(captureDeviceInput)
        currentDevice = device
        
        output.didChangeInputDevice()
    }
    
    func setZoomFactor(_ zoomFactor: CGFloat) {
        do {
            try currentDevice.lockForConfiguration()
            currentDevice.videoZoomFactor = zoomFactor
            currentDevice.unlockForConfiguration()
        } catch let error {
            print(error)
        }
    }
    
    func setAutoFocus() {
        do {
            try currentDevice.lockForConfiguration()
            currentDevice.focusMode = .autoFocus
            currentDevice.unlockForConfiguration()
        } catch let error {
            print(error)
        }
    }
    
    func setLockedFocus(with lensPosition: CGFloat) {
        do {
            try currentDevice.lockForConfiguration()
            currentDevice.setFocusModeLocked(lensPosition: Float(lensPosition))
            currentDevice.unlockForConfiguration()
        } catch let error {
            print(error)
        }
    }
    
    func setAutoExposure() {
        guard currentDevice.exposureMode != .continuousAutoExposure else {
            return
        }
        
        do {
            try currentDevice.lockForConfiguration()
            currentDevice.exposureMode = .continuousAutoExposure
            currentDevice.unlockForConfiguration()
            output.didSetAutoExposure()
        } catch let error {
            print(error)
        }
    }
    
    func setCustomExposure(_ duration: CMTime) {
        do {
            try currentDevice.lockForConfiguration()
            let currentISO = AVCaptureDevice.currentISO
            currentDevice.setExposureModeCustom(duration: duration, iso: currentISO)
            currentDevice.unlockForConfiguration()
        } catch let error {
            print(error)
        }
    }
    
    func setAutoISO() {
        guard currentDevice.exposureMode != .continuousAutoExposure else {
            return
        }
        
        do {
            try currentDevice.lockForConfiguration()
            currentDevice.exposureMode = .continuousAutoExposure
            currentDevice.unlockForConfiguration()
            output.didSetAutoISO()
        } catch let error {
            print(error)
        }
    }
    
    func setCustomISO(_ iso: Float) {
        do {
            try currentDevice.lockForConfiguration()
            let currentDuration = AVCaptureDevice.currentExposureDuration
            currentDevice.setExposureModeCustom(duration: currentDuration, iso: iso)
            currentDevice.unlockForConfiguration()
        } catch let error {
            print(error)
        }
    }
    
    func setAutoWhiteBalance() {
        do {
            try currentDevice.lockForConfiguration()
            
            if currentDevice.isWhiteBalanceModeSupported(.autoWhiteBalance) {
                currentDevice.whiteBalanceMode = .autoWhiteBalance
            } else {
                currentDevice.whiteBalanceMode = .continuousAutoWhiteBalance
            }
            
            currentDevice.unlockForConfiguration()
        } catch let error {
            print(error)
        }
    }
    
    func setCustomWhiteBalance(_ kelvinTemp: Int) {
        do {
            try currentDevice.lockForConfiguration()
            
            let currentDeviceGains = currentDevice.deviceWhiteBalanceGains
            let temperatureAndTint = currentDevice.temperatureAndTintValues(for: currentDeviceGains)
            let gains = currentDevice.deviceWhiteBalanceGains(for: .init(temperature: Float(kelvinTemp), tint: temperatureAndTint.tint))
            let normalizedGains = whiteBalanceService.normalize(gains: gains, for: currentDevice)
            
            currentDevice.setWhiteBalanceModeLocked(with: normalizedGains)
            currentDevice.unlockForConfiguration()
        } catch let error {
            print(error)
        }
    }
    
    func updatePhotoFormat() {
        output.didChangePhotoFormat()
    }
    
    func capturePhoto() {
        var photoSettings: AVCapturePhotoSettings!
        
        switch settingsStorage.formatControl.photoFormat {
        case .jpeg:
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        case .heic:
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        case .raw:
            let availableRawFormat = stillImageOutput.availableRawPhotoPixelFormatTypes.first!
            let processedFormat = [AVVideoCodecKey: AVVideoCodecType.hevc]
            photoSettings = AVCapturePhotoSettings(rawPixelFormatType: availableRawFormat,
                                                   processedFormat: processedFormat)
        }
        
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = settingsStorage.flashControl.flashMode
        photoSettings.photoQualityPrioritization = .speed
        
        stillImageOutput.isHighResolutionCaptureEnabled = true
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
}

extension CameraConfigurationImplementation: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        // dispose system shutter sound
        AudioServicesDisposeSystemSoundID(1108)
        
        self.output.willCapture()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        self.output.didCapture()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard error == nil else {
            return
        }
         
        stepByStepApplier.finishProcessingPhoto(for: output, didFinishProcessingPhoto: photo)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings,
                     error: Error?) {
        guard error == nil else {
            return
        }
        
        stepByStepApplier.finishCapture(for: output, didFinishCaptureFor: resolvedSettings)
    }
}
