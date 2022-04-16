//
//  UserListViewModel.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 16.04.2022.
//

import Foundation

class UserListViewModel: ViewModel {
    
    private let dataManager: MessageStoreManager
    
    private var snapshot = UserListSnapshot()
    
    var dataSource: UserListDataSource! {
        didSet {
            snapshot.appendSections([.main])
            let users = dataManager.fetchUsers()
            snapshot.appendItems(users, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    init(dataManager: MessageStoreManager) {
        self.dataManager = dataManager
    }
    
    func chatListViewModel(withUserFrom index: Int) -> ChatListViewModel {
        return ChatListViewModel(user: snapshot.itemIdentifiers[index], dataManager: dataManager)
    }
    
    func addUser(with name: String) {
        let user = User(name: name)
        snapshot.appendItems([user], toSection: .main)
        dataSource.apply(snapshot)
        dataManager.save(user)
    }
    
}
