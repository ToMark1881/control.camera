import UIKit

protocol ReusableViewModel: AnyObject {
    static var reusableIdentifier: String { get }
    static var viewType: AnyClass { get }
    
    var reuseIdentifier: String { get }
}

class BaseReusableViewModel<ReusableViewType: ReusableView> {
    typealias ReusableViewType = ReusableViewType
}

extension BaseReusableViewModel: ReusableViewModel
    where ReusableViewType: UIView, ReusableViewType: ReusableView {
    
    static var reusableIdentifier: String {
        return ReusableViewType.reuseIdentifier()
    }
    
    static var viewType: AnyClass {
        return ReusableViewType.self
    }
    
    var reuseIdentifier: String { Self.reusableIdentifier }
}
