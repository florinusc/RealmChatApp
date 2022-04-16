//
//  UserListViewController.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 16.04.2022.
//

import UIKit

enum UserListSection {
    case main
}

typealias UserListDataSource = UITableViewDiffableDataSource<UserListSection, User>
typealias UserListSnapshot = NSDiffableDataSourceSnapshot<UserListSection, User>

class UserListViewController: UIViewController, ViewModelBased, StoryboardViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: UserListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        title = "Users"
        navigationItem.backButtonTitle = ""
        tableView.delegate = self
        viewModel.dataSource = createDataSource()
    }
    
    private func createDataSource() -> UserListDataSource {
        let dataSource = UserListDataSource(tableView: tableView) { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            let cell = UITableViewCell()
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.name
            cell.contentConfiguration = configuration
            return cell
        }
        return dataSource
    }
    
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatListViewModel = viewModel.chatListViewModel(withUserFrom: indexPath.row)
        let chatListViewController = ChatListViewController.getInstance(with: chatListViewModel)
        navigationController?.pushViewController(chatListViewController, animated: true)
    }
}
