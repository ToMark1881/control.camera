//  VIPER Template created by Vladyslav Vdovychenko
//  
//  OnboardingViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class OnboardingViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var galleryPermissionButton: UIButton!
    @IBOutlet weak var cameraPermissionButton: UIButton!
    @IBOutlet weak var openCameraButton: ControlCameraButton!
        
    //MARK: - Injected
    var output: OnboardingViewOutputProtocol!
    var dataSource: CollectionViewDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        output.onViewDidLoad()
    }
    
    @IBAction func didTapOnOpenCameraButton(_ sender: Any) {
        output.didTapOnCameraButton()
    }
    
    @IBAction func didTapOnCameraPermissionButton(_ sender: Any) {
        output.didTapOnCameraPermissionButton()
    }
    
    @IBAction func didTapOnGalleryPermissionButton(_ sender: Any) {
        output.didTapOnGalleyPermissionButton()
    }
    
}

extension OnboardingViewController: OnboardingViewInputProtocol {
    
    func setup(with props: OnboardingViewProps) {
        openCameraButton.setup(with: props.cameraButtonStyle)
        galleryPermissionButton.isHidden = !props.shouldShowGalleryPermissionButton
        cameraPermissionButton.isHidden = !props.shouldShowCameraPermissionButton
        
        dataSource.update(with: props.sections)
        collectionView.reloadData()
    }

}

private extension OnboardingViewController {
    
    func setupUI() {
        collectionView.dataSource = dataSource
        ControlContainerCollectionViewCell.registerFor(collectionView: collectionView)
    }
    
}
