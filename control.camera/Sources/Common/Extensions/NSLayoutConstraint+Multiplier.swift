//
//  NSLayoutConstraint+Multiplier.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 22.02.2024.
//

import UIKit

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!,
                                  attribute: self.firstAttribute,
                                  relatedBy: self.relation,
                                  toItem: self.secondItem,
                                  attribute: self.secondAttribute,
                                  multiplier: multiplier,
                                  constant: self.constant)
    }
}
