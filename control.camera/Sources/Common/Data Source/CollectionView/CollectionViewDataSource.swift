import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    typealias Model = CollectionSectionModel.Model
    
    // MARK: - Public Variables

    private(set) var sections = [CollectionSectionModel]()

    // MARK: - Public
    
    func update(with sections: [CollectionSectionModel]) {
        self.sections = sections
    }

    func update(section index: Int, with items: [Model]) {
        self.sections[index].update(items: items)
    }
    
    func updateFirstItem(section index: Int, condition: (Model) -> Bool, updateBlock: () -> Model) -> Bool {
        guard let section = sections[safe: index] else { return false }
        
        return section.updateFirstItem(condition: condition, updateBlock: updateBlock)
    }

    func append(section index: Int, items: [Model]) {
        sections[safe: index]?.append(items: items)
    }

    func objectAtIndexPath(_ indexPath: IndexPath) -> Model {
        return sections[indexPath.section].items[indexPath.row]
    }

    func indexPathForObject(_ object: Model) -> IndexPath? {
        guard let section = sections.firstIndex(where: { $0.index(for: object) != nil }),
              let index = sections[section].index(for: object)
        else {
            return nil
        }
        
        return IndexPath(row: index, section: section)
    }

    func removeObjectAtIndexPath(_ indexPath: IndexPath) -> Model? {
        guard let section = sections[safe: indexPath.section],
              section.items.count > indexPath.row
        else { return nil }
        
        return section.items.remove(at: indexPath.row)
    }
    
    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let model = section.items[indexPath.row]
        let reuseIdentifier = model.reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        model.setup(on: cell)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let model = sections[safe: indexPath.section]?.supplementaryViewModel(of: kind) else {
            return UICollectionReusableView()
        }
        
        let reuseIdentifier = model.reuseIdentifier
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: reuseIdentifier,
                                                                         for: indexPath as IndexPath)
        model.setup(on: view)
        
        return view
    }
}

extension CollectionViewDataSource {
    func sizeForSupplimentary(for collectionView: UICollectionView, section: Int, kind: String) -> CGSize {
        guard let model = sections[safe: section]?.supplementaryViewModel(of: kind) else {
            return .zero
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: model.reuseIdentifier,
                                                                   for: IndexPath(row: 0, section: 0))
        
        model.setup(on: view)
        
        let width = view.bounds.width > 0 ? view.bounds.width : collectionView.bounds.width
        let size = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let fittingSize = view.systemLayoutSizeFitting(size, withHorizontalFittingPriority: .required,
                                                       verticalFittingPriority: .fittingSizeLevel)
        
        return CGSize(width: width, height: fittingSize.height)
    }
}
