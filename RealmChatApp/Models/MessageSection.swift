//
//  MessageSection.swift
//  RealmChatApp
//
//  Created by Florin Uscatu on 15.04.2022.
//

import Foundation

class MessageSection {
    let id: String
    let firstTimeStamp: Date
    let hasHeader: Bool
    var messages: [Message]
    
    init(id: String, firstTimeStamp: Date, hasHeader: Bool, messages: [Message]) {
        self.id = id
        self.firstTimeStamp = firstTimeStamp
        self.hasHeader = hasHeader
        self.messages = messages
    }
}

extension MessageSection: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: MessageSection, rhs: MessageSection) -> Bool {
        return lhs.id == rhs.id
    }
}
