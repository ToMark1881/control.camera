//
//  Double+Extension.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 28.02.2024.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
