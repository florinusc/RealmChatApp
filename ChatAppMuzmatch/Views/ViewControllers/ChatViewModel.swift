//
//  ChatViewModel.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import Foundation

class ChatViewModel: ViewModel {
    private enum MessageHandler {
        case addToLastSection
        case createNewSection
        case createNewSectionWithHeader
    }
    
    private let chat: Chat
    private let currentUser: User
    private let dataManager: DataBaseManager
    
    var dataSource: ChatDataSource! {
        didSet {
            setUpDataSource()
        }
    }
    
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
    
    var chatName: String {
        return chat.name
    }
    
    private var snapshot = ChatSnapshot()
    
    init(chat: Chat, currentUser: User, dataManager: DataBaseManager) {
        self.chat = chat
        self.currentUser = currentUser
        self.dataManager = dataManager
    }
    
    func addMessage(_ messageContent: String, _ completion: (() -> Void)? = nil) {
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
        
        dataSource.apply(snapshot, animatingDifferences: false, completion: completion)
    }
    
    func section(for message: Message) -> MessageSection? {
        return snapshot.sectionIdentifier(containingItem: message)
    }
    
    func message(at indexPath: IndexPath) -> Message? {
        guard indexPath.section < snapshot.sectionIdentifiers.count else { return nil }
        let section = snapshot.sectionIdentifiers[indexPath.section]
        
        guard indexPath.row >= 0 && indexPath.row < section.messages.count else { return nil }
        return section.messages[indexPath.row]
    }
    
    func isOwn(message: Message) -> Bool {
        return message.senderId == currentUser.id
    }
    
    func isCompactMessage(at indexPath: IndexPath) -> Bool {
        guard let currentMessage = message(at: indexPath) else { return false }
        if let previousMessage = message(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) {
            let differenceInSeconds = Int(currentMessage.timeStamp.timeIntervalSince(previousMessage.timeStamp))
            return differenceInSeconds <= 20
        }
        return false
    }
    
    func titleForHeader(in section: Int) -> String? {
        let messageSections = snapshot.sectionIdentifiers
        let messageSection = messageSections[section]
        guard messageSection.hasHeader else { return nil }
        guard let firstMessage = messageSection.messages.first else { return nil }
        if Calendar.current.isDateInToday(firstMessage.timeStamp) {
            return "Today, " + firstMessage.timeStamp.formatted(date: .omitted, time: .shortened)
        } else {
            return firstMessage.timeStamp.formatted(date: .abbreviated, time: .shortened)
        }
    }
    
    private func setUpDataSource() {
        let messageSections = processMessages(messages: chat.messages)
        snapshot.appendSections(messageSections)
        for section in messageSections {
            snapshot.appendItems(section.messages, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
        dataSource.defaultRowAnimation = .none
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
