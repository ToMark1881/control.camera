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
import CoreImage
import ImageIO

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
    private var compressedPhoto: AVCapturePhoto?
    private let ciContext = CIContext()
    
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
        compressedPhoto = photo
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
        guard let compressedData = compressedPhoto?.fileDataRepresentation() else {
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
            
            self.compressedPhoto = nil
            self.rawPhotoTempURL = nil
        })
    }
    
    func saveCroppedPhoto() {
        guard let originalData = compressedPhoto?.fileDataRepresentation() else { return }
        
        do {
            let compressedData = try cropToAspectPreservingMetadata(
                originalData: originalData,
                targetAspect: settingsStorage.formControl.aspectRatio.aspectRatio,
                ciContext: ciContext
            )
            
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
                
                self.compressedPhoto = nil
                self.rawPhotoTempURL = nil
            })
            
        } catch {
            print("Crop failed:", error)
        }
    }
    
    enum PhotoCropError: Error {
        case cannotCreateSource
        case cannotReadMetadata
        case cannotCreateCIImage
        case cannotCreateCGImage
        case cannotCreateDestination
        case cannotFinalize
    }

    func cropToAspectPreservingMetadata(originalData: Data,
                                        targetAspect: CGFloat,   // width/height, e.g. 3/4
                                        ciContext: CIContext) throws -> Data {

        // 1) Read metadata from original encoded image
        guard let source = CGImageSourceCreateWithData(originalData as CFData, nil) else {
            throw PhotoCropError.cannotCreateSource
        }
        guard var props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any] else {
            throw PhotoCropError.cannotReadMetadata
        }

        let exifOrientation = (props[kCGImagePropertyOrientation] as? UInt32) ?? 1
        let outputUTI = CGImageSourceGetType(source)

        // 2) Create CIImage and apply EXIF orientation so “what you see” is what you crop
        guard let ciImage = CIImage(data: originalData) else {
            throw PhotoCropError.cannotCreateCIImage
        }
        let oriented = ciImage.oriented(forExifOrientation: Int32(exifOrientation))

        // 3) Compute a centered crop rect to match target aspect ratio
        let extent = oriented.extent
        let currentAspect = extent.width / extent.height

        var cropRect = extent

        if currentAspect > targetAspect {
            // Image is too wide -> crop width
            let newWidth = extent.height * targetAspect
            let x = extent.midX - newWidth / 2
            cropRect = CGRect(x: x, y: extent.minY, width: newWidth, height: extent.height)
        } else {
            // Image is too tall -> crop height
            let newHeight = extent.width / targetAspect
            let y = extent.midY - newHeight / 2
            cropRect = CGRect(x: extent.minX, y: y, width: extent.width, height: newHeight)
        }

        cropRect = cropRect.integral.intersection(extent)

        let cropped = oriented.cropped(to: cropRect)

        // 4) Render cropped pixels
        guard let cgImage = ciContext.createCGImage(cropped, from: cropped.extent) else {
            throw PhotoCropError.cannotCreateCGImage
        }

        // 5) Update metadata: new dimensions + orientation baked into pixels
        let newW = Int(cropped.extent.width)
        let newH = Int(cropped.extent.height)

        props[kCGImagePropertyPixelWidth] = newW
        props[kCGImagePropertyPixelHeight] = newH
        props[kCGImagePropertyOrientation] = 1

        if var exif = props[kCGImagePropertyExifDictionary] as? [CFString: Any] {
            exif[kCGImagePropertyExifPixelXDimension] = newW
            exif[kCGImagePropertyExifPixelYDimension] = newH
            props[kCGImagePropertyExifDictionary] = exif
        }

        // 6) Re-encode with metadata
        let outData = NSMutableData()
        guard let outputUTI, let dest = CGImageDestinationCreateWithData(outData, outputUTI, 1, nil) else {
            throw PhotoCropError.cannotCreateDestination
        }

        CGImageDestinationAddImage(dest, cgImage, props as CFDictionary)

        guard CGImageDestinationFinalize(dest) else {
            throw PhotoCropError.cannotFinalize
        }

        return outData as Data
    }
    
}
