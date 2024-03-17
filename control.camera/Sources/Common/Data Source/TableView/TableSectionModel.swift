import UIKit

protocol TableSectionHeaderViewModel {}
class TableSectionHeaderViewModelDummy: TableSectionHeaderViewModel {}

protocol TableSectionFooterViewModel {}
class TableSectionFooterViewModelDummy: TableSectionFooterViewModel {}

class TableSectionModel {
    typealias Model = TableCellViewModel
    
    var items: [Model]
    var header: TableSectionHeaderViewModel?
    var footer: TableSectionFooterViewModel?
    
    init(with items: [Model],
         header: TableSectionHeaderViewModel? = nil,
         footer: TableSectionFooterViewModel? = nil) {
        self.items = items
        self.header = header
        self.footer = footer
    }
    
    func update(items: [Model]) {
        self.items = items
    }
    
    func updateFirstItem(condition: (Model) -> Bool, updateBlock: () -> Model) -> Bool {
        var updateIndex: Int?
        for (index, model) in items.enumerated() {
            if condition(model) == true {
                updateIndex = index
                break
            }
        }
        if let newIndex = updateIndex {
            items[newIndex] = updateBlock()
            return true
        }
        
        return false
    }
    
    func updateItem(at index: Int, condition: (Model) -> Bool, updateBlock: () -> Model) -> Bool {
        if let _ = items[safe: index] {
            items[index] = updateBlock()
            return true
        }
        
        return false
    }
    
    func append(items: [Model]) {
        self.items.append(contentsOf: items)
    }
    
    func index(for object: Model) -> Int? {
        guard let index = items.firstIndex(where: { $0 === object }) else {
            return nil
        }
        return index
    }
}
