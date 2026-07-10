//
//  UIFont+Extensions.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 10.07.2026.
//

import UIKit

extension UIFont {
    
    enum TouchSansWeight: String, CaseIterable {
        case black = "Black"
        case bold = "Bold"
        case extraLight = "ExtraLight"
        case light = "Light"
        case regular = "Regular"
        case semiBold = "SemiBold"
        case thin = "Thin"
    }
    
    static func touchSans(weight: TouchSansWeight, size: CGFloat) -> UIFont {
        return UIFont(name: "TouchSansOne-\(weight.rawValue)", size: size)!
    }
    
}
