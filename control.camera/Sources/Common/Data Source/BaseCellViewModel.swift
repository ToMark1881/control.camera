import UIKit

protocol CellViewModel: AnyObject {
    var reusableIdentifier: String? { get set }
    static var cellType: AnyClass { get }
    var reuseIdentifier: String { get }
}

class BaseCellViewModel<CellType: ReusableView> {
    typealias CellType = CellType
    
    var reusableIdentifier: String?
}

extension BaseCellViewModel: CellViewModel
    where CellType: UIView, CellType: ReusableView {
    
    static var cellType: AnyClass {
        return CellType.self
    }
    
    var reuseIdentifier: String { reusableIdentifier ?? Self.CellType.reuseIdentifier() }
}
