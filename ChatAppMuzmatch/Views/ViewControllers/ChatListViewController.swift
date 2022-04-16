//
//  ChatListViewController.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 16.04.2022.
//

import UIKit

enum ChatListSection {
    case main
}

typealias ChatListDataSource = UITableViewDiffableDataSource<ChatListSection, Chat>
typealias ChatListSnapshot = NSDiffableDataSourceSnapshot<ChatListSection, Chat>

class ChatListViewController: UIViewController, ViewModelBased, StoryboardViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: ChatListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateChats()
    }
    
    private func setUp() {
        setUpNavBar()
        tableView.delegate = self
        viewModel.dataSource = createDataSource()
    }
    
    private func setUpNavBar() {
        title = "Chat List"
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChat))
    }
    
    private func createDataSource() -> ChatListDataSource {
        let dataSource = ChatListDataSource(tableView: tableView) { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            let cell = UITableViewCell()
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.name
            cell.contentConfiguration = configuration
            return cell
        }
        return dataSource
    }
    
    @objc private func addChat() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new chat", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Name"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Add chat", style: .default) { [weak self] action in
            guard let name = textField.text, name != "" else { return }
            self?.viewModel.addChat(with: name)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ChatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatViewModel = viewModel.chatViewModel(at: indexPath.row)
        let chatViewController = ChatViewController.getInstance(with: chatViewModel)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}
