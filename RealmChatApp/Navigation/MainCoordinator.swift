//
//  MainCoordinator.swift
//  RealmChatApp
//
//  Created by Florin Uscatu on 23.04.2022.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let dataBaseManager = DataBaseManager()
        let userListViewController = UserListViewController.getInstance(with: UserListViewModel(dataManager: dataBaseManager))
        userListViewController.coordinator = self
        navigationController.pushViewController(userListViewController, animated: true)
    }
    
    func goToChatList(with viewModel: ChatListViewModel) {
        let chatListViewController = ChatListViewController.getInstance(with: viewModel)
        chatListViewController.coordinator = self
        navigationController.pushViewController(chatListViewController, animated: true)
    }
    
    func goToChat(with viewModel: ChatViewModel) {
        let chatViewController = ChatViewController.getInstance(with: viewModel)
        navigationController.pushViewController(chatViewController, animated: true)
    }
}
