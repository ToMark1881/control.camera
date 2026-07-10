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
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var removeControlButton: ControlCameraButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        output.onViewDidLoad()
    }
    
    @IBAction func didTapOnRemoveControlButton(_ sender: Any) {
        output.onRemoveControlTap()
    }
    
}

extension ControlsListViewController: ControlsListViewInput {

    func update(with properties: ControlsListViewProperties) {
        dataSource.update(with: properties.sections)
        tableView.reloadData()
        
        removeControlButton.setup(with: properties.removeButtonStyle)
        buttonContainer.isHidden = !properties.shouldShowRemoveButton
    }
    
}

extension ControlsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource.objectAtIndexPath(indexPath)

        output.didSelect(model: model)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerViewModel = dataSource.sections[safe: section]?.header as? ControlGroupHeaderViewModel,
              let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ControlGroupHeaderView.reuseIdentifier()) as? ControlGroupHeaderView else {
            return nil
        }

        headerViewModel.setup(on: headerView)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard dataSource.sections[safe: section]?.header != nil else {
            return 0.0
        }

        return ControlGroupHeaderView.preferredHeight
    }

}

private extension ControlsListViewController {
    
    func setupUI() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        ControlTableViewCell.registerFor(tableView: tableView)
        tableView.register(ControlGroupHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: ControlGroupHeaderView.reuseIdentifier())
    }
    
}
