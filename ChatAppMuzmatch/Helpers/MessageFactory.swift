//
//  MessageFactory.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 15.04.2022.
//

import Foundation

class MessageFactory {
    
    var chat: Chat {
        return Chat(messages: generateMessage(), name: "chat 1")
    }
    
    lazy var currentUser: User = {
        return User(name: "Me")
    }()
    
    func generateMessage() -> [Message] {
        let john = User(name: "John")
        return [
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "Hey!",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-65))),
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "How are you?",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-30))),
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "I am getting off now",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-25))),
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "See you later",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-15))),
            Message(id: UUID().uuidString,
                    sender: currentUser,
                    content: "Hey!",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-3005))),
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "How are you?",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-233))),
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "I am getting off now",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-4500))),
            Message(id: UUID().uuidString,
                    sender: currentUser,
                    content: "See you later",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-10))),
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "Hey!",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-6599))),
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "How are you?",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-30000))),
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "I am getting off now",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-235))),
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "See you later",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-152))),
            Message(id: UUID().uuidString,
                    sender: currentUser,
                    content: "Hey!",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-65292))),
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "How are you?",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-3022))),
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "I am getting off now",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-225))),
            Message(id: UUID().uuidString,
                    sender: john,
                    content: "See you later",
                    timeStamp: Date().addingTimeInterval(TimeInterval(-1501)))
        ]
        
    }
    
}
