//
//  DBUser.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 16.04.2022.
//

import Foundation
import RealmSwift

class DBUser: Object {
    @Persisted(primaryKey: true) dynamic var id = ""
    @Persisted dynamic var name = ""
    
    convenience required init(user: User) {
        self.init()
        self.id = user.id
        self.name = user.name
    }
}
