//
//  DataBaseManager.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 16.04.2022.
//

import Foundation
import RealmSwift

class DataBaseManager {
    func save(_ chat: Chat) {
        let realm = try! Realm()
        try! realm.write {
            let dbChat = DBChat(chat: chat)
            realm.add(dbChat)
        }
    }
    
    func update(_ chat: Chat, with message: Message) {
        let realm = try! Realm()
        guard let dbChat = realm.objects(DBChat.self).where({ $0.id == chat.id }).first else { return }
        try! realm.write {
            dbChat.messages.append(DBMessage(message: message))
        }
    }
    
    func fetchChats() -> [Chat] {
        return (try! Realm().objects(DBChat.self)).map { Chat(dbChat: $0) }
    }
    
    func save(_ user: User) {
        let realm = try! Realm()
        try! realm.write {
            let dbUser = DBUser(user: user)
            realm.add(dbUser)
        }
    }
    
    func fetchUsers() -> [User] {
        return (try! Realm().objects(DBUser.self)).map { User(dbUser: $0) }
    }
}

fileprivate extension Chat {
    convenience init(dbChat: DBChat) {
        self.init(id: dbChat.id, messages: dbChat.messages.map { Message(dbMessage: $0) }, name: dbChat.name)
    }
}

fileprivate extension Message {
    init(dbMessage: DBMessage) {
        self.id = dbMessage.id
        self.content = dbMessage.content
        self.timeStamp = dbMessage.timeStamp
        self.senderId = dbMessage.senderId
    }
}

fileprivate extension User {
    init(dbUser: DBUser) {
        self.id = dbUser.id
        self.name = dbUser.name
    }
}
