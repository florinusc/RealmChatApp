//
//  Chat.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 16.04.2022.
//

import Foundation

class Chat {
    let id: String
    let name: String
    var messages: [Message]
    
    init(messages: [Message], name: String) {
        self.id = UUID().uuidString
        self.messages = messages
        self.name = name
    }
    
    init(id: String, messages: [Message], name: String) {
        self.id = id
        self.messages = messages
        self.name = name
    }
    
    func addMessage(message: Message) {
        messages.append(message)
    }
}

extension Chat: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }
}
