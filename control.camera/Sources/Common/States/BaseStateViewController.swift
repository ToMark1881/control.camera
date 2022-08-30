//
//  BaseStateViewController.swift
//  TemplateApplication
//
//  Created by Vladyslav Vdovychenko on 02.04.2022.
//

import UIKit

class BaseStateViewController: BaseViewController, StatesViewsDataSource, ReloadContentViewDelegate {
    
    fileprivate lazy var statesHandler = { return StatesViewsHandler() }()
    
    var isLoading: Bool = false
    
    func changeState(_ state: ViewState, view: UIView? = nil) {
        if self.statesHandler.currentState == state { return }
        if let view = view {
            self.statesHandler.change(state: state, onView: view, dataSource: self)
        } else {
            self.statesHandler.change(state: state, onView: self.view, dataSource: self)
        }
    }
    
    // MARK: - States Views
    
    func initialView() -> UIView {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .tertiarySystemBackground
        } else {
            view.backgroundColor = .white
        }
        
        return view
    }
    
    func contentView() -> UIView {
        return self.view
    }
    
    func loadingView() -> UIView {
        let view = LoadingView.shared
        view.playAnimationView()
        return view
    }
    
    func errorView() -> UIView {
        let view: ReloadContentView = .fromNib()
        view.delegate = self
        return view
    }
    
    func nothingView() -> UIView {
        let view = UINib(nibName: "NothingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? NothingView ?? NothingView()
        return view
    }
    
    // MARK: - State Delegates (Must override)
    
    func didTapOnReloadContentViewButton(_ view: ReloadContentView, sender: UIButton) {
        // do not call super.didTapOnReloadContentViewButton()!
        fatalError("Must initialize reloadContentView")
    }

}
