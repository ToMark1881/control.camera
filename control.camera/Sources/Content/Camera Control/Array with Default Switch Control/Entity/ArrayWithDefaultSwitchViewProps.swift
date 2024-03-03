//
//  ArrayWithDefaultSwitchViewProps.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

struct ArrayWithDefaultSwitchViewProps {
    let title: String
    let array: [String]
    let selectedIndex: Range<Int>.Index?
    let elementHeight: CGFloat?
    
    let isDefaultValuePresented: Bool
    let defaultValue: String
}
