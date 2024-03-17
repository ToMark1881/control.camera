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
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupLightControl(for: embeddingView,
                                 moduleInput: &parent.lightModuleInput,
                                 moduleOutput: parent)
        return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildFormSection() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupFormControl(for: embeddingView,
                                moduleInput: &parent.formModuleInput,
                                moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildDeviceSection() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupDeviceControl(for: embeddingView,
                                  moduleInput: &parent.deviceModuleInput,
                                  moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildZoomSection() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupZoomControl(for: embeddingView,
                                moduleInput: &parent.zoomModuleInput,
                                moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildUISection() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupUIControl(for: embeddingView,
                              moduleInput: &parent.uiModuleInput,
                              moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildLibrarySection() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupLibraryControl(for: embeddingView,
                                   moduleInput: &parent.libraryModuleInput,
                                   moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildFocusSection() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupFocusControl(for: embeddingView,
                                 moduleInput: &parent.focusModuleInput,
                                 moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildExposureSection() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupExposureControl(for: embeddingView,
                                    moduleInput: &parent.exposureModuleInput,
                                    moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildISOSection() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupISOControl(for: embeddingView,
                               moduleInput: &parent.isoModuleInput,
                               moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildWhiteBalanceSection() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupWhiteBalanceControl(for: embeddingView,
                                        moduleInput: &parent.whiteBalanceModuleInput,
                                        moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
}
