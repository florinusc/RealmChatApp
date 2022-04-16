//
//  User.swift
//  ChatAppMuzmatch
//
//  Created by Florin Uscatu on 12.04.2022.
//

import Foundation

struct User {
    let id: String
    let name: String
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
}

extension User: Hashable {}
