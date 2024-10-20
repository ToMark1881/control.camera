//
//  CameraStepByStepPostApplier.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 19.02.2024.
//

import Foundation
import AVFoundation
import UIKit
import Photos

protocol CameraStepByStepPostApplier {
    func finishProcessingPhoto(for output: AVCapturePhotoOutput,
                               didFinishProcessingPhoto photo: AVCapturePhoto)
    
    func finishCapture(for output: AVCapturePhotoOutput,
                       didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings)
}

class CameraStepByStepPostApplierImplementation: CameraStepByStepPostApplier {
    
    // MARK: - Injected
    
    var settingsStorage: CameraSettingsStorage!
    var croppingService: CroppingService!
    
    // MARK: - Private
    
    private let queue = DispatchQueue(label: "photo-processing", qos: .userInitiated)
    private var rawPhotoTempURL: URL?
    private var compressedData: Data?
    
    func finishProcessingPhoto(for output: AVCapturePhotoOutput,
                               didFinishProcessingPhoto photo: AVCapturePhoto) {
        print(#function, Date(), photo.isRawPhoto)
        
        if photo.isRawPhoto {
            preSave(rawPhoto: photo)
        } else {
            preSave(photo: photo)
        }
    }
    
    func finishCapture(for output: AVCapturePhotoOutput,
                       didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print(#function, Date())
        switch settingsStorage.formControl.aspectRatio {
        case .threeByFour:
            savePhoto()
        case .oneByOne, .nineBySixteen, .tenBySixteen:
            saveCroppedPhoto()
        }
    }
    
}

private extension CameraStepByStepPostApplierImplementation {
    
    private func makeUniqueDNGFileURL() -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = ProcessInfo.processInfo.globallyUniqueString
        return tempDir.appendingPathComponent(fileName).appendingPathExtension("dng")
    }
    
    func getImage(_ photo: AVCapturePhoto) -> UIImage {
        // Get the image from the photo buffer
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            fatalError("Cannot create image from data")
        }
        
        return image
    }
    
    func applyForm(for image: inout UIImage) {
        let selectedAspectRatio = settingsStorage.formControl.aspectRatio
        let cropRect = croppingService.crop(size: image.size, for: selectedAspectRatio.aspectRatio)
        if let croppedImage = image.cropping(to: cropRect) {
            image = croppedImage
        }
    }
        
    func preSave(photo: AVCapturePhoto) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        compressedData = data
    }
    
    func preSave(rawPhoto: AVCapturePhoto) {
        guard let data = rawPhoto.fileDataRepresentation() else {
            return
        }
        
        do {
            let url = self.makeUniqueDNGFileURL()
            try data.write(to: url)
            
            rawPhotoTempURL = url
        } catch {
            fatalError("Couldn't write DNG file to the URL.")
        }
    }
    
    func savePhoto() {
        guard let compressedData = compressedData else {
            return
        }
                
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            
            if let url = self.rawPhotoTempURL {
                creationRequest.addResource(with: .photo,
                                            data: compressedData,
                                            options: nil)
                
                let options = PHAssetResourceCreationOptions()
                options.shouldMoveFile = true
                creationRequest.addResource(with: .alternatePhoto,
                                            fileURL: url,
                                            options: options)
            } else {
                creationRequest.addResource(with: .photo,
                                            data: compressedData,
                                            options: nil)
            }
        }, completionHandler: { success, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.compressedData = nil
            self.rawPhotoTempURL = nil
        })
    }
    
    func saveCroppedPhoto() {
        guard let fullSizePhotoData = compressedData,
        var imageToCrop = UIImage(data: fullSizePhotoData) else {
            return
        }
        
        applyForm(for: &imageToCrop)
        
        guard let croppedImageData = imageToCrop.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            
            creationRequest.addResource(with: .photo,
                                        data: croppedImageData,
                                        options: nil)
            
            let options = PHAssetResourceCreationOptions()
            options.shouldMoveFile = true
            creationRequest.addResource(with: .adjustmentBasePhoto,
                                        data: fullSizePhotoData,
                                        options: options)
        }, completionHandler: { success, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.compressedData = nil
        })
    }
    
}
