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
    
    dynamic var topImgUrl = ""
    dynamic var bottomImgUrl = ""
    dynamic var combinedImgUrl = ""
    
    dynamic var category = ""
    dynamic var color = ""
    dynamic var texture = ""

    override class func primaryKey() -> String? {
        return "outfitId"
    }
    
    override class func indexedProperties() -> [String] {
        return ["isLiked"]
    }
    
    convenience init(top: Article, bottom: Article) {
        self.init()
        
        self.topImgUrl = top.imgUrl
        self.bottomImgUrl = bottom.imgUrl
        
        self.category = top.category
        self.color = "\(top.color) + \(bottom.color)"
        self.texture = "\(top.texture) + \(bottom.texture)"
    }
    
    func setImagePath() {
        if self.combinedImgUrl.isEmpty {
            let realm = try! Realm()
            try! realm.write {
                self.combinedImgUrl = self.outfitImagePath()
            }
        }
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
    
    func outfitImagePath() -> String {
        let imagePath = Helper.fileDirectory.appendingPathComponent("Images/Outfit-\(UUID().uuidString).jpg")
        guard imagePath?.path != nil else { return "" }
        
        var topImage = Helper.image(atPath: self.topImgUrl)
        var bottomImage = Helper.image(atPath: self.bottomImgUrl)
        
        guard topImage != nil else { return "" }
        guard bottomImage != nil else { return "" }
        
        var outfitImage = Outfit.outfitImage(top: topImage!, bottom: bottomImage!)
        guard let imageData = UIImageJPEGRepresentation(outfitImage!, 0.6) else { return "" }

        do {
            try imageData.write(to: URL(fileURLWithPath: (imagePath?.path)!), options: .atomic)
        } catch let error {
            print(error)
        }

        // deallocate images
        topImage = nil
        bottomImage = nil
        outfitImage = nil
        
        return (imagePath?.path)!
    }
}

enum OutfitSegue: String {
    case FromOutfitFavsToDetail
}
