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
            self.updateConstraints()
        }
    }

    override func updateConstraints() {
        if article.articleType == ArticleType.top.rawValue {
            topConstraint.constant = 25
            bottomConstraint.constant = 0
            self.articleImageView.round(corners: [.topLeft, .topRight], radius: 8)
            
            
        } else if article.articleType == ArticleType.bottom.rawValue {
            topConstraint.constant = 0
            bottomConstraint.constant = 25
            self.articleImageView.round(corners: [.bottomLeft, .bottomRight], radius: 8)
        }
        
        super.updateConstraints()
        self.layoutIfNeeded()
    }

}
