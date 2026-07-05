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
    var frameApplyingService: FrameApplyingService!
    
    // MARK: - Private
    
    private let queue = DispatchQueue(label: "photo-processing", qos: .userInitiated)
    private var rawPhotoTempURL: URL?
    private var compressedPhoto: AVCapturePhoto?
    private let ciContext = CIContext()
    
    func finishProcessingPhoto(for output: AVCapturePhotoOutput,
                               didFinishProcessingPhoto photo: AVCapturePhoto) {
        if photo.isRawPhoto {
            preSave(rawPhoto: photo)
        } else {
            preSave(photo: photo)
        }
    }
    
    func finishCapture(for output: AVCapturePhotoOutput,
                       didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        // The frame is rendered into the compressed photo only, so a RAW
        // capture is always saved untouched through the plain path
        let needsFrame = (settingsStorage.frameControl?.isActive ?? false) && rawPhotoTempURL == nil

        switch settingsStorage.formControl.aspectRatio {
        case .threeByFour:
            needsFrame ? saveCroppedPhoto() : savePhoto()
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
        
        var createdAssetId: String?
        
        PHPhotoLibrary.shared().performChanges({
            let req = PHAssetCreationRequest.forAsset()
            req.addResource(with: .photo, data: originalData, options: nil)  // ✅ original
            createdAssetId = req.placeholderForCreatedAsset?.localIdentifier
        }, completionHandler: { success, error in
            guard success, error == nil, let id = createdAssetId else { return }
            
            // Apply crop as an edit so user can "Revert to Original"
            self.applyCropEdit(assetLocalId: id,
                               aspect: self.settingsStorage.formControl.aspectRatio,
                               ciContext: self.ciContext)
        })
    }
    
    func applyCropEdit(assetLocalId: String,
                       aspect: FormCameraControl.PhotoAspectRatio,
                       ciContext: CIContext) {
        
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetLocalId], options: nil).firstObject
        guard let asset else { return }
        
        let inputOptions = PHContentEditingInputRequestOptions()
        inputOptions.canHandleAdjustmentData = { adj in
            adj.formatIdentifier == "tomark.controlcamera.crop" && adj.formatVersion == "1"
        }
        
        asset.requestContentEditingInput(with: inputOptions) { input, _ in
            guard let input, let originalURL = input.fullSizeImageURL else { return }

            do {
                let originalData = try Data(contentsOf: originalURL)

                // 3:4 matches the sensor output, so no crop is needed —
                // the edit then consists of the frame only
                let targetAspect: CGFloat? = aspect == .threeByFour ? nil : aspect.aspectRatio

                let renderedData = try self.cropToAspectPreservingMetadata(
                    originalData: originalData,
                    targetAspect: targetAspect,
                    ciContext: ciContext
                )

                let output = PHContentEditingOutput(contentEditingInput: input)

                // Write the edited (cropped) image
                try renderedData.write(to: output.renderedContentURL, options: .atomic)

                // Save adjustment data so Photos (and your app) knows an edit exists
                let frameControl = self.settingsStorage.frameControl
                let payload = try JSONEncoder().encode(CropAdjustment(aspectRawValue: aspect.rawValue,
                                                                      frameWidth: frameControl?.isActive == true ? frameControl?.selectedWidth : nil))
                output.adjustmentData = PHAdjustmentData(
                    formatIdentifier: "tomark.controlcamera.crop",
                    formatVersion: "1",
                    data: payload
                )
                
                PHPhotoLibrary.shared().performChanges({
                    let change = PHAssetChangeRequest(for: asset)
                    change.contentEditingOutput = output
                }, completionHandler: nil)
                
            } catch {
                print("applyCropEdit error:", error)
            }
        }
    }
    
    func cropToAspectPreservingMetadata(originalData: Data,
                                        targetAspect: CGFloat?,
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

        if let targetAspect = targetAspect {
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
        }

        let cropped = oriented.cropped(to: cropRect)

        // 3.1) Add the frame border around the cropped image if the control is active
        var processed = cropped
        if let frameControl = settingsStorage.frameControl, frameControl.isActive {
            processed = frameApplyingService.applyFrame(to: processed,
                                                        relativeWidth: frameControl.selectedWidth,
                                                        color: frameControl.borderColor)
        }

        // 4) Render processed pixels
        guard let cgImage = ciContext.createCGImage(processed, from: processed.extent) else {
            throw PhotoCropError.cannotCreateCGImage
        }

        // 5) Update metadata: new dimensions + orientation baked into pixels
        let newW = Int(processed.extent.width)
        let newH = Int(processed.extent.height)
        
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
    
    private struct CropAdjustment: Codable {
        let aspectRawValue: String
        let frameWidth: CGFloat?
    }
    
    enum PhotoCropError: Error {
        case cannotCreateSource
        case cannotReadMetadata
        case cannotCreateCIImage
        case cannotCreateCGImage
        case cannotCreateDestination
        case cannotFinalize
    }
    
}
