//
//  ChatListViewModel.swift
//  RealmChatApp
//
//  Created by Florin Uscatu on 16.04.2022.
//

import Foundation

class ChatListViewModel: ViewModel {
    private let user: User
    private let dataManager: DataBaseManager
    
    var dataSource: ChatListDataSource!
    
    private var snapshot = ChatListSnapshot()
    
    init(user: User, dataManager: DataBaseManager) {
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
        try? dataManager.save(chat)
    }
    
    func updateChats() {
        let chats = try? dataManager.fetchChats()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(chats ?? [], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
