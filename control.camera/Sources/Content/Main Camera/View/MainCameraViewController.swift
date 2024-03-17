//  VIPER Template created by Vladyslav Vdovychenko
//  
//  MainCameraViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 21.10.2022.
//

import UIKit

class MainCameraViewController: BaseViewController {
    
    // MARK: - Injected
    
    var output: MainCameraViewOutputProtocol!
    var dataSource: CollectionViewDataSource!

    @IBOutlet weak var cameraContainerContainer: UIView!
    @IBOutlet weak var cameraContainerView: CameraContainerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shutterButton: ShutterButton!
    
    @IBOutlet weak var cameraContainerAspectRatioConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.onViewDidLoad()
        setupUI()
    }

    @IBAction func didTapOnShutterButton(_ sender: Any) {
        output.didTapOnShutter()
    }
    
    func setupUI() {
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        ControlContainerCollectionViewCell.registerFor(collectionView: collectionView)
    }
}

extension MainCameraViewController: UICollectionViewDelegate { }

extension MainCameraViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size.width / 3.0
        
        return .init(width: size, height: size)
    }
    
}

extension MainCameraViewController: MainCameraViewInputProtocol {

    func setup(with sections: [CollectionSectionModel]) {
        dataSource.update(with: sections)
        
        collectionView.reloadData()
    }
    
}

extension MainCameraViewController: CameraViewConfiguration {
    
    func setupCameraLayer(_ layer: CALayer) {
        cameraContainerView.layer.addSublayer(layer)
        cameraContainerView.cameraLayer = layer
        layer.frame = cameraContainerView.layer.frame
        
        view.bringSubviewToFront(shutterButton)
        
        output.didSetupCameraLayer()
        shutterButton.isEnabled = true
    }
    
    func showControlContainer(_ isActive: Bool) {
        UIView.animate(withDuration: 0.25) {
            
        }
    }
    
}
