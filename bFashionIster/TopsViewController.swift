//
//  TopsViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import RealmSwift

class TopsViewController: ArticleCollectionView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var subscription: NotificationToken?
    
    override var items: Results<Article>! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ArticleCell")
        
        items = getTops()
        subscription = notificationSubscription(for: items)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTops() -> Results<Article> {
        let realm = try! Realm()
        articles = realm.objects(Article.self)
        
        return articles.filter("articleType = %@", ArticleType.top.rawValue)
    }
    
    func notificationSubscription(for tops: Results<Article>) -> NotificationToken {
        return tops.addNotificationBlock({ [weak self] (changes: RealmCollectionChange<Results<Article>>) in
            // some results
            self?.updateUI(with: changes)
        })
    }
    
    func updateUI(with changes: RealmCollectionChange<Results<Article>>) {
        switch changes {
        case .initial(_):
            collectionView.reloadData()
        case let .update(_, deletions, insertions, modifications):
            
            collectionView.performBatchUpdates({
                self.collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                self.collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                self.collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                
            }, completion: { (completed: Bool) in
                // do any updates
            })
            
            break
        case let .error(error):
            print(error.localizedDescription)
        }
    }
}
