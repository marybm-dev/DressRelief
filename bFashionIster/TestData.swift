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
            let tops2 = Article(imgUrl: "top2.jpg", color: "Cool", texture: "Glossy", category: "Sportsware", type: ArticleType.top.rawValue)
            tops2.countLikes = 32
            let tops3 = Article(imgUrl: "top3.jpg", color: "B&W", texture: "Cotton", category: "Casual", type: ArticleType.top.rawValue)
            tops3.countLikes = 524
            let tops4 = Article(imgUrl: "top4.jpg", color: "Pattern", texture: "Linen", category: "Professional", type: ArticleType.top.rawValue)
            tops4.countLikes = 0
            let tops5 = Article(imgUrl: "top5.jpg", color: "Multi", texture: "Knit", category: "Dressy Casual", type: ArticleType.top.rawValue)
            tops5.countLikes = 8
            let tops6 = Article(imgUrl: "top6.jpg", color: "B&W", texture: "Cotton", category: "Casual", type: ArticleType.top.rawValue)
            tops6.countLikes = 0
            realm.add(tops2)
            realm.add(tops3)
            realm.add(tops4)
            realm.add(tops5)
            realm.add(tops6)
            
            // Bottoms
            let bottoms1 = Article(imgUrl: "bottoms1.jpg", color: "Warm", texture: "Denim", category: "Dressy Casual", type: ArticleType.bottom.rawValue)
            bottoms1.countLikes = 5
            let bottoms2 = Article(imgUrl: "bottoms2.jpg", color: "Cool", texture: "Denim", category: "Casual", type: ArticleType.bottom.rawValue)
            bottoms2.countLikes = 7
            let bottoms3 = Article(imgUrl: "bottoms3.jpg", color: "Neutral", texture: "Denim", category: "Sportsware", type: ArticleType.bottom.rawValue)
            bottoms3.countLikes = 524
            let bottoms4 = Article(imgUrl: "bottoms4.jpg", color: "B&W", texture: "Linen", category: "Professional", type: ArticleType.bottom.rawValue)
            bottoms4.countLikes = 12
            realm.add(bottoms1)
            realm.add(bottoms2)
            realm.add(bottoms3)
            realm.add(bottoms4)
            
//            let tops = [tops2, tops3, tops4, tops5, tops6]
//            let bottoms = [bottoms1, bottoms2, bottoms3, bottoms4]
//            let outfits = createAllOutfitCombinations(tops: tops, bottoms: bottoms)
            let result = matchedOutfits(with: realm)
            guard let outfits = result else { return }
            realm.add(outfits)
        }
    }
    
    static func createAllOutfitCombinations(tops: [Article], bottoms: [Article]) -> [Outfit] {
        var outfits = [Outfit]()
        for top in tops {
            for bottom in bottoms {
                let outfit = Outfit(top: top, bottom: bottom)
                outfits.append(outfit)
            }
        }
        return outfits
    }
    
    static func matchedOutfits(with realm: Realm) -> [Outfit]? {
        var outfits = [Outfit]()
        for category in Category.allValues {
            let t = Article.all(articleType: ArticleType.top.rawValue, by: category, with: realm)
            let b = Article.all(articleType: ArticleType.bottom.rawValue, by: category, with: realm)
            
            guard let tops = t else { return nil }
            guard let bottoms = b else { return nil }
            
            for top in tops {
                for bottom in bottoms {
                    let outfit = Outfit(top: top, bottom: bottom)
                    outfits.append(outfit)
                }
            }
        }
        return outfits
    }
}
