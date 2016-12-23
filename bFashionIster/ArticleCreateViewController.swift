//
//  ArticleCreateViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/20/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import RealmSwift

class ArticleCreateViewController: ArticleEditViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var articleImagePath: String!
    var articleType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didTapSaveButton() {
        // 1. validate we have all data
        guard articleImagePath != nil else {
            Helper.displayAlert(with: "Image path is broken", in: self)
            return
        }
        guard articleType != nil else {
            Helper.displayAlert(with: "Missing articleType parameter", in: self)
            return
        }
        guard selectedCategory != Category.display.description else {
            shakeCells(at: IndexPath(row: 0, section: 1))
            return
        }
        guard selectedColor != Color.display.description else {
            shakeCells(at: IndexPath(row: 0, section: 2))
            return
        }
        guard selectedTexture != Texture.display.description else {
            shakeCells(at: IndexPath(row: 0, section: 3))
            return
        }
        
        // 2. save to Realm
        let article = Article(imgUrl: articleImagePath, color: selectedColor, texture: selectedTexture, category: selectedCategory, type: articleType)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(article)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func shakeCells(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.shake()
    }
    
}
