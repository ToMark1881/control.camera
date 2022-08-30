//
//  BaseWireframe.swift
//
//
//  Created by macbook on 09.10.2020.
//

import Foundation
import UIKit

typealias EmptyCompletionBlock = (() -> Void)?

class BaseWireframe: NSObject {

    weak var presentedViewController: UIViewController?

    override init() {
        super.init()
        Logger.shared.log("🆕 \(self)", type: .lifecycle)
    }
    
    deinit {
        Logger.shared.log("🗑 \(self)", type: .lifecycle)
    }

    func initializeController<T: UIViewController>() -> T? {
        return self.storyboard.instantiateViewController(withIdentifier: identifier()) as? T
    }
    
    func instantiateFromNib<T: UIViewController>() -> T? {
        return T.init(nibName: String(describing: T.self), bundle: Bundle.init(for: Self.self))
    }

    var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName(), bundle: nil)
    }

    func storyboardName() -> String {
        assert(false, "Must override")

        return ""
    }

    func identifier() -> String {
        assert(false, "Must override")

        return ""
    }

    var isShowed: Bool {
        return self.presentedViewController != nil
    }

    func dismissViewController(animated: Bool = true, completion: EmptyCompletionBlock = nil) {
        self.presentedViewController?.dismiss(animated: animated) {
            self.presentedViewController = nil
            completion?()
        }
    }
    
    func popToRootViewController(animated: Bool = true) {
        if let nav = self.presentedViewController?.navigationController {
            nav.popToRootViewController(animated: animated)
        } else {
            dismissViewController(animated: animated)
        }
    }
    
    func popViewController(animated: Bool = true, completion: EmptyCompletionBlock = nil) {
        if let nav = self.presentedViewController?.navigationController {
            if completion == nil {
                nav.popViewController(animated: animated)
            } else {
                nav.popViewControllerWithHandler(completion: completion)
            }
        } else {
            dismissViewController(animated: animated)
        }
    }
}
