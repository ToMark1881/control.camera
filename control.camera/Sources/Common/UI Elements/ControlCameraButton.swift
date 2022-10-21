//
//  ControlCameraButton.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

enum ControlCameraButtonStyle {
    
    case accentYellow
    case disabled
    
    var viewModel: ButtonStyleViewModel {
        
        switch self {
        case .accentYellow:
            return ButtonStyleViewModel(backgroundColor: ApplicationColors.yellowColor(),
                                        titleColor: UIColor.black,
                                        tintColor: UIColor.black,
                                        pressedColorAccent: ApplicationColors.darkenedYellowColor(),
                                        borderColor: nil,
                                        borderWidth: nil)
        case .disabled:
            return ButtonStyleViewModel(backgroundColor: UIColor.systemGray,
                                        titleColor: UIColor.black,
                                        tintColor: UIColor.black,
                                        pressedColorAccent: ApplicationColors.darkenedYellowColor(),
                                        borderColor: nil,
                                        borderWidth: nil,
                                        isEnabled: false)
        }
        
    }
    
}

struct ButtonStyleViewModel {
    
    enum Constants {
        static let defaultCornerRadius: CGFloat = 10.0
    }
    
    var backgroundColor: UIColor = .clear
    let titleColor: UIColor
    let tintColor: UIColor
    let pressedColorAccent: UIColor
    let borderColor: UIColor?
    let borderWidth: CGFloat?
    var isEnabled: Bool = true
    var cornerRadius: CGFloat = Constants.defaultCornerRadius
}

class ControlCameraButton: UIButton {
    
    var style: ControlCameraButtonStyle?
    
    func setup(with style: ControlCameraButtonStyle) {
        self.style = style
        let viewModel = style.viewModel
        cornerRadius = viewModel.cornerRadius
        setTitleColor(viewModel.titleColor, for: .normal)
        borderWidth = viewModel.borderWidth ?? 0.0
        borderColor = viewModel.borderColor
        backgroundColor = viewModel.backgroundColor
        isUserInteractionEnabled = viewModel.isEnabled
        adjustsImageWhenHighlighted = false
        setNeedsDisplay()
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? style?.viewModel.pressedColorAccent : style?.viewModel.backgroundColor
        }
    }
    
}
