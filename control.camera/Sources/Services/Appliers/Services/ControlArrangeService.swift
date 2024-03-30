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
    
    func update(control: ControlType, at index: Int)
}

class ControlArrangeServiceImplementation: ControlArrangeService {
    
    static let `default` = ControlArrangeServiceImplementation()
    
    var isArrangeModeActivated: Bool = false
    
    var controlArrangement: [ControlType] {
        if isArrangeModeActivated {
            return temporaryControlArrangement
        } else {
            return savedInStorageControlArrangement ?? defaultControlArrangement
        }
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
    
    private lazy var temporaryControlArrangement: [ControlType] = { return savedInStorageControlArrangement ?? defaultControlArrangement }()
    
    func update(control: ControlType, at index: Int) {
        // just clear control at index
        if control == .empty {
            temporaryControlArrangement[index] = .empty
            return
        }
        
        // clear control if presented at index
        if let firstIndex = temporaryControlArrangement.firstIndex(where: { $0 == control }) {
            temporaryControlArrangement[firstIndex] = .empty
        }
        
        temporaryControlArrangement[index] = control
    }
    
}
