//
//  Constants.swift
//  TemplateApplication
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import Foundation
import UIKit

// MARK: - GLOBAL CONSTS
let kAppStoreLink = ""
let kServerDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
let kUserInterfaceDateFormat = "EEEE, d MMMM, yyyy"

struct ScreenSize {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}


struct ApplicationColors {
    
    static func separatorColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.separator
        } else {
            return UIColor(red: 0.655, green: 0.715, blue: 0.745, alpha: 1)
        }
    }
    
    static func textLabelColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor.black
        }
    }
    
    static func secondaryTextLabelColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.secondaryLabel
        } else {
            return UIColor(red: 0.655, green: 0.715, blue: 0.745, alpha: 1)
        }
    }
    
    static func backgroundColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.tertiarySystemBackground
        } else {
            return UIColor.white
        }
    }
    
    static func secondaryBackgroundColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.secondarySystemBackground
        } else {
            return UIColor(red: 0.958, green: 0.974, blue: 0.982, alpha: 1)
        }
    }
    
}
