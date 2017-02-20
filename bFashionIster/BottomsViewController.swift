//
//  BottomsViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import RealmSwift

class BottomsViewController: ArticleCollectionView {

    override var items: Results<Article>! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = getBottoms()
        toggleHidden()
        subscription = notificationSubscription(for: items)
    }

    func getBottoms() -> Results<Article> {
        let realm = try! Realm()
        articles = realm.objects(Article.self)
        
        return articles.filter("articleType = %@", ArticleType.bottom.rawValue)
    }

    override func updateUI(with changes: RealmCollectionChange<Results<Article>>) {
        switch changes {
        case .initial(_):
            collectionView.reloadData()
        case let .update(_, deletions, insertions, modifications):
            
            collectionView.performBatchUpdates({
                self.collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                self.collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                self.collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                
            }, completion: { (completed: Bool) in
                self.collectionView.reloadData()
            })
            
            break
        case let .error(error):
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ArticleSegue.ToCameraCreateFromBottoms.rawValue {
            let cameraNavigationController = segue.destination as! UINavigationController
            let cameraViewController = cameraNavigationController.topViewController as? CameraViewController
            cameraViewController?.articleType = ArticleType.bottom.rawValue
        
        } else if segue.identifier == ArticleSegue.ToDetailFromBottoms.rawValue {
            let detailNavigationController = segue.destination as! UINavigationController
            let detailViewController = detailNavigationController.topViewController as? ArticleDetailViewController
            detailViewController?.article = self.selectedItem
        }
    }
}
