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

    @IBOutlet weak var collectionView: UICollectionView!
    
    override var items: Results<Article>! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ArticleCell")
        
        items = getBottoms()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBottoms() -> Results<Article> {
        let realm = try! Realm()
        articles = realm.objects(Article.self)
        
        return articles.filter("articleType = %@", ArticleType.bottom.rawValue)
    }
}
