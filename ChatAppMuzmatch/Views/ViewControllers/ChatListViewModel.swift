//
//  ChatListViewModel.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 16.04.2022.
//

import Foundation

class ChatListViewModel: ViewModel {
    
    private static let messageFactory = MessageFactory()
    
    private var snapshot = ChatListSnapshot()
    
    private let chats = [messageFactory.chat]
    
    private let user: User
    
    var dataSource: ChatListDataSource! {
        didSet {
            snapshot.appendSections([.main])
            snapshot.appendItems(chats, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    init(user: User) {
        self.user = user
    }
    
    func chatViewModel(at index: Int) -> ChatViewModel {
        return ChatViewModel(chat: chats[index], currentUser: user)
    }
    
}
