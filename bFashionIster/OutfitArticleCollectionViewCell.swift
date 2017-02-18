//
//  OutfitArticleCollectionViewCell.swift
//  
//
//  Created by Mary Martinez on 2/18/17.
//
//

import UIKit

class OutfitArticleCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var article: Article! {
        didSet {
            self.articleImageView.image = Helper.image(atPath: article.imgUrl)
            self.updateConstraint()
        }
    }
    
    func updateConstraint() {
        if article.articleType == ArticleType.top.rawValue {
            topConstraint.constant = 25
            bottomConstraint.constant = 0
            
        } else if article.articleType == ArticleType.bottom.rawValue {
            topConstraint.constant = 0
            bottomConstraint.constant = 25
        }
    }

}
