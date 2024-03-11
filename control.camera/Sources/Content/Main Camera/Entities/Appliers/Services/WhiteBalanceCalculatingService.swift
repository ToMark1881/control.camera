//
//  WhiteBalanceCalculatingService.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 11.03.2024.
//

import Foundation

protocol WhiteBalanceCalculatingService {
    func calculateGains(for kelvinTemp: Int) -> (redGain: Float, greenGain: Float, blueGain: Float)
}

class WhiteBalanceCalculatingServiceImplementation: WhiteBalanceCalculatingService {
    
    func calculateGains(for kelvinTemp: Int) -> (redGain: Float, greenGain: Float, blueGain: Float) {
        let red = Float(calculateRed(kelvin: kelvinTemp))
        let green = Float(calculateGreen(kelvin: kelvinTemp))
        let blue = Float(calculateBlue(kelvin: kelvinTemp))
        
        return (red, green, blue)
    }
    
}

private extension WhiteBalanceCalculatingServiceImplementation {
    
    func calculateRed(kelvin: Int) -> Double {
        var temperature = Double(kelvin) / 100.0
        var red = 0.0

        // Calculate red value
        if temperature <= 66 {
            red = 255.0
        } else {
            // Adjust temperature
            temperature -= 60
            red = 329.698727446 * pow(temperature, -0.1332047592)
            // Clamp red value
            red = min(255.0, max(0.0, red))
        }

        return red
    }

    func calculateGreen(kelvin: Int) -> Double {
        var temperature = Double(kelvin) / 100.0
        var green = 0.0

        // Calculate green value
        if temperature <= 66 {
            // Adjust temperature
            temperature = temperature - 2
            green = 99.4708025861 * log(temperature) - 161.1195681661
        } else {
            // Adjust temperature
            temperature -= 60
            green = 288.1221695283 * pow(temperature, -0.0755148492)
        }
        
        // Clamp green value
        green = min(255.0, max(0.0, green))
        return green
    }

    func calculateBlue(kelvin: Int) -> Double {
        var temperature = Double(kelvin) / 100.0
        var blue = 0.0

        // Calculate blue value
        if (temperature >= 66) {
            blue = 255.0
        } else if (temperature <= 19) {
            blue = 0.0
        } else {
            // Adjust temperature
            temperature -= 10
            blue = 138.5177312231 * log(temperature) - 305.0447927307
            // Clamp blue value
            blue = min(255.0, max(0.0, blue))
        }

        return blue
    }
    
}
