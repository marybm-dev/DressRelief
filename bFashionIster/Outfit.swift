//
//  Outfit.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/17/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation
import RealmSwift

class Outfit: Object {
    
    dynamic var outfitId = NSUUID().uuidString
    dynamic var created = Date()
    
    dynamic var isLiked = false
    dynamic var isDisliked = false
    
    dynamic var topImgUrl = ""
    dynamic var bottomImgUrl = ""
    dynamic var combinedImgUrl = ""
    
//    dynamic var tags: [String] = []
    
    override class func primaryKey() -> String? {
        return "outfitId"
    }
    
    override class func indexedProperties() -> [String] {
        return ["isLiked", "isDisliked"]
    }
    
    convenience init(topImgUrl: String, bottomImgUrl: String, combinedImgUrl: String) {
        self.init()
        
        self.topImgUrl = topImgUrl
        self.bottomImgUrl = bottomImgUrl
        self.combinedImgUrl = combinedImgUrl
//        self.tags = tags
    }
}
