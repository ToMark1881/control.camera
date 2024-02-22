//
//  CroppingService.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 22.02.2024.
//

import Foundation

protocol CroppingService {
    func crop(size: CGSize, for aspectRatio: CGFloat) -> CGRect
}

class CroppingServiceImplementation: CroppingService {
    
    func crop(size: CGSize, for aspectRatio: CGFloat) -> CGRect {
        let width = size.width
        let height = size.height
        
        var targetWidth: CGFloat
        var targetHeight: CGFloat
        
        if width / height > aspectRatio {
            // Ширина зображення більше, ніж потрібне співвідношення сторін
            targetWidth = height * aspectRatio
            targetHeight = height
        } else if height / width > aspectRatio {
            // Висота зображення більше, ніж потрібне співвідношення сторін або рівна
            targetWidth = width
            targetHeight = width / aspectRatio
        } else {
            targetWidth = width
            targetHeight = height
        }
        
        let xOffset = (width - targetWidth) / 2
        let yOffset = (height - targetHeight) / 2
        
        let cropRect = CGRect(x: xOffset,
                              y: yOffset,
                              width: targetWidth,
                              height: targetHeight)
        
        return cropRect
    }
    
}
