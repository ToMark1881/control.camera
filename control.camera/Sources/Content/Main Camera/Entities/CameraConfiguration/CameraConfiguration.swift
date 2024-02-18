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
    
    func configure()
    func startSession()
    
    func capturePhoto()
}

class CameraConfigurationImplementation: NSObject, CameraConfiguration {
    
    weak var view: CameraViewConfiguration!
    weak var output: CameraConfigurationOutput!
    
    var settingsStorage: CameraSettingsStorage!
    var stepByStepApplier: CameraStepByStepApplier!
    
    var captureSession: AVCaptureSession!
    
    var backFacingCamera: AVCaptureDevice?
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
    
    func configure() {
        // Preset the session for taking photo in full resolution
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        // Get the front and back-facing camera for taking photos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .unspecified)
        
        for device in deviceDiscoverySession.devices {
            if device.position == .back {
                backFacingCamera = device
            } else if device.position == .front {
                frontFacingCamera = device
            }
        }
        
        currentDevice = backFacingCamera
        
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else {
            return
        }
        
        // Configure the session with the output for capturing still images
        stillImageOutput = AVCapturePhotoOutput()
        
        // Configure the session with the input and the output devices
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(stillImageOutput)
        
        // Provide a camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        view.setupCameraLayer(cameraPreviewLayer!)
    }
    
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
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
