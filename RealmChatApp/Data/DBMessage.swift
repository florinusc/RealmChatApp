//
//  DBMessage.swift
//  RealmChatApp
//
//  Created by Florin Uscatu on 16.04.2022.
//

import Foundation
import RealmSwift

class DBMessage: Object {
    @Persisted(primaryKey: true) var id = ""
    @Persisted var content = ""
    @Persisted var timeStamp = Date()
    @Persisted var senderId = ""
    
    convenience required init(message: Message) {
        self.init()
        self.id = message.id
        self.content = message.content
        self.timeStamp = message.timeStamp
        self.senderId = message.senderId
    }
}
