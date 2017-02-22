//
//  OutfitCollectionViewCell.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/26/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class OutfitCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var outfitImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var topsCategoryLabel: UILabel!
    @IBOutlet weak var bottomsCategoryLabel: UILabel!
    
    var outfit: Outfit! {
        didSet {
            
            topsCategoryLabel.text = " \((outfit.top?.category)!) "
            bottomsCategoryLabel.text = " \((outfit.bottom?.category)!) "
            topsCategoryLabel.backgroundColor = articleColor(for: outfit.top)
            bottomsCategoryLabel.backgroundColor = articleColor(for: outfit.bottom)
            topsCategoryLabel.textColor = .white
            bottomsCategoryLabel.textColor = .white
            
            let url = Helper.urlForBookmark(bookmark: outfit.combinedImage)
            guard let urlPath = url?.absoluteString else {
                return
            }
            
            let image = UIImage(contentsOfFile: urlPath)
            print(image)
            outfitImageView.image = image
            
            //let image = UIImage(data: outfit.combinedImage)
//            print(image)
//
//            let imageURL = Helper.urlForBookmark(bookmark: outfit.combinedImage)
//            print(imageURL)
//
//            outfitImageView.image = Helper.image(atPath: (imageURL?.absoluteString)!)
        }
    }
    
    var colors = [String: UIColor]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        closeButton.rounded()
        outfitImageView.clipsToBounds = true
        topsCategoryLabel.clipsToBounds = true
        bottomsCategoryLabel.clipsToBounds = true
        
        outfitImageView.layer.cornerRadius = 5
        topsCategoryLabel.layer.cornerRadius = 5
        bottomsCategoryLabel.layer.cornerRadius = 5
        
        colors = Category.colors()
    }

    func articleColor(for item: Article?) -> UIColor? {
        guard let item = item else {
            return nil
        }
        return colors[item.category]
    }
}
