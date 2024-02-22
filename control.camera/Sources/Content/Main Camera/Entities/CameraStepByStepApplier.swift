//
//  CameraStepByStepApplier.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 19.02.2024.
//

import Foundation
import AVFoundation
import UIKit

protocol CameraStepByStepApplier {
    func processPhoto(for output: AVCapturePhotoOutput,
                      didFinishProcessingPhoto photo: AVCapturePhoto)
}

class CameraStepByStepApplierImplementation: CameraStepByStepApplier {
    
    // MARK: - Injected
    
    var settingsStorage: CameraSettingsStorage!
    var croppingService: CroppingService!
    
    // MARK: - Private
    
    func processPhoto(for output: AVCapturePhotoOutput,
                      didFinishProcessingPhoto photo: AVCapturePhoto) {
        let queue = DispatchQueue(label: "photo-processing", qos: .userInitiated)
        
        var image: UIImage!
        
        queue.sync {
            image = self.getImage(photo)
        }
        
        queue.sync {
            self.applyForm(for: &image)
        }
        
        queue.sync {
            self.save(image)
        }
        
    }
    
}

private extension CameraStepByStepApplierImplementation {
    
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
    
    func save(_ image: UIImage) {
        let responder = WriteImageToFileResponder()
        responder.addCompletion { (image, error) in
            
        }
        
        UIImageWriteToSavedPhotosAlbum(image, responder, #selector(WriteImageToFileResponder.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    class WriteImageToFileResponder: NSObject {
        typealias WriteImageToFileResponderCompletion = ((UIImage?, Error?) -> Void)?
        var completion: WriteImageToFileResponderCompletion = nil
        
        override init() {
            super.init()
        }
        
        @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if (completion != nil) {
                error == nil ? completion?(image, error) : completion?(nil, error)
                completion = nil
            }
        }
        
        func addCompletion(completion: WriteImageToFileResponderCompletion) {
            self.completion = completion
        }
    }
    
}
