//
//  Clothes.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/17/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation
import RealmSwift

class Article: Object {
    dynamic var articleId = UUID().uuidString
    dynamic var created = Date()
    
    dynamic var articleType = ""
    dynamic var image: Data = Data()
    dynamic var color = ""
    dynamic var texture = ""
    dynamic var category = ""
    dynamic var countLikes = 0
    
    override class func primaryKey() -> String? {
        return "articleId"
    }
    
    convenience init(imgData: Data, color: String, texture: String, category: String, type: String) {
        self.init()
        
        self.image = imgData
        self.color = color
        self.texture = texture
        self.category = category
        self.articleType = type
    }
    
    static func all(ofArticleType articleType: String, byCategory category: String, withRealm realm: Realm) -> Results<Article>! {
        let result = realm.objects(Article.self)
        return result.filter("articleType = %@ AND category = %@", articleType, category)
    }
    
    static func all(ofArticleType articleType: String, withRealm realm: Realm) -> Results<Article>! {
        let result = realm.objects(Article.self)
        return result.filter("articleType = %@", articleType)
    }
    
    static func find(by id: String, withRealm realm: Realm) -> Results<Article>! {
        let result = realm.objects(Article.self)
        return result.filter("articleId = %@", id)
    }
}

enum ArticleType: String {
    case top, bottom
}

enum ArticleEntryPoint: String {
    case create, edit
}

enum ArticleSegue: String {
    case ToDetailFromTops
    case ToDetailFromBottoms
    case FromImageToCreateArticle
    case ToCameraCreateFromTops
    case ToCameraCreateFromBottoms
    case FromDetailToEditArticle
}
