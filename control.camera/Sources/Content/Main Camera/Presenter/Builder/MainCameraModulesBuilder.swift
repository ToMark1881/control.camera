//
//  MainCameraModulesBuilder.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.03.2024.
//

import Foundation

protocol MainCameraModulesBuilder {
    func buildSections() -> [CollectionSectionModel]
}

class MainCameraModulesBuilderImplementation: MainCameraModulesBuilder {
    
    var router: MainCameraRouterInputProtocol!
    
    func buildSections() -> [CollectionSectionModel] {
        var sections = [CollectionSectionModel]()
        
        return sections
    }
    
}
