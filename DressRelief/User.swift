//
//  User.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/17/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    dynamic var userId = UUID().uuidString
    dynamic var created = Date()
    
    dynamic var name = ""
    dynamic var email = ""
    dynamic var password = ""
    dynamic var avatarUrl: String? = nil
    
    override class func primaryKey() -> String? {
        return "userId"
    }
    
    override class func indexedProperties() -> [String] {
        return ["email"]
    }
    
    convenience init(name: String, email: String, password: String, avatarUrl: String?) {
        self.init()
        
        self.name = name
        self.email = email
        self.password = password
        self.avatarUrl = avatarUrl
    }
}
