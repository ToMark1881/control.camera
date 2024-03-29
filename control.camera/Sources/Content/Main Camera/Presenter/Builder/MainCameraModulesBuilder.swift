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
        
        for index in orderedControls.indices {
            let controlType = orderedControls[index]
            var viewModel: CollectionCellViewModel
            
            switch controlType {
            case .flash:
                viewModel = buildFlashViewModel(for: index)
            case .form:
                viewModel = buildFormViewModel(for: index)
            case .device:
                viewModel = buildDeviceViewModel(for: index)
            case .zoom:
                viewModel = buildZoomViewModel(for: index)
            case .ui:
                viewModel = buildUIViewModel(for: index)
            case .library:
                viewModel = buildLibraryViewModel(for: index)
            case .focus:
                viewModel = buildFocusViewModel(for: index)
            case .exposure:
                viewModel = buildExposureViewModel(for: index)
            case .iso:
                viewModel = buildISOViewModel(for: index)
            case .whiteBalance:
                viewModel = buildWhiteBalanceViewModel(for: index)
            case .shutter:
                viewModel = buildShutterButtonViewModel(for: index)
            case .arrange:
                viewModel = buildArrangeViewModel(for: index)
            case .empty:
                viewModel = buildEmptyViewModel(for: index)
            }
            
            viewModels.append(viewModel)
        }
        
        let section = CollectionSectionModel(with: viewModels)
        sections.append(section)
        
        return sections
    }
    
}

private extension MainCameraModulesBuilderImplementation {
    
    func buildFlashViewModel(for index: Int) -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupLightControl(for: embeddingView,
                                 moduleInput: &parent.lightModuleInput,
                                 moduleOutput: parent)
        parent.lightModuleInput?.setControl(index: index)
        
        return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildFormViewModel(for index: Int) -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupFormControl(for: embeddingView,
                                moduleInput: &parent.formModuleInput,
                                moduleOutput: parent)
        parent.formModuleInput?.setControl(index: index)
        
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildDeviceViewModel(for index: Int) -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupDeviceControl(for: embeddingView,
                                  moduleInput: &parent.deviceModuleInput,
                                  moduleOutput: parent)
        parent.deviceModuleInput?.setControl(index: index)
        
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildZoomViewModel(for index: Int) -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupZoomControl(for: embeddingView,
                                moduleInput: &parent.zoomModuleInput,
                                moduleOutput: parent)
        parent.zoomModuleInput?.setControl(index: index)
        
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildUIViewModel(for index: Int) -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupUIControl(for: embeddingView,
                              moduleInput: &parent.uiModuleInput,
                              moduleOutput: parent)
        parent.uiModuleInput?.setControl(index: index)
        
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildLibraryViewModel(for index: Int) -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupLibraryControl(for: embeddingView,
                                   moduleInput: &parent.libraryModuleInput,
                                   moduleOutput: parent)
        parent.libraryModuleInput?.setControl(index: index)
        
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildFocusViewModel(for index: Int) -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupFocusControl(for: embeddingView,
                                 moduleInput: &parent.focusModuleInput,
                                 moduleOutput: parent)
        parent.focusModuleInput?.setControl(index: index)
        
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildExposureViewModel(for index: Int) -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupExposureControl(for: embeddingView,
                                    moduleInput: &parent.exposureModuleInput,
                                    moduleOutput: parent)
        parent.exposureModuleInput?.setControl(index: index)
        
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildISOViewModel(for index: Int) -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupISOControl(for: embeddingView,
                               moduleInput: &parent.isoModuleInput,
                               moduleOutput: parent)
        parent.isoModuleInput?.setControl(index: index)
        
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildWhiteBalanceViewModel(for index: Int) -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupWhiteBalanceControl(for: embeddingView,
                                        moduleInput: &parent.whiteBalanceModuleInput,
                                        moduleOutput: parent)
        parent.whiteBalanceModuleInput?.setControl(index: index)
        
       return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildShutterButtonViewModel(for index: Int) -> CollectionCellViewModel {
        let viewModel = ShutterButtonCellViewModel(action: parent.shutterButtonAction)
        parent.shutterButtonInput = viewModel
        
        return viewModel
    }
    
    func buildArrangeViewModel(for index: Int) -> CollectionCellViewModel {
        let embeddingView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        router.setupArrangeControl(for: embeddingView,
                                   moduleInput: &parent.arrangeModuleInput,
                                   moduleOutput: parent)
        parent.arrangeModuleInput?.setControl(index: index)
        
        return ControlContainerCellViewModel(embeddedView: embeddingView)
    }
    
    func buildEmptyViewModel(for index: Int) -> CollectionCellViewModel {
        return ControlContainerCellViewModel(embeddedView: UIView())
    }
    
}
