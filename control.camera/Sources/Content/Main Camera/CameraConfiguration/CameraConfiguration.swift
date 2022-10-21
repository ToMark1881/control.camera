//
//  CameraConfiguration.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit
import AVFoundation

protocol CameraConfiguration: AnyObject {
    func configure()
    func startSession()
    
    func capturePhoto()
}

class CameraConfigurationImplementation: NSObject, CameraConfiguration {
    
    weak var view: CameraViewConfiguration!
    weak var output: CameraConfigurationOutput!
    
    var captureSession: AVCaptureSession!
    
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice!
    
    var stillImageOutput: AVCapturePhotoOutput!
    var stillImage: UIImage?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
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
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
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
        photoSettings.flashMode = .auto
        
        stillImageOutput.isHighResolutionCaptureEnabled = true
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
}

extension CameraConfigurationImplementation: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            return
        }
         
        // Get the image from the photo buffer
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
         
        stillImage = UIImage(data: imageData)
        
        guard let image = stillImage else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
