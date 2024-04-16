//
//  OnboardingService.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 16.04.2024.
//

import Foundation

protocol OnboardingService {
    var isOnboarded: Bool { get }
    
    func mark()
    func reset()
}

class OnboardingServiceImplementation: OnboardingService {
    
    enum Constants {
        static let onboardingKey = "onboardingKey"
    }
    
    var isOnboarded: Bool {
        return UserDefaults.standard.bool(forKey: Constants.onboardingKey)
    }
    
    func mark() {
        UserDefaults.standard.setValue(true, forKey: Constants.onboardingKey)
    }
    
    func reset() {
        UserDefaults.standard.removeObject(forKey: Constants.onboardingKey)
    }
    
}
