//
//  UserListViewController.swift
//  RealmChatApp
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
        setUpNavBar()
        tableView.delegate = self
        viewModel.dataSource = createDataSource()
    }
    
    private func setUpNavBar() {
        title = "Users"
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))
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
    
    @objc private func addUser() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new user", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Name"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Add user", style: .default) { [weak self] action in
            guard let name = textField.text, name != "" else { return }
            self?.viewModel.addUser(with: name)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
