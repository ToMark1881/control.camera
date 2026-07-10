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

    let pageControl = UIPageControl()
    let cameraContainerContainer = UIView()
    var cameraContainerView = CameraContainerView()
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: AlignedCollectionViewFlowLayout())
    
    var cameraContainerAspectRatioConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupUI()
        
        output.onViewDidLoad()
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
    
    func setCaptureAnimation(active: Bool) {
        cameraContainerView.setCaptureAnimation(active: active)
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
            self.collectionView.alpha = isActive ? 1.0 : 0.1
        }
    }
    
}

private extension MainCameraViewController {
    
    func setupLayout() {
        view.addSubview(cameraContainerContainer)
        cameraContainerContainer.ezl.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        cameraContainerContainer.ezl.bottomToSuperview(offset: -32, usingSafeArea: true)
        
        cameraContainerContainer.addSubview(cameraContainerView)
        cameraContainerView.ezl.centerXToSuperview()
        cameraContainerView.ezl.centerYToSuperview()
        cameraContainerView.ezl.widthToSuperview(priority: .defaultLow)
        cameraContainerView.ezl.heightToSuperview(priority: .defaultLow)
        cameraContainerView.ezl.topToSuperview(relation: .greaterThanOrEqual)
        cameraContainerView.ezl.leadingToSuperview(relation: .greaterThanOrEqual)
        cameraContainerView.ezl.trailingToSuperview(relation: .lessThanOrEqual)
        cameraContainerView.ezl.bottomToSuperview(relation: .lessThanOrEqual)
        cameraContainerAspectRatioConstraint = cameraContainerView.ezl.aspectRatio(1.0)

        view.addSubview(pageControl)
        pageControl.ezl.bottomToSuperview(usingSafeArea: true)
        pageControl.ezl.centerXToSuperview()

        view.addSubview(collectionView)
        collectionView.ezl.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        collectionView.ezl.bottomToTop(of: pageControl, offset: -6)
    }

    func setupUI() {
        view.backgroundColor = .black
        cameraContainerContainer.backgroundColor = .clear
        cameraContainerView.backgroundColor = .clear
        cameraContainerView.clipsToBounds = true
        cameraContainerView.layer.cornerRadius = 10.0

        pageControl.numberOfPages = 3

        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false

        collectionView.dataSource = dataSource
        collectionView.delegate = self

        let alignedFlowLayout = collectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .justified
        alignedFlowLayout?.scrollDirection = .horizontal
        alignedFlowLayout?.minimumLineSpacing = 0.0
        alignedFlowLayout?.minimumInteritemSpacing = 0.0
        
        ControlContainerCollectionViewCell.registerFor(collectionView: collectionView)
        ShutterButtonCollectionViewCell.registerFor(collectionView: collectionView)
    }
    
}
