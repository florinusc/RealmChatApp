//
//  ChatViewModel.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import Foundation
import Combine

class ChatViewModel {
    
    @Published var messages: [Message]
    
    var dataSource: DataSource! {
        didSet {
            snapshot.appendSections([.main])
            snapshot.appendItems(messages)
            dataSource.apply(snapshot, animatingDifferences: false)
            dataSource.defaultRowAnimation = .none
        }
    }
    var snapshot = Snapshot()
    
    init(messages: [Message] = []) {
        let otherUser = User(id: UUID().uuidString, name: "John")
        self.messages = [
            Message(id: UUID().uuidString,
                    sender: otherUser,
                    content: "Hey!",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-35))),
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
        ].sorted(by: { $0.timeStamp < $1.timeStamp })
    }
    
    func addMessage(_ messageContent: String, _ completion: (() -> Void)? = nil) {
        let ownUser = User(id: UUID().uuidString, name: "Me")
        let message = Message(id: UUID().uuidString, sender: ownUser, content: messageContent, timeStamp: Date())
        snapshot.insertItems([message], afterItem: messages.last!)
        messages.append(message)
        dataSource.apply(snapshot, animatingDifferences: true, completion: completion)
    }
    
}
