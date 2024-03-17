import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource {
    typealias Model = TableSectionModel.Model
    
    // MARK: - Public Variables

    private(set) var sections = [TableSectionModel]()

    // MARK: - Public
    
    func update(with sections: [TableSectionModel]) {
        self.sections = sections
    }

    func update(section index: Int, with items: [Model]) {
        self.sections[index].update(items: items)
    }
    
    @discardableResult func updateFirstItem(section index: Int, condition: (Model) -> Bool, updateBlock: () -> Model) -> Bool {
        guard let section = sections[safe: index] else { return false }
        
        return section.updateFirstItem(condition: condition, updateBlock: updateBlock)
    }
    
    @discardableResult func updateItem(at indexPath: IndexPath, condition: (Model) -> Bool, updateBlock: () -> Model) -> Bool {
        guard let section = sections[safe: indexPath.section] else { return false }
        
        return section.updateItem(at: indexPath.row, condition: condition, updateBlock: updateBlock)
    }
    
    func append(section: TableSectionModel) {
        sections.append(section)
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
    
    func sectionIndexForObject(_ object: Model) -> Int? {
        return sections.firstIndex { $0.items.first?.reuseIdentifier == object.reuseIdentifier }
    }

    func removeObjectAtIndexPath(_ indexPath: IndexPath) -> Model? {
        guard let section = sections[safe: indexPath.section],
              section.items.count > indexPath.row
        else { return nil }
        
        return section.items.remove(at: indexPath.row)
    }
    
    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let model = section.items[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: model.reuseIdentifier) {
            model.setup(on: cell)
            return cell
        }
        return UITableViewCell()
    }
}
