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
        // cropping: https://www.advancedswift.com/crop-image/
        let selectedAspectRatio = settingsStorage.formControl.aspectRatio
        
        let width = image.size.width
        let height = image.size.height
        
        var targetWidth: CGFloat
        var targetHeight: CGFloat
        
        switch selectedAspectRatio {
        case .sixteenByNine:
            targetWidth = width
            targetHeight = width * 9 / 16
        case .fourByThree:
            targetWidth = width
            targetHeight = width * 3 / 4
        case .oneByOne:
            let minLength = min(width, height)
            targetWidth = minLength
            targetHeight = minLength
        }
        
        let scaleFactor = image.scale
        let croppedRect = CGRect(x: 0, y: (height - targetHeight) / 2, width: targetWidth, height: targetHeight)
        if let croppedCGImage = image.cgImage?.cropping(to: croppedRect) {
            let croppedImage = UIImage(cgImage: croppedCGImage, scale: scaleFactor, orientation: image.imageOrientation)
            
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
        func addCompletion(completion:WriteImageToFileResponderCompletion) {
            self.completion = completion
        }
    }
    
}
