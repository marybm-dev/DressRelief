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
    @IBOutlet weak var topsScrollView: UIScrollView!
    @IBOutlet weak var bottomsScrollView: UIScrollView!
    
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
        
        if let topsCount = tops?.count {
            if topsScrollView.subviews.count < topsCount {
                topsScrollView.viewWithTag(0)?.tag = 1000 //prevent confusion when looking up images
                setupListFor(tops, in: topsScrollView)
            }
        }
        
        if let bottomsCount = bottoms?.count {
            if bottomsScrollView.subviews.count < bottomsCount {
                bottomsScrollView.viewWithTag(0)?.tag = 1000 //prevent confusion when looking up images
                setupListFor(bottoms, in: bottomsScrollView)
            }
        }
        
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
    
    //add all images to the list
    func setupListFor(_ items: Results<Article>!, in listView: UIScrollView) {
        for i in items.indices {
            
            //create image view
            let imageView  = UIImageView(image: Helper.image(atPath: items[i].imgUrl))
            imageView.tag = i
            imageView.contentMode = .scaleToFill
            imageView.isUserInteractionEnabled = true
//            imageView.layer.cornerRadius = 15.0
            imageView.layer.masksToBounds = true
            listView.addSubview(imageView)
        }
        
        listView.backgroundColor = UIColor.clear
        position(items, in: listView)
    }
    

    //position all images inside the list
    func position(_ items: Results<Article>!, in listView: UIScrollView) {
        let listHeight = listView.frame.height
        let horizontalPadding: CGFloat = 10.0
        
        for i in items.indices {
            let imageView = listView.viewWithTag(i) as! UIImageView
            imageView.frame = CGRect(
                x: CGFloat(i) * listHeight + CGFloat(i+1) * horizontalPadding, y: 0.0,
                width: listHeight, height: listHeight)
        }
        
        listView.contentSize = CGSize(
            width: CGFloat(items.count) * (listHeight + horizontalPadding) + horizontalPadding,
            height:  0)
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
