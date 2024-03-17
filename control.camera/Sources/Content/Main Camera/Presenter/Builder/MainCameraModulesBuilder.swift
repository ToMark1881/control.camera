//
//  MainCameraModulesBuilder.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.03.2024.
//

import Foundation

protocol MainCameraModulesBuilder {
    func buildSections(for orderedControls: [ControlType]) -> [CollectionSectionModel]
}

class MainCameraModulesBuilderImplementation: MainCameraModulesBuilder {
    
    var router: MainCameraRouterInputProtocol!
    
    func buildSections(for orderedControls: [ControlType]) -> [CollectionSectionModel] {
        var sections = [CollectionSectionModel]()
        
        for controlType in orderedControls {
            switch controlType {
            case .flash:
                break
            case .form:
                break
            case .device:
                break
            case .zoom:
                break
            case .ui:
                break
            case .library:
                break
            case .focus:
                break
            case .exposure:
                break
            case .iso:
                break
            case .whiteBalance:
                break
            }
        }
        
        return sections
    }
    
}

private extension MainCameraModulesBuilderImplementation {
    
}
