//
//  PresetTableViewCell.swift
//  control.camera
//

import UIKit

class PresetTableViewCell: UITableViewCell {

    let nameTextField = UITextField()
    let parametersLabel = UILabel()

    var onRename: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onRename = nil
    }

}

extension PresetTableViewCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        onRename?(textField.text ?? "")
    }

}

private extension PresetTableViewCell {

    func setupLayout() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .white
        nameTextField.font = .touchSans(weight: .semiBold, size: 17)
        nameTextField.returnKeyType = .done
        nameTextField.delegate = self
        contentView.addSubview(nameTextField)

        parametersLabel.translatesAutoresizingMaskIntoConstraints = false
        parametersLabel.textColor = .lightGray
        parametersLabel.font = .touchSans(weight: .regular, size: 13)
        parametersLabel.numberOfLines = 0
        contentView.addSubview(parametersLabel)

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),

            parametersLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 4.0),
            parametersLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            parametersLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            parametersLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.0)
        ])
    }

}
