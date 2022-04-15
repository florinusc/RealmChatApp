//
//  ChatViewModel.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import Foundation
import Combine

class ChatViewModel: ViewModel {
    
    @Published private var messageSections: [MessageSection]
    
    var dataSource: DataSource! {
        didSet {
            snapshot.appendSections(messageSections)
            for section in messageSections {
                snapshot.appendItems(section.messages, toSection: section)
            }
            dataSource.apply(snapshot, animatingDifferences: false)
            dataSource.defaultRowAnimation = .none
        }
    }
    
    var lastSection: MessageSection? {
        return snapshot.sectionIdentifiers.last
    }
    
    var lastMessage: Message? {
        return snapshot.sectionIdentifiers.last?.messages.last
    }
    
    var lastSectionIndex: Int {
        return snapshot.sectionIdentifiers.count - 1
    }
    
    var lastMessageIndex: Int {
        guard let lastSection = lastSection else {
            return 0
        }
        return lastSection.messages.count - 1
    }
    
    private let currentUser: User
    
    private var snapshot = Snapshot()
    
    init(currentUser: User = User(id: UUID().uuidString, name: "Me"), messages: [Message] = []) {
        self.currentUser = currentUser
        let otherUser = User(id: UUID().uuidString, name: "John")
        let section = MessageSection(id: UUID().uuidString, firstTimeStamp: Date().addingTimeInterval(TimeInterval(-35)), hasHeader: true, messages: [
            Message(id: UUID().uuidString,
                    sender: otherUser,
                    content: "Hey!",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-65))),
            Message(id: UUID().uuidString,
                    sender: otherUser,
                    content: "How are you?",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-30))),
            Message(id: UUID().uuidString,
                    sender: otherUser,
                    content: "I am getting off now",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-25))),
            Message(id: UUID().uuidString,
                    sender: otherUser,
                    content: "See you later",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-15)))
        ].sorted(by: { $0.timeStamp < $1.timeStamp }))
        self.messageSections = [section]
    }
    
    func addMessage(_ messageContent: String, _ completion: (() -> Void)? = nil) {
        
        let message = Message(id: UUID().uuidString,
                              sender: currentUser,
                              content: messageContent,
                              timeStamp: Date())
        
        var moreThanAnHourPassed: Bool {
            if let lastSection = lastSection,
               let lastTimeStamp = lastSection.messages.last?.timeStamp {
                let differenceInSeconds = Int(message.timeStamp.timeIntervalSince(lastTimeStamp))
                return differenceInSeconds > 3600
            }
            return true
        }
        
        if lastMessage?.sender == currentUser &&
            lastSection != nil &&
            !moreThanAnHourPassed {
            snapshot.appendItems([message], toSection: lastSection)
            lastSection?.messages.append(message)
        } else {
            let section = MessageSection(id: UUID().uuidString, firstTimeStamp: message.timeStamp, hasHeader: true, messages: [message])
            messageSections.append(section)
            snapshot.appendSections([section])
            snapshot.appendItems([message], toSection: section)
        }
        
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
        return message.sender == currentUser
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
        let messageSection = messageSections[section]
        guard let firstMessage = messageSection.messages.first else { return nil }
        if Calendar.current.isDateInToday(firstMessage.timeStamp) {
            return "Today, " + firstMessage.timeStamp.formatted(date: .omitted, time: .shortened)
        } else {
            return firstMessage.timeStamp.formatted(date: .abbreviated, time: .shortened)
        }
    }
    
}
