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
    
    private let user: User
    private let dataManager: MessageStoreManager
    
    var dataSource: ChatListDataSource! {
        didSet {
            snapshot.appendSections([.main])
            let chats = dataManager.fetchChats()
            snapshot.appendItems(chats, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    init(user: User, dataManager: MessageStoreManager) {
        self.user = user
        self.dataManager = dataManager
    }
    
    func chatViewModel(at index: Int) -> ChatViewModel {
        let chats = snapshot.itemIdentifiers
        return ChatViewModel(chat: chats[index], currentUser: user)
    }
    
    func addChat(with name: String) {
        let chat = Chat(messages: [], name: name)
        snapshot.appendItems([chat], toSection: .main)
        dataSource.apply(snapshot)
        dataManager.save(chat)
    }
    
}
