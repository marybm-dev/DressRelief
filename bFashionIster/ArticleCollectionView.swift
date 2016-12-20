//
//  ArticleCollectionView.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/19/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import RealmSwift

class ArticleCollectionView: MeuItemViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var articles: Results<Article>!
    var items: Results<Article>!
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Mark: – UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCollectionViewCell
        
        cell.item = items[indexPath.row]
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
