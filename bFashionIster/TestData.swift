//
//  TestData.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/19/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation
import RealmSwift

class TestData {
    
    static func defaults() {
        let realm = try! Realm()
        guard realm.isEmpty else { return }
        
        try! realm.write {
            // Tops
            let tops1 = Article(imgUrl: "top1.jpg", color: "blue", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops1.countLikes = 0
            let tops2 = Article(imgUrl: "top2.jpg", color: "red", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops2.countLikes = 2
            let tops3 = Article(imgUrl: "top3.jpg", color: "orange", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops3.countLikes = 524
            let tops4 = Article(imgUrl: "top4.jpg", color: "yellow", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops4.countLikes = 8
            let tops5 = Article(imgUrl: "top5.jpg", color: "green", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops5.countLikes = 8
            let tops6 = Article(imgUrl: "top6.jpg", color: "green", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops6.countLikes = 8
            realm.add(tops1)
            realm.add(tops2)
            realm.add(tops3)
            realm.add(tops4)
            realm.add(tops5)
            realm.add(tops6)
            
            // Bottoms
            let bottoms1 = Article(imgUrl: "bottoms1.jpg", color: "blue", texture: "denim", category: "business", type: ArticleType.bottom.rawValue)
            bottoms1.countLikes = 5
            let bottoms2 = Article(imgUrl: "bottoms2.jpg", color: "red", texture: "denim", category: "business", type: ArticleType.bottom.rawValue)
            bottoms2.countLikes = 7
            let bottoms3 = Article(imgUrl: "bottoms3.jpg", color: "orange", texture: "denim", category: "business", type: ArticleType.bottom.rawValue)
            bottoms3.countLikes = 524
            let bottoms4 = Article(imgUrl: "bottoms4.jpg", color: "yellow", texture: "denim", category: "business", type: ArticleType.bottom.rawValue)
            bottoms4.countLikes = 12
            let bottoms5 = Article(imgUrl: "bottoms5.jpg", color: "yellow", texture: "denim", category: "business", type: ArticleType.bottom.rawValue)
            bottoms5.countLikes = 12
            realm.add(bottoms1)
            realm.add(bottoms2)
            realm.add(bottoms3)
            realm.add(bottoms4)
            realm.add(bottoms5)
            
            let tops = [tops1, tops2, tops3, tops4, tops5, tops6]
            let bottoms = [bottoms1, bottoms2, bottoms3, bottoms4, bottoms5]
            
            let outfits = createOutfits(tops: tops, bottoms: bottoms)
            realm.add(outfits)
        }
    }
    
    static func createOutfits(tops: [Article], bottoms: [Article]) -> [Outfit] {
        var outfits = [Outfit]()
        for top in tops {
            for bottom in bottoms {
                let outfit = Outfit(topImgUrl: top.imgUrl, bottomImgUrl: bottom.imgUrl)
                outfits.append(outfit)
            }
        }
        return outfits
    }
}
