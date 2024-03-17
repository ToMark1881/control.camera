import UIKit

protocol TableCellViewModel: CellViewModel {
    func setup(on cell: UITableViewCell)
}

class BaseTableCellViewModel<T: UITableViewCell>: BaseCellViewModel<T>, TableCellViewModel {
    
    func setup(on cell: UITableViewCell) {
        if let cell = cell as? CellType {
            setup(on: cell)
        }
    }
    
    func setup(on cell: CellType) {
        
    }
}
