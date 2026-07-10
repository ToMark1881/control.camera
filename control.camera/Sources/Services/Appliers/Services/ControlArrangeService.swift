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
    
    private enum Constants {
        static let userDefaultsArrangementKey = "userDefaultsArrangementKey"
        /// The sixth row of the screen is occupied by the fixed dock,
        /// so the arrangeable grid is 3 columns by 5 rows
        static let controlsPerPage = 3 * 5
        static let pagesCount = 3
        static let totalControlsCount = controlsPerPage * pagesCount
    }
    
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
        var controlArrangements = [ControlType](repeating: .empty, count: Constants.totalControlsCount)

        guard let url = Bundle.main.url(forResource: "DefaultControlArrangement", withExtension: "json") else {
            fatalError("Couldn't load DefaultControlArrangement")
        }

        do {
            let data = try Data(contentsOf: url)
            let arrangements = try decoder.decode([ControlArrangement].self, from: data)

            for arrangement in arrangements where isValid(arrangement) {
                let index = (arrangement.page * Constants.controlsPerPage) + arrangement.index
                controlArrangements[index] = arrangement.type
            }
        } catch let error {
            print(error)
        }

        return controlArrangements
    }()

    private var savedInStorageControlArrangement: [ControlType]? {
        guard let data = UserDefaults.standard.data(forKey: Constants.userDefaultsArrangementKey) else {
            return nil
        }

        var controlArrangements = [ControlType](repeating: .empty, count: Constants.totalControlsCount)
        let decoder = JSONDecoder()

        do {
            let arrangements = try decoder.decode([ControlArrangement].self, from: data)

            for arrangement in arrangements where isValid(arrangement) {
                let index = (arrangement.page * Constants.controlsPerPage) + arrangement.index
                controlArrangements[index] = arrangement.type
            }
        } catch let error {
            print(error)
        }

        return controlArrangements
    }

    /// Dock controls live in their own fixed row, and arrangements saved
    /// before the dock was introduced may still reference them or the
    /// removed sixth row, so such entries are dropped on load
    private func isValid(_ arrangement: ControlArrangement) -> Bool {
        return !arrangement.type.isDockControl
            && arrangement.index < Constants.controlsPerPage
            && arrangement.page < Constants.pagesCount
    }
    
    private lazy var temporaryControlArrangement: [ControlType] = { return savedInStorageControlArrangement ?? defaultControlArrangement }()
    
    func update(control: ControlType, at index: Int) {
        // Dock controls can not be placed into the grid
        guard !control.isDockControl else {
            return
        }

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
        saveToStorage()
    }
    
    private func saveToStorage() {
        let perPage = Constants.controlsPerPage
        var controlArrangements: [ControlArrangement] = []
        
        for index in temporaryControlArrangement.indices {
            var controlIndex: Int
            var page: Int = 0
            
            if index < perPage {
                controlIndex = index
            } else {
                controlIndex = (index % perPage)
                page = Int(index / perPage)
            }
            
            let arrangement = ControlArrangement(page: page, index: controlIndex, type: temporaryControlArrangement[index])
            controlArrangements.append(arrangement)
        }
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(controlArrangements)
            UserDefaults.standard.set(data, forKey: Constants.userDefaultsArrangementKey)
        } catch let error {
            print(error)
        }
    }
    
}
