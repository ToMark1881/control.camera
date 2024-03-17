//
//  MainCameraModulesBuilder.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 17.03.2024.
//

import UIKit

protocol MainCameraModulesBuilder {
    func buildSections(for orderedControls: [ControlType]) -> [CollectionSectionModel]
}

class MainCameraModulesBuilderImplementation: MainCameraModulesBuilder {
    
    weak var parent: (MainCameraParentDisplayable & SwitchControlModuleOutput)!
    var router: MainCameraRouterInputProtocol!
    
    func buildSections(for orderedControls: [ControlType]) -> [CollectionSectionModel] {
        var sections = [CollectionSectionModel]()
        var viewModels = [CollectionCellViewModel]()
        
        for controlType in orderedControls {
            var viewModel: CollectionCellViewModel
            
            switch controlType {
            case .flash:
                viewModel = buildFlashSection()
            case .form:
                viewModel = buildFormSection()
            case .device:
                viewModel = buildDeviceSection()
            case .zoom:
                viewModel = buildZoomSection()
            case .ui:
                viewModel = buildUISection()
            case .library:
                viewModel = buildLibrarySection()
            case .focus:
                viewModel = buildFocusSection()
            case .exposure:
                viewModel = buildExposureSection()
            case .iso:
                viewModel = buildISOSection()
            case .whiteBalance:
                viewModel = buildWhiteBalanceSection()
            }
            
            viewModels.append(viewModel)
        }
        
        let section = CollectionSectionModel(with: viewModels)
        sections.append(section)
        
        return sections
    }
    
}

private extension MainCameraModulesBuilderImplementation {
    
    func buildFlashSection() -> CollectionCellViewModel {
        router.setupLightControl(for: UIView(),
                                 moduleInput: &parent.lightModuleInput,
                                 moduleOutput: parent)
        return BaseCollectionCellViewModel()
    }
    
    func buildFormSection() -> CollectionCellViewModel {
        router.setupFormControl(for: UIView(),
                                moduleInput: &parent.formModuleInput,
                                moduleOutput: parent)
        return BaseCollectionCellViewModel()
    }
    
    func buildDeviceSection() -> CollectionCellViewModel {
        router.setupDeviceControl(for: UIView(),
                                  moduleInput: &parent.deviceModuleInput,
                                  moduleOutput: parent)
        return BaseCollectionCellViewModel()
    }
    
    func buildZoomSection() -> CollectionCellViewModel {
        router.setupZoomControl(for: UIView(),
                                moduleInput: &parent.zoomModuleInput,
                                moduleOutput: parent)
        return BaseCollectionCellViewModel()
    }
    
    func buildUISection() -> CollectionCellViewModel {
        router.setupUIControl(for: UIView(),
                              moduleInput: &parent.uiModuleInput,
                              moduleOutput: parent)
        return BaseCollectionCellViewModel()
    }
    
    func buildLibrarySection() -> CollectionCellViewModel {
        router.setupLibraryControl(for: UIView(),
                                   moduleInput: &parent.libraryModuleInput,
                                   moduleOutput: parent)
        return BaseCollectionCellViewModel()
    }
    
    func buildFocusSection() -> CollectionCellViewModel {
        router.setupFocusControl(for: UIView(),
                                 moduleInput: &parent.focusModuleInput,
                                 moduleOutput: parent)
        return BaseCollectionCellViewModel()
    }
    
    func buildExposureSection() -> CollectionCellViewModel {
        router.setupExposureControl(for: UIView(),
                                    moduleInput: &parent.exposureModuleInput,
                                    moduleOutput: parent)
        return BaseCollectionCellViewModel()
    }
    
    func buildISOSection() -> CollectionCellViewModel {
        router.setupISOControl(for: UIView(),
                               moduleInput: &parent.isoModuleInput,
                               moduleOutput: parent)
        return BaseCollectionCellViewModel()
    }
    
    func buildWhiteBalanceSection() -> CollectionCellViewModel {
        router.setupWhiteBalanceControl(for: UIView(),
                                        moduleInput: &parent.whiteBalanceModuleInput,
                                        moduleOutput: parent)
        return BaseCollectionCellViewModel()
    }
    
}
