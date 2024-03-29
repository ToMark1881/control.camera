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

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var cameraContainerContainer: UIView!
    @IBOutlet weak var cameraContainerView: CameraContainerView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cameraContainerAspectRatioConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.onViewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        let alignedFlowLayout = collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .justified
        
        ControlContainerCollectionViewCell.registerFor(collectionView: collectionView)
        ShutterButtonCollectionViewCell.registerFor(collectionView: collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.onViewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.onViewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.onViewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        output.onViewDidDisappear()
    }
}

extension MainCameraViewController: UICollectionViewDelegate { 
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2

        pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    
}

extension MainCameraViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeByWidth = collectionView.frame.size.width / 3.0
        let sizeByHeight = collectionView.frame.size.height / 6.0
        
        return .init(width: sizeByWidth, height: sizeByHeight)
    }
    
}

extension MainCameraViewController: MainCameraViewInputProtocol {

    func setup(with sections: [CollectionSectionModel]) {
        dataSource.update(with: sections)
        
        collectionView.reloadData()
    }
    
    func setPhotoBorder(active: Bool) {
        cameraContainerView.borderWidth = active ? 1.0 : 0.0
    }
    
}

extension MainCameraViewController: CameraViewConfiguration {
    
    func setupCameraLayer(_ layer: CALayer) {
        cameraContainerView.layer.addSublayer(layer)
        cameraContainerView.cameraLayer = layer
        layer.frame = cameraContainerView.layer.frame
        
        output.didSetupCameraLayer()
    }
    
    func setCameraLayer(hidden: Bool) {
        cameraContainerView.isHidden = hidden
    }
    
    func showControlContainer(_ isActive: Bool) {
        UIView.animate(withDuration: 0.25) {
            
        }
    }
    
}
