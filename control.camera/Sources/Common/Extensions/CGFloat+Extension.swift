//
//  CGFloat+Extension.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 03.03.2024.
//

import Foundation

extension CGFloat {
    func asFraction() -> String {
        let tolerance: CGFloat = 0.000001 // Adjust the tolerance based on your needs
        var numerator = self
        var denominator = CGFloat(1.0)

        while abs((Double(numerator)) - Double(numerator).rounded()) > tolerance {
            numerator *= 10
            denominator *= 10
        }

        let gcd = CGFloat(greatestCommonDivisor(Int(numerator), Int(denominator)))
        let fractionNumerator = Int(numerator / gcd)
        let fractionDenominator = Int(denominator / gcd)

        return "\(fractionNumerator)/\(fractionDenominator)"
    }

    private func greatestCommonDivisor(_ a: Int, _ b: Int) -> Int {
        return b == 0 ? a : greatestCommonDivisor(b, a % b)
    }
}
