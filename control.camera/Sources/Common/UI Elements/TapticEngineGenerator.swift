//
//  TapticEngineGenerator.swift
//  TemplateApplication
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import Foundation
import UIKit

enum TapticEngineFeedbackStyle {
    
    case light
    
    case medium
    
    case heavy
}

enum TapticEngineFeedbackType {
    
    case success

    case warning

    case error
    
}

class TapticEngineGenerator {
            
    class func generateFeedback(_ style: TapticEngineFeedbackStyle) {
        if #available(iOS 10.0, *) {
            var feedbackType = UIImpactFeedbackGenerator.FeedbackStyle.light
            
            switch style {
            case .light: feedbackType = .light
            case .medium: feedbackType = .medium
            case .heavy: feedbackType = .heavy
            }
            DispatchQueue.main.async {
                UIImpactFeedbackGenerator(style: feedbackType).impactOccurred()
            }
        }
    }
    
    class func generateNotification(_ type: TapticEngineFeedbackType) {
        if #available(iOS 10.0, *) {
            var notificationType = UINotificationFeedbackGenerator.FeedbackType.success
            
            switch type {
            case .error: notificationType = .error
            case .success: notificationType = .success
            case .warning: notificationType = .warning
            }
            DispatchQueue.main.async {
                UINotificationFeedbackGenerator().notificationOccurred(notificationType)
            }
        }
    }
    
}
