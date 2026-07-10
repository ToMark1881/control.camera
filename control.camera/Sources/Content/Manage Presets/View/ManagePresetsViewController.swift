//  VIPER Template created by Vladyslav Vdovychenko
//
//  ManagePresetsViewController.swift
//  control.camera
//

import UIKit

final class ManagePresetsViewController: BaseViewController {

    // MARK: - Injected

    var output: ManagePresetsViewOutput!
    var dataSource: TableViewDataSource!

    // MARK: - UI

    private let titleLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let emptyStateLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        output.onViewDidLoad()
    }

}

extension ManagePresetsViewController: ManagePresetsViewInput {

    func update(with properties: ManagePresetsViewProperties) {
        dataSource.update(with: properties.sections)
        tableView.reloadData()

        emptyStateLabel.isHidden = !properties.isEmptyStateVisible
    }

}

extension ManagePresetsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            self?.output.didDeletePreset(at: indexPath.row)
            completion(true)
        }
        
        let label = UILabel()
        label.text = "Delete"
        label.font = .touchSans(weight: .semiBold, size: 13)
        label.sizeToFit()
        deleteAction.image = UIImage(view: label)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}

private extension ManagePresetsViewController {

    func setupUI() {
        view.backgroundColor = .black

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = ControlType.managePresets.title
        titleLabel.textColor = .white
        titleLabel.font = .touchSans(weight: .bold, size: 28)
        view.addSubview(titleLabel)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .darkGray
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(PresetTableViewCell.self,
                           forCellReuseIdentifier: PresetTableViewCell.reuseIdentifier())
        view.addSubview(tableView)

        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.text = "No presets yet.\nSet up a look and tap Save Preset"
        emptyStateLabel.textColor = .lightGray
        emptyStateLabel.font = .systemFont(ofSize: 15.0)
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.isHidden = true
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24.0),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24.0)
        ])
    }

}
