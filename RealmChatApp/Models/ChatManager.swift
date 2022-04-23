//
//  ChatManager.swift
//  RealmChatApp
//
//  Created by Florin Uscatu on 18.04.2022.
//

import Foundation

class ChatManager {
    private enum MessageHandler {
        case addToLastSection
        case createNewSection
        case createNewSectionWithHeader
    }
    
    private let chat: Chat
    private let currentUser: User
    private let dataManager: DataBaseManager
    
    var lastSection: MessageSection? {
        return snapshot.sectionIdentifiers.last
    }
    
    var lastMessage: Message? {
        return snapshot.sectionIdentifiers.last?.messages.last
    }
    
    var lastSectionIndex: Int? {
        if snapshot.sectionIdentifiers.count > 0 {
            return snapshot.sectionIdentifiers.count - 1
        } else {
            return nil
        }
    }
    
    var lastMessageIndex: Int? {
        guard let lastSection = lastSection else {
            return nil
        }
        guard lastSection.messages.count > 0 else { return nil }
        return lastSection.messages.count - 1
    }
    
    var name: String {
        return chat.name
    }
    
    private var snapshot = ChatSnapshot()
    
    init(chat: Chat, currentUser: User, dataManager: DataBaseManager) {
        self.chat = chat
        self.currentUser = currentUser
        self.dataManager = dataManager
    }
    
    func addMessage(_ messageContent: String, _ completion: ((ChatSnapshot) -> Void)? = nil) {
        let message = Message(id: UUID().uuidString,
                              senderId: currentUser.id,
                              content: messageContent,
                              timeStamp: Date())
        let messageHandler = handleMessage(message: message, lastSection: lastSection)
        switch messageHandler {
        case .addToLastSection:
            snapshot.appendItems([message], toSection: lastSection)
            lastSection?.messages.append(message)
        case .createNewSection:
            addNewSection(message: message, hasHeader: false)
        case .createNewSectionWithHeader:
            addNewSection(message: message)
        }
        chat.addMessage(message: message)
        try? dataManager.update(chat, with: message)
        completion?(snapshot)
    }
    
    func section(for message: Message) -> MessageSection? {
        return snapshot.sectionIdentifier(containingItem: message)
    }
    
    func section(at index: Int) -> MessageSection {
        let messageSections = snapshot.sectionIdentifiers
        return messageSections[index]
    }
    
    func firstMessage(inSectionAt index: Int) -> Message? {
        let messageSection = section(at: index)
        return messageSection.messages.first
    }
    
    func sectionHasHeader(at index: Int) -> Bool {
        let messageSections = snapshot.sectionIdentifiers
        let messageSection = messageSections[index]
        return messageSection.hasHeader
    }
    
    func isShortTimeframeMessage(at messageIndex: Int, _ sectionIndex: Int) -> Bool {
        guard let currentMessage = message(at: messageIndex, sectionIndex) else { return false }
        if let previousMessage = message(at: messageIndex - 1, sectionIndex) {
            let differenceInSeconds = Int(currentMessage.timeStamp.timeIntervalSince(previousMessage.timeStamp))
            return differenceInSeconds <= 20
        }
        return false
    }
    
    func createInitialSnapshot() -> ChatSnapshot {
        let messageSections = processMessages(messages: chat.messages)
        snapshot.appendSections(messageSections)
        for section in messageSections {
            snapshot.appendItems(section.messages, toSection: section)
        }
        return snapshot
    }
    
    func message(at messageIndex: Int, _ sectionIndex: Int) -> Message? {
        guard sectionIndex < snapshot.sectionIdentifiers.count else { return nil }
        let section = snapshot.sectionIdentifiers[sectionIndex]
        
        guard messageIndex >= 0 && messageIndex < section.messages.count else { return nil }
        return section.messages[messageIndex]
    }
    
    private func processMessages(messages: [Message]) -> [MessageSection] {
        let sortedMessages = messages.sorted(by: { $0.timeStamp < $1.timeStamp })
        var sections = [MessageSection]()
        for message in sortedMessages {
            let messageHandler = handleMessage(message: message, lastSection: sections.last)
            switch messageHandler {
            case .addToLastSection:
                sections.last?.messages.append(message)
            case .createNewSection:
                let section = createNewSection(with: message, hasHeader: false)
                sections.append(section)
            case .createNewSectionWithHeader:
                let section = createNewSection(with: message)
                sections.append(section)
            }
        }
        return sections
    }
    
    private func handleMessage(message: Message, lastSection: MessageSection?) -> MessageHandler {
        if let lastSection = lastSection, let lastMessage = lastSection.messages.last {
            let moreThanAnHourPassed = checkIfAnHourPassed(lastSection: lastSection, message: message)
            if moreThanAnHourPassed {
                return .createNewSectionWithHeader
            } else if lastMessage.senderId != message.senderId {
                return .createNewSection
            } else {
                return .addToLastSection
            }
        } else {
            return .createNewSectionWithHeader
        }
    }
    
    private func createNewSection(with message: Message, hasHeader: Bool = true) -> MessageSection {
        let section = MessageSection(id: UUID().uuidString, firstTimeStamp: message.timeStamp, hasHeader: hasHeader, messages: [message])
        return section
    }
    
    private func addNewSection(message: Message, hasHeader: Bool = true) {
        let section = createNewSection(with: message, hasHeader: hasHeader)
        snapshot.appendSections([section])
        snapshot.appendItems([message], toSection: section)
    }
    
    private func checkIfAnHourPassed(lastSection: MessageSection?, message: Message) -> Bool {
        if let lastSection = lastSection,
           let lastTimeStamp = lastSection.messages.last?.timeStamp {
            let differenceInSeconds = Int(message.timeStamp.timeIntervalSince(lastTimeStamp))
            return differenceInSeconds > 3600
        }
        return true
    }
}
