//
//  UserListViewModel.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 16.04.2022.
//

import Foundation

class UserListViewModel: ViewModel {
    
    private var snapshot = UserListSnapshot()
    
    private static let messageFactory = MessageFactory()
    
    private let users = [messageFactory.currentUser]
    
    var dataSource: UserListDataSource! {
        didSet {
            snapshot.appendSections([.main])
            snapshot.appendItems(users, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func chatListViewModel(withUserFrom index: Int) -> ChatListViewModel {
        return ChatListViewModel(user: users[index])
    }
    
}
