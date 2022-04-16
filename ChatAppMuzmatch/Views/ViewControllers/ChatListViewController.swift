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
    
    private func setUp() {
        title = "Chat List"
        navigationItem.backButtonTitle = ""
        tableView.delegate = self
        viewModel.dataSource = createDataSource()
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
    
}

extension ChatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatViewModel = viewModel.chatViewModel(at: indexPath.row)
        let chatViewController = ChatViewController.getInstance(with: chatViewModel)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}
