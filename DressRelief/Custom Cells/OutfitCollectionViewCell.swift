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
            topsCategoryLabel.text = " \(outfit.topCategory) "
            bottomsCategoryLabel.text = " \(outfit.bottomCategory) "
            topsCategoryLabel.backgroundColor = articleColor(for: outfit.topCategory)
            bottomsCategoryLabel.backgroundColor = articleColor(for: outfit.bottomCategory)
            topsCategoryLabel.textColor = .white
            bottomsCategoryLabel.textColor = .white
            Helper.set(outfit: outfit, in: outfitImageView)
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

    func articleColor(for itemCategory: String) -> UIColor? {
       return colors[itemCategory]
    }
}
