//
//  MessageStoreManager.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 16.04.2022.
//

import Foundation
import RealmSwift

class MessageStoreManager {
    
    func save(_ chat: Chat) {
        let realm = try! Realm()
        try! realm.write {
            let dbChat = DBChat(chat: chat)
            realm.add(dbChat)
        }
    }
    
    func update(_ chat: Chat) {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id == %@", chat.id)
        guard let dbChat = realm.objects(DBChat.self).filter(predicate).first else { return }
        try! realm.write {
            dbChat.messages = chat.messages.map { DBMessage(message: $0) }
        }
    }
    
    func fetchChats() -> [Chat] {
        return (try! Realm().objects(DBChat.self)).map { Chat(dbChat: $0) }
    }
    
}

class DBChat: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var messages = [DBMessage]()
    
    init(chat: Chat) {
        self.id = chat.id
        self.name = chat.name
        self.messages = chat.messages.map { DBMessage(message: $0) }
    }
}

class DBMessage: Object {
    @objc dynamic var id = ""
    @objc dynamic var content = ""
    @objc dynamic var timeStamp = Date()
    @objc dynamic var sender: DBUser!
    
    init(message: Message) {
        self.id = message.id
        self.content = message.content
        self.timeStamp = message.timeStamp
        self.sender = DBUser(user: message.sender)
    }
}

class DBUser: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    
    init(user: User) {
        self.id = user.id
        self.name = user.name
    }
}

fileprivate extension Chat {
    convenience init(dbChat: DBChat) {
        self.init(messages: dbChat.messages.map { Message(dbMessage: $0) }, name: dbChat.name)
    }
}

fileprivate extension Message {
    init(dbMessage: DBMessage) {
        self.id = dbMessage.id
        self.content = dbMessage.content
        self.timeStamp = dbMessage.timeStamp
        self.sender = User(dbUser: dbMessage.sender)
    }
}

fileprivate extension User {
    init(dbUser: DBUser) {
        self.id = dbUser.id
        self.name = dbUser.name
    }
}
