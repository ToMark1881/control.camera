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
    func changeDevice(_ device: AvailableVideoDevice.DeviceType)
    
    func capturePhoto()
}

class CameraConfigurationImplementation: NSObject, CameraConfiguration {
    
    weak var view: CameraViewConfiguration!
    weak var output: CameraConfigurationOutput!
    
    var settingsStorage: CameraSettingsStorage!
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
        let minISO = currentDevice.activeFormat.minISO
        let maxISO = currentDevice.activeFormat.maxISO
        
        let minExposure = currentDevice.activeFormat.minExposureDuration
        let maxExposure = currentDevice.activeFormat.maxExposureDuration
        
        let isFlashAvailable = currentDevice.isFlashAvailable
        
        let settings: CameraSettings = .init(minISO: minISO,
                                             maxISO: maxISO,
                                             minExposure: minExposure,
                                             maxExposure: maxExposure,
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
        // Preset the session for taking photo in full resolution
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
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
    }
    
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
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
        
        guard let device = tempDevice,
              let captureDeviceInput = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        
        captureSession.inputs.forEach({ captureSession.removeInput($0) })
        captureSession.addInput(captureDeviceInput)
        currentDevice = device
    }
    
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = settingsStorage.flashControl.flashMode
        
        stillImageOutput.isHighResolutionCaptureEnabled = true
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
}

extension CameraConfigurationImplementation: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard error == nil else {
            return
        }
         
        stepByStepApplier.processPhoto(for: output, didFinishProcessingPhoto: photo)
    }
}
