//
//  ArticleDetailViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/22/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UITableViewController {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var textureLabel: UILabel!

    var article: Article! {
        didSet {
            self.categoryLabel.text = article.category
            self.colorLabel.text = article.color
            self.textureLabel.text = article.texture
            
            if FileManager.default.fileExists(atPath: article.imgUrl) {
                let imageURL = URL(fileURLWithPath: article.imgUrl)
                self.articleImageView.image = UIImage(contentsOfFile: imageURL.path)
                
            } else {
                
                if article.articleType == ArticleType.top.rawValue {
                    articleImageView.image = #imageLiteral(resourceName: "topsBar")
                    
                } else {
                    articleImageView.image = #imageLiteral(resourceName: "bottomsBar")
                }
            }
            
        }
    }
}
