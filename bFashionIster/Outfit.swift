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
    dynamic var topImage = Data()
    dynamic var bottomImage = Data()
    dynamic var combinedImage = Data()
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
        self.topImage = top.image
        self.bottomImage = bottom.image
        self.category = top.category
        self.color = "\(top.color) + \(bottom.color)"
        self.texture = "\(top.texture) + \(bottom.texture)"
        self.setImagePath()
    }

    func setImagePath() {
        let imageResult = self.outfitImagePath()
        guard let path = imageResult.path,
            let url = URL(string: path) else {
            return
        }

        if let outfitImage = Helper.bookmarkForURL(url: url) {
            self.combinedImage = outfitImage
        }
    }

    static func outfitImage(top: UIImage, bottom: UIImage) -> UIImage? {
        let newSize = CGSize(width: top.size.width, height: top.size.height + bottom.size.height)
        
        UIGraphicsBeginImageContext(newSize)
        top.draw(in: CGRect(x: 0,
                            y: 0,
                        width: newSize.width,
                       height: top.size.height
                     )
                )
        bottom.draw(in: CGRect(x: 0,
                               y: top.size.height,
                           width: newSize.width,
                          height: bottom.size.height
                        )
                    )
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage
    }
    
    func outfitImagePath() -> OutfitImage {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let imagePathString = documentsPath.appending("/outfit-\(UUID().uuidString).jpg")
        print(imagePathString)
        
        let imagePath = URL(string: imagePathString)
        guard let path      = imagePath?.path,
            let top         = UIImage(data: self.topImage as Data),
            let bottom      = UIImage(data: self.bottomImage as Data),
            let outfit      = Outfit.outfitImage(top: top, bottom: bottom),
            let imageData   = UIImageJPEGRepresentation(outfit, 0.6) else {
                return OutfitImage(path: nil, data: nil)
        }
        
        do {
            try imageData.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch let error {
            print("outfit image path error")
            print(error)
        }
        
        return OutfitImage(path: path, data: imageData)
    }
}

enum OutfitSegue: String {
    case FromOutfitFavsToDetail
}

struct OutfitResult {
    var exists = false
    var outfit: Outfit?
    var top: Article? = nil
    var bottom: Article? = nil
}

struct OutfitImage {
    var path: String?
    var data: Data?
}
