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
    @IBOutlet weak var topsCollectionView: UICollectionView!
    @IBOutlet weak var bottomsCollectionView: UICollectionView!
    
    var tops: Results<Article>! {
        didSet {
            topsCollectionView.reloadData()
            print("tops: \(tops.count)")
        }
    }
    
    var bottoms: Results<Article>! {
        didSet {
            bottomsCollectionView.reloadData()
            print("bottoms: \(bottoms.count)")
        }
    }
    
    var subscriptions = [NotificationToken]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tops = getTops()
        bottoms = getBottoms()
        
        let topsSubscription = notificationSubscription(for: tops)
        let bottomsSubscription = notificationSubscription(for: bottoms)
        subscriptions = [topsSubscription, bottomsSubscription]

        let nib = UINib(nibName: "OutfitArticleCollectionViewCell", bundle: nil)
        topsCollectionView.register(nib, forCellWithReuseIdentifier: "OutfitTopCell")
        bottomsCollectionView.register(nib, forCellWithReuseIdentifier: "OutfitBottomCell")
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

extension MyClosetViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topsCollectionView {
            return tops?.count ?? 0
            
        } else {
            return bottoms?.count ?? 0
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == topsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutfitTopCell", for: indexPath) as! OutfitArticleCollectionViewCell
            
            let top = tops[indexPath.row]
            cell.article = top
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutfitBottomCell", for: indexPath) as! OutfitArticleCollectionViewCell
            
            let bottom = bottoms[indexPath.row]
            cell.article = bottom
            
            return cell
            
        }
        
    }
    
}
