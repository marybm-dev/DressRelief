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
    
    var item: Article! {
        didSet {
            likesCountLabel.text = "\(item.countLikes)"
            self.likedImageView.image = item.countLikes > 0 ? #imageLiteral(resourceName: "likedFilled") : #imageLiteral(resourceName: "liked")
            
            if FileManager.default.fileExists(atPath: item.imgUrl) {
                let imageURL = URL(fileURLWithPath: item.imgUrl)
                self.itemImageView.image = UIImage(contentsOfFile: imageURL.path)
                
            } else {
                
                if item.articleType == ArticleType.top.rawValue {
                    itemImageView.image = #imageLiteral(resourceName: "topsBar")
                    
                } else {
                    itemImageView.image = #imageLiteral(resourceName: "bottomsBar")
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

