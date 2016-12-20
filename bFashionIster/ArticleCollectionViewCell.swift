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
            self.likedImageView.image = item.countLikes > 0 ? #imageLiteral(resourceName: "liked") : #imageLiteral(resourceName: "likedFilled")
            
            if FileManager.default.fileExists(atPath: item.imgUrl) {
                let url = NSURL(string: item.imgUrl)
                let data = NSData(contentsOf: url as! URL)
                self.itemImageView.image = UIImage(data: data! as Data)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
