//
//  ControlArrangeService.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.03.2024.
//

import Foundation

protocol ControlArrangeService {
    
    var isArrangeModeActivated: Bool { get set }
    
    var controlArrangement: [ControlType] { get }
}

class ControlArrangeServiceImplementation: ControlArrangeService {
    
    var isArrangeModeActivated: Bool = false
    
    var controlArrangement: [ControlType] {
        savedInStorageControlArrangement ?? defaultControlArrangement
    }
    
    private lazy var defaultControlArrangement: [ControlType] = {
        let decoder = JSONDecoder()
        var controlArrangements = [ControlType](repeating: .empty, count: (3 * 6 * 3))
        
        guard let url = Bundle.main.url(forResource: "DefaultControlArrangement", withExtension: "json") else {
            fatalError("Couldn't load DefaultControlArrangement")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let arrangements = try decoder.decode([ControlArrangement].self, from: data)
            
            for arrangement in arrangements {
                let index = (arrangement.page * 3 * 6) + arrangement.index
                controlArrangements[index] = arrangement.type
            }
        } catch let error {
            print(error)
        }
        
        return controlArrangements
    }()
    
    private var savedInStorageControlArrangement: [ControlType]? {
        return nil
    }
    
}
