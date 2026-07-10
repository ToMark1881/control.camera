//
//  UIView+Constrainable.swift
//  Zakaz
//
//  Created by Vladyslav Vdovychenko on 25.03.2026.
//  Copyright © 2026 Zakaz Investments Limited. All rights reserved.
//

import UIKit

protocol Layoutable {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
}

extension UIView: Layoutable { }
extension UILayoutGuide: Layoutable { }

struct Constrainable {
    /// Original view, makes no sense to use during building layout
    let view: UIView
    
    @discardableResult
    func prepareForLayout() -> Self {
        view.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

extension UIView {
    /// Easy (ez) Layout (l)
    var ezl: Constrainable {
        .init(view: self)
    }
}
