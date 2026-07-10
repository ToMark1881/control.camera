//
//  ControlGroupHeaderView.swift
//  control.camera
//

import UIKit

class ControlGroupHeaderView: UITableViewHeaderFooterView {

    static let preferredHeight: CGFloat = 40.0

    let titleLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

}

private extension ControlGroupHeaderView {

    func setupLayout() {
        contentView.backgroundColor = .black

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .Control.yellow
        titleLabel.font = .touchSans(weight: .bold, size: 17)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0)
        ])
    }

}
