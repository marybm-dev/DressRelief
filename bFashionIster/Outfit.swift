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
    dynamic var topCategory = ""
    dynamic var bottomCategory = ""
    dynamic var topColor = ""
    dynamic var bottomColor = ""
    dynamic var topTexture = ""
    dynamic var bottomTexture = ""

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
        self.topCategory = top.category
        self.bottomCategory = bottom.category
        self.topColor = top.color
        self.bottomColor = bottom.color
        self.topTexture = top.texture
        self.bottomTexture = bottom.texture
        self.setImagePath()
    }

    func setImagePath() {
        let imageResult = self.outfitImagePath()
        guard let path = imageResult.path else {
            return
        }

        if let outfitImage = Helper.bookmarkForURL(url: path) {
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
        let filename = "outfit-\(UUID().uuidString).jpg"
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let finalDir = docsURL.appendingPathComponent(filename)

        guard let top       = Helper.image(from: self.topImage),
            let bottom      = Helper.image(from: self.bottomImage),
            let outfit      = Outfit.outfitImage(top: top, bottom: bottom),
            let imageData   = UIImageJPEGRepresentation(outfit, 0.6) else {
                return OutfitImage(path: nil, data: nil)
        }
        
        do {
            try imageData.write(to: URL(fileURLWithPath: finalDir.path), options: .atomic)
        } catch let error {
            print("outfit image path error")
            print(error)
        }
        
        return OutfitImage(path: finalDir, data: imageData)
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
    var path: URL?
    var data: Data?
}
