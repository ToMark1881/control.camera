//
//  RangeWithDefaultSwitchViewProps.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import Foundation

struct RangeWithDefaultSwitchViewProps {
    let title: String
    let array: [String]
    let selectedIndex: Range<Int>.Index?
    
    let isDefaultValuePresented: Bool
    let defaultValue: String
}
