import UIKit

protocol CollectionCellViewModel: CellViewModel {
    func setup(on cell: UICollectionViewCell)
}

class BaseCollectionCellViewModel<T: UICollectionViewCell>: BaseCellViewModel<T>, CollectionCellViewModel {
    
    func setup(on cell: UICollectionViewCell) {
        if let cell = cell as? CellType {
            setup(on: cell)
        }
    }
    
    func setup(on cell: CellType) {
        cell.contentView.backgroundColor = .darkGray
    }
}
