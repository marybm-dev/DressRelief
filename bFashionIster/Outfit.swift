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
    
    dynamic var top: Article?
    dynamic var bottom: Article?
    
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
        
        self.top = top
        self.bottom = bottom
        
        self.topImgUrl = top.imgUrl
        self.bottomImgUrl = bottom.imgUrl
        
        self.category = top.category
        self.color = "\(top.color) + \(bottom.color)"
        self.texture = "\(top.texture) + \(bottom.texture)"
        
        self.setImagePathInBackground { (imagePath) in
            guard let imagePath = imagePath else { return }
            let realm = try! Realm()
            try! realm.write {
                self.combinedImgUrl = imagePath
            }
        }
    }

    func setImagePath() {
        if self.combinedImgUrl.isEmpty {
            let realm = try! Realm()
            try! realm.write {
                self.combinedImgUrl = self.outfitImagePath()
            }
        }
    }
    
    func setImagePathInBackground(completion: @escaping (String?)->()) {
        if self.combinedImgUrl.isEmpty {
            let objectId = self.outfitId
            DispatchQueue.global(qos: .userInitiated).async {
                let realm = try! Realm()
                let current = realm.object(ofType: Outfit.self, forPrimaryKey: objectId)
                guard let imagePath = current?.outfitImagePath() else {
                    completion(nil)
                    return
                }
                DispatchQueue.main.async {
                    completion(imagePath)
                }
            }
        }
        completion(nil)
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
        
        guard let path      = imagePath?.path,
            let top         = Helper.image(atPath: self.topImgUrl),
            let bottom      = Helper.image(atPath: self.bottomImgUrl),
            let outfit      = Outfit.outfitImage(top: top, bottom: bottom),
            let imageData   = UIImageJPEGRepresentation(outfit, 0.6) else {
                return ""
        }
        
        do {
            try imageData.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch let error {
            print(error)
        }

        return path
    }
}

enum OutfitSegue: String {
    case FromOutfitFavsToDetail
}
