//
//  ControlArrangement.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.03.2024.
//

import Foundation

struct ControlArrangement: Codable {
    let page: Int
    let index: Int
    let type: ControlType
    
    enum CodingKeys: String, CodingKey {
        case page, index, type = "control_type"
    }
}
