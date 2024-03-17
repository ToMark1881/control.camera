import UIKit

protocol ReusableView {
    static func reuseIdentifier() -> String
}

extension ReusableView {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}

// MARK: - UITableViewCell

extension ReusableView where Self: UITableViewCell {
    static func registerFor(tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: Self.reuseIdentifier())
    }
}

extension UITableViewCell: ReusableView {}

// MARK: - UICollectionViewCell

extension ReusableView where Self: UICollectionViewCell {
    static func registerFor(collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: Self.reuseIdentifier())
    }
}

extension ReusableView where Self: UICollectionReusableView {
    static func registerView(collectionView: UICollectionView, kind: String) {
        collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: Self.reuseIdentifier())
    }
}

// MARK: - UITableViewHeaderFooterView

extension UITableViewHeaderFooterView: ReusableView {}

extension ReusableView where Self: UITableViewHeaderFooterView {
	static func registerFor(tableView: UITableView) {
		tableView.register(nib, forHeaderFooterViewReuseIdentifier: Self.reuseIdentifier())
	}
}

extension UICollectionReusableView: ReusableView { }
