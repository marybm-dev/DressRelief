//
//  TopsViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import RealmSwift

class TopsViewController: MeuItemViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
//    var tops: Results<Article>!
    var tops = [Article]()
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ArticleCell")
        
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
        
        tops.append(tops1)
        tops.append(tops2)
        tops.append(tops3)
        tops.append(tops4)
        tops.append(tops5)
        tops.append(tops6)
        tops.append(tops7)
        
//        let realm = try! Realm()
//        tops = realm.objects(Article.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: – UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCollectionViewCell
        
        cell.item = tops[indexPath.row]
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    // Mark: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        let availableHeight = view.frame.height - paddingSpace - 64.0 // navBar space
        let heightPerItem = availableHeight / itemsPerRow
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
