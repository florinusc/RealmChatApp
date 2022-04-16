//
//  ChatListViewModel.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 16.04.2022.
//

import Foundation

class ChatListViewModel: ViewModel {
    
    private var snapshot = ChatListSnapshot()
    
    private let user: User
    private let dataManager: MessageStoreManager
    
    var dataSource: ChatListDataSource! {
        didSet {
            updateChats()
        }
    }
    
    init(user: User, dataManager: MessageStoreManager) {
        self.user = user
        self.dataManager = dataManager
    }
    
    func chatViewModel(at index: Int) -> ChatViewModel {
        let chats = snapshot.itemIdentifiers
        return ChatViewModel(chat: chats[index], currentUser: user, dataManager: dataManager)
    }
    
    func addChat(with name: String) {
        let chat = Chat(messages: [], name: name)
        snapshot.appendItems([chat], toSection: .main)
        dataSource.apply(snapshot)
        dataManager.save(chat)
    }
    
    func updateChats() {
        let chats = dataManager.fetchChats()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(chats, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
