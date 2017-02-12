//
//  MyClosetViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import RealmSwift

class MyClosetViewController: MeuItemViewController {
    
    @IBOutlet weak var emptyImageView: UIImageView!
    
    var tops: Results<Article>!
    var bottoms: Results<Article>!
    
    var subscriptions = [NotificationToken]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tops = getTops()
        bottoms = getBottoms()
        
        let topsSubscription = notificationSubscription(for: tops)
        let bottomsSubscription = notificationSubscription(for: bottoms)
        subscriptions = [topsSubscription, bottomsSubscription]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.toggleHidden()
    }

    func toggleHidden() {
        emptyImageView.isHidden = (tops?.count == 0 || bottoms?.count == 0) ? false : true
    }
    
    func getTops() -> Results<Article> {
        let realm = try! Realm()
        let articles = realm.objects(Article.self)
        
        return articles.filter("articleType = %@", ArticleType.top.rawValue)
    }
    
    func getBottoms() -> Results<Article> {
        let realm = try! Realm()
        let articles = realm.objects(Article.self)
        
        return articles.filter("articleType = %@", ArticleType.bottom.rawValue)
    }
    
    // Mark: - Realm Subscription
    func notificationSubscription(for items: Results<Article>) -> NotificationToken {
        return items.addNotificationBlock({ [weak self] (changes: RealmCollectionChange<Results<Article>>) in
            self?.updateUI(with: changes)
        })
    }
    
    func updateUI(with changes: RealmCollectionChange<Results<Article>>) {
        // TODO: how do I update the imageViews in the listView?
    }
}
