import UIKit

protocol CollectionReusableViewModel: ReusableViewModel {
    func setup(on reusableView: UICollectionReusableView)
}

class BaseCollectionReusableViewModel<T: UICollectionReusableView>: BaseReusableViewModel<T>, CollectionReusableViewModel {
    
    func setup(on reusableView: UICollectionReusableView) {
        if let reusableView = reusableView as? ReusableViewType {
            setup(on: reusableView)
        }
    }
    
    func setup(on reusableView: ReusableViewType) {
        
    }
}
