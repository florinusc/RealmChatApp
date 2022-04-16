//
//  DBChat.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 16.04.2022.
//

import Foundation
import RealmSwift

class DBChat: Object {
    @Persisted(primaryKey: true) var id = ""
    @Persisted var name = ""
    @Persisted var messages = List<DBMessage>()
    
    convenience required init(chat: Chat) {
        self.init()
        self.id = chat.id
        self.name = chat.name
        let list = List<DBMessage>.init()
        list.append(objectsIn: chat.messages.map { DBMessage(message: $0) })
        self.messages = list
    }
}
