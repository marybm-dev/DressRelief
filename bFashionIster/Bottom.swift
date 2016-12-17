//
//  Bottom.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/17/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation
import RealmSwift

class Bottom: Object {
    
    dynamic var bottomId = UUID().uuidString
    dynamic var created = Date()
    
    dynamic var imgUrl = ""
    dynamic var color = ""
    dynamic var texture = ""
    dynamic var category = ""
    dynamic var countLikes = 0
    dynamic var tags: [String] = []
    
    override class func primaryKey() -> String? {
        return "bottomId"
    }
    
    convenience init(imgUrl: String, color: String, texture: String, category: String, tags: [String]) {
        self.init()
        
        self.imgUrl = imgUrl
        self.color = color
        self.texture = texture
        self.category = category
        self.tags = tags
    }
}
