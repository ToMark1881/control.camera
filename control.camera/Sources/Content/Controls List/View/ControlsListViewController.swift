//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ControlsListViewController.swift
//  control.camera
//
//  Created by Vladyslav Vdovychenko on 29.03.2024.
//

import UIKit

final class ControlsListViewController: BaseViewController {
    
    // MARK: - Injected
    
    var output: ControlsListViewOutput!
    var dataSource: TableViewDataSource!

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        output.onViewDidLoad()
    }

}

extension ControlsListViewController: ControlsListViewInput {

    func update(with sections: [TableSectionModel]) {
        dataSource.update(with: sections)
        tableView.reloadData()
    }
    
}

extension ControlsListViewController: UITableViewDelegate {
    
}

private extension ControlsListViewController {
    
    func setupUI() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        ControlTableViewCell.registerFor(tableView: tableView)
    }
    
}
