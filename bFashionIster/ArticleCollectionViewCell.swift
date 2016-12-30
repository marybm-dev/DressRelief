//
//  ClothesCollectionViewCell.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/17/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var likedImageView: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var item: Article! {
        didSet {
            likesCountLabel.text = "\(item.countLikes)"
            self.likedImageView.image = item.countLikes > 0 ? #imageLiteral(resourceName: "likedFilled") : #imageLiteral(resourceName: "liked")
            Helper.set(article: item, in: itemImageView)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        closeButton.rounded()
    }
}

