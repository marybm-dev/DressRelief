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
            let tops1 = Article(imgUrl: "", color: "blue", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops1.countLikes = 5
            let tops2 = Article(imgUrl: "", color: "red", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops2.countLikes = 7
            let tops3 = Article(imgUrl: "", color: "orange", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops3.countLikes = 524
            let tops4 = Article(imgUrl: "", color: "yellow", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops4.countLikes = 12
            let tops5 = Article(imgUrl: "", color: "blue", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops5.countLikes = 9
            let tops6 = Article(imgUrl: "", color: "purple", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops6.countLikes = 35
            let tops7 = Article(imgUrl: "", color: "red", texture: "denim", category: "business", type: ArticleType.top.rawValue)
            tops7.countLikes = 77
            
            realm.add(tops1)
            realm.add(tops2)
            realm.add(tops3)
            realm.add(tops4)
            realm.add(tops5)
            realm.add(tops6)
            realm.add(tops7)
            
            // Bottoms
            let bottoms1 = Article(imgUrl: "", color: "blue", texture: "denim", category: "business", type: ArticleType.bottom.rawValue)
            bottoms1.countLikes = 5
            let bottoms2 = Article(imgUrl: "", color: "red", texture: "denim", category: "business", type: ArticleType.bottom.rawValue)
            bottoms2.countLikes = 7
            let bottoms3 = Article(imgUrl: "", color: "orange", texture: "denim", category: "business", type: ArticleType.bottom.rawValue)
            bottoms3.countLikes = 524
            let bottoms4 = Article(imgUrl: "", color: "yellow", texture: "denim", category: "business", type: ArticleType.bottom.rawValue)
            bottoms4.countLikes = 12
            let bottoms5 = Article(imgUrl: "", color: "blue", texture: "denim", category: "business", type: ArticleType.bottom.rawValue)
            bottoms5.countLikes = 9
            let bottoms6 = Article(imgUrl: "", color: "purple", texture: "denim", category: "business", type: ArticleType.bottom.rawValue)
            bottoms6.countLikes = 35
            let bottoms7 = Article(imgUrl: "", color: "red", texture: "denim", category: "business", type: ArticleType.bottom.rawValue)
            bottoms7.countLikes = 77
            
            realm.add(bottoms1)
            realm.add(bottoms2)
            realm.add(bottoms3)
            realm.add(bottoms4)
            realm.add(bottoms5)
            realm.add(bottoms6)
            realm.add(bottoms7)
        }
    }
}