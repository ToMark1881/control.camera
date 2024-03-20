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
                viewModel = buildFlashViewModel()
            case .form:
                viewModel = buildFormViewModel()
            case .device:
                viewModel = buildDeviceViewModel()
            case .zoom:
                viewModel = buildZoomViewModel()
            case .ui:
                viewModel = buildUIViewModel()
            case .library:
                viewModel = buildLibraryViewModel()
            case .focus:
                viewModel = buildFocusViewModel()
            case .exposure:
                viewModel = buildExposureViewModel()
            case .iso:
                viewModel = buildISOViewModel()
            case .whiteBalance:
                viewModel = buildWhiteBalanceViewModel()
            case .shutter:
                viewModel = buildShutterButtonViewModel()
            case .arrange:
                viewModel = buildArrangeViewModel()
            case .empty:
                viewModel = buildEmptyViewModel()
            }
            
            viewModels.append(viewModel)
        }
        
        let section = CollectionSectionModel(with: viewModels)
        sections.append(section)
        
        return sections
    }
    
}

private extension MainCameraModulesBuilderImplementation {
    
    func buildFlashViewModel() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupLightControl(for: embeddingView,
                                 moduleInput: &parent.lightModuleInput,
                                 moduleOutput: parent)
        return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildFormViewModel() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupFormControl(for: embeddingView,
                                moduleInput: &parent.formModuleInput,
                                moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildDeviceViewModel() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupDeviceControl(for: embeddingView,
                                  moduleInput: &parent.deviceModuleInput,
                                  moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildZoomViewModel() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupZoomControl(for: embeddingView,
                                moduleInput: &parent.zoomModuleInput,
                                moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildUIViewModel() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupUIControl(for: embeddingView,
                              moduleInput: &parent.uiModuleInput,
                              moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildLibraryViewModel() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupLibraryControl(for: embeddingView,
                                   moduleInput: &parent.libraryModuleInput,
                                   moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildFocusViewModel() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupFocusControl(for: embeddingView,
                                 moduleInput: &parent.focusModuleInput,
                                 moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildExposureViewModel() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupExposureControl(for: embeddingView,
                                    moduleInput: &parent.exposureModuleInput,
                                    moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildISOViewModel() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupISOControl(for: embeddingView,
                               moduleInput: &parent.isoModuleInput,
                               moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildWhiteBalanceViewModel() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupWhiteBalanceControl(for: embeddingView,
                                        moduleInput: &parent.whiteBalanceModuleInput,
                                        moduleOutput: parent)
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildShutterButtonViewModel() -> CollectionCellViewModel {
        let viewModel = ShutterButtonCellViewModel(action: parent.shutterButtonAction)
        parent.shutterButtonInput = viewModel
        
        return viewModel
    }
    
    func buildArrangeViewModel() -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupArrangeControl(for: embeddingView,
                                   moduleInput: &parent.arrangeModuleInput,
                                   moduleOutput: parent)
        
        return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildEmptyViewModel() -> CollectionCellViewModel {
        return ControlContainerCellViewModel(embeddedView: UIView())
    }
    
}
