import UIKit

class CollectionSectionModel {
    typealias Model = CollectionCellViewModel
    typealias HeaderModel = CollectionReusableViewModel
    typealias FooterModel = CollectionReusableViewModel
    
    var skeletonIdentifier: String?
    var items: [Model]
    var headerModel: HeaderModel?
    var footerModel: FooterModel?
    
    init(with items: [Model],
         skeletonIdentifier: String? = nil,
         headerModel: HeaderModel? = nil,
         footerModel: FooterModel? = nil) {
        self.items = items
        self.skeletonIdentifier = skeletonIdentifier
        self.headerModel = headerModel
        self.footerModel = footerModel
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
    
    func append(items: [Model]) {
        self.items.append(contentsOf: items)
    }
    
    func index(for object: Model) -> Int? {
        guard let index = items.firstIndex(where: { $0 === object }) else {
            return nil
        }
        return index
    }
    
    func supplementaryViewModel(of kind: String) -> CollectionReusableViewModel? {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return headerModel
        case UICollectionView.elementKindSectionFooter:
            return footerModel
        default:
            return nil
        }
    }
}
