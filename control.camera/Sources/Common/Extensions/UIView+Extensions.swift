//
//  UIView+Extensions.swift
//  TemplateApplication
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func bindOnAllSidesLayouts(parentView: UIView?, offcet: CGFloat = 0) {
        parentView?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0 - offcet).isActive = true
        parentView?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0 + offcet).isActive = true
        parentView?.topAnchor.constraint(equalTo: self.topAnchor, constant: 0 - offcet).isActive = true
        parentView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0 + offcet).isActive = true
    }
}

// MARK: - Layout

extension UIView {
    func pinViewToEdgesOfSuperview(leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        guard let superView = superview else {
            return
        }
        
        superView.addConstraints([
            leftAnchor.constraint(equalTo: superView.leftAnchor, constant: leftOffset),
            superView.rightAnchor.constraint(equalTo: rightAnchor, constant: rightOffset),
            topAnchor.constraint(equalTo: superView.topAnchor, constant: topOffset),
            superView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomOffset)
        ])
    }
    
    func pinViewToCenterOfSuperview(offsetX: CGFloat = 0.0, offsetY: CGFloat = 0.0) {
        translatesAutoresizingMaskIntoConstraints = false
        superview!.addConstraints([
            centerXAnchor.constraint(equalTo: superview!.centerXAnchor, constant: offsetX),
            centerYAnchor.constraint(equalTo: superview!.centerYAnchor, constant: offsetY)
        ])
    }
    
    func pinViewWidthAndHeight(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        superview!.addConstraints([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func pinViewWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraints([widthAnchor.constraint(equalToConstant: width)])
    }
    
    func pinViewHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraints([heightAnchor.constraint(equalToConstant: height)])
    }
    
    @discardableResult
    func pinViewToBottomOfSuperview(height: CGFloat) -> (bottomConstarint: NSLayoutConstraint, heightConstarint: NSLayoutConstraint) {
        translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = superview!.bottomAnchor.constraint(equalTo: bottomAnchor)
        let heightConstarint = heightAnchor.constraint(equalToConstant: height)
        superview!.addConstraints([
            heightConstarint,
            superview!.leftAnchor.constraint(equalTo: leftAnchor),
            superview!.rightAnchor.constraint(equalTo: rightAnchor),
            bottomConstraint
        ])
        return (bottomConstraint, heightConstarint)
    }
    
    func pinViewToTopOfSuperview(height: CGFloat, topOffset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        superview!.addConstraints([
            heightAnchor.constraint(equalToConstant: height),
            topAnchor.constraint(equalTo: superview!.topAnchor, constant: topOffset),
            leftAnchor.constraint(equalTo: superview!.leftAnchor),
            rightAnchor.constraint(equalTo: superview!.rightAnchor)
        ])
    }
    
    func pinViewToBottom() {
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: superview!.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview!.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview!.bottomAnchor).isActive = true
    }
    
    func setViewToEdgesOfSuperview(leftOffset: CGFloat = 0, rightOffset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        superview!.addConstraints([
            superview!.leftAnchor.constraint(equalTo: leftAnchor, constant: leftOffset),
            superview!.rightAnchor.constraint(equalTo: rightAnchor, constant: rightOffset)
        ])
    }
    
    func fittingCompressedHeightView() -> UIView {
        setNeedsLayout()
        layoutIfNeeded()
        
        let height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = frame
        frame.size.height = height
        self.frame = frame
        
        return self
    }
}

// MARK: - Nib

extension UIView {
    static var nib: UINib {
        let bundle = Bundle(for: self as AnyClass)
        let nib = UINib(nibName: String(describing: self), bundle: bundle)
        return nib
    }
    
    static func loadFromNib() -> Self {
        return _loadFromNib()
    }
    
    // MARK: - Private
    
    fileprivate static func _loadFromNib<T: UIView>() -> T {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? T else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as? T ?? T()
    }
}

extension UIView {
    static func loadFromXib<T>(withOwner: Any? = nil, options: [UINib.OptionsKey: Any]? = nil) -> T where T: UIView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: withOwner, options: options).first as? T else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }
}

extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.5,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(_: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = {(_: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    /* The color of the shadow. Defaults to opaque black. Colors created
     * from patterns are currently NOT supported. Animatable. */
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
        set {
            layer.shadowColor = newValue!.cgColor
        }
    }
    
    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable var shadowOffset: CGPoint {
        get {
            return CGPoint(x: layer.shadowOffset.width, y: layer.shadowOffset.height)
        }
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
    }
    
    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
}

extension UIView {
    
    func rotate(toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
