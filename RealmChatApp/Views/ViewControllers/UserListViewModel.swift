//
//  UserListViewModel.swift
//  RealmChatApp
//
//  Created by Florin Uscatu on 16.04.2022.
//

import Foundation

class UserListViewModel: ViewModel {
    private let dataManager: DataBaseManager
    
    var dataSource: UserListDataSource! {
        didSet {
            updateUsers()
        }
    }
    
    private var snapshot = UserListSnapshot()
    
    init(dataManager: DataBaseManager) {
        self.dataManager = dataManager
    }
    
    func chatListViewModel(withUserFrom index: Int) -> ChatListViewModel {
        return ChatListViewModel(user: snapshot.itemIdentifiers[index], dataManager: dataManager)
    }
    
    func addUser(with name: String) {
        let user = User(name: name)
        snapshot.appendItems([user], toSection: .main)
        dataSource.apply(snapshot)
        try? dataManager.save(user)
    }
    
    private func updateUsers() {
        snapshot.appendSections([.main])
        let users = try? dataManager.fetchUsers()
        snapshot.appendItems(users ?? [], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
