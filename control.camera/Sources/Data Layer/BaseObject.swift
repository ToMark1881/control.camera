//
//  BaseObject.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import Foundation

struct BaseObject: Decodable {
    
    private(set) var id: Int
    private(set) var title: String
    
    
    fileprivate enum CodingKeys: String, CodingKey {
        case id
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
    }
    
}
