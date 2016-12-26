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
    }
    
    static func outfitImage(top: UIImage, bottom: UIImage) -> UIImage? {
        let newSize = CGSize(width: top.size.width, height: top.size.height + bottom.size.height)
        
        UIGraphicsBeginImageContext(newSize)
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        top.draw(in: newRect)
        bottom.draw(in: CGRect(x: 0, y: top.size.height, width: newRect.width, height: bottom.size.height))
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage
    }
}
