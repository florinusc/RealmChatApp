//
//  ChatViewModel.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import Foundation

class ChatViewModel: ViewModel {
    private let currentUser: User
    private let chatManager: ChatManager
    
    var dataSource: ChatDataSource! {
        didSet {
            let snapshot = chatManager.createInitialSnapshot()
            dataSource.apply(snapshot, animatingDifferences: false)
            dataSource.defaultRowAnimation = .none
        }
    }
    
    var chatName: String {
        return chatManager.name
    }
    
    var lastIndexPath: IndexPath? {
        guard let lastSectionIndex = chatManager.lastSectionIndex,
              let lastMessageIndex = chatManager.lastMessageIndex
        else {
            return nil
        }
        return IndexPath(row: lastMessageIndex, section: lastSectionIndex)
    }
    
    init(chat: Chat, currentUser: User, dataManager: DataBaseManager) {
        self.currentUser = currentUser
        // This could also be injected instead of creating it here
        self.chatManager = ChatManager(chat: chat, currentUser: currentUser, dataManager: dataManager)
    }
    
    func isOwn(message: Message) -> Bool {
        return message.senderId == currentUser.id
    }
    
    func addMessage(_ messageContent: String, _ completion: (() -> Void)? = nil) {
        chatManager.addMessage(messageContent) { [weak self] snapshot in
            self?.dataSource.apply(snapshot, animatingDifferences: false, completion: completion)
            completion?()
        }
    }
    
    func titleForHeader(in section: Int) -> String? {
        guard chatManager.sectionHasHeader(at: section),
              let firstMessage = chatManager.firstMessage(inSectionAt: section) else { return nil }
        if Calendar.current.isDateInToday(firstMessage.timeStamp) {
            return "Today, " + firstMessage.timeStamp.formatted(date: .omitted, time: .shortened)
        } else {
            return firstMessage.timeStamp.formatted(date: .abbreviated, time: .shortened)
        }
    }
    
    func isCompactMessage(at indexPath: IndexPath) -> Bool {
        return chatManager.isShortTimeframeMessage(at: indexPath.row, indexPath.section)
    }
    
    func isLastSection(at indexPath: IndexPath) -> Bool {
        guard let message = chatManager.message(at: indexPath.row, indexPath.section) else { return false }
        return chatManager.lastSection == chatManager.section(for: message)
    }
    
    func isLastMessage(at indexPath: IndexPath) -> Bool {
        guard let message = chatManager.message(at: indexPath.row, indexPath.section) else { return false }
        return chatManager.lastMessage == message
    }
}
