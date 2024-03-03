//
//  ArraySwitchViewProps.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

struct ArraySwitchViewProps {
    let title: String
    let array: [String]
    let selectedIndex: Array<Int>.Index
    let elementHeight: CGFloat?
}
