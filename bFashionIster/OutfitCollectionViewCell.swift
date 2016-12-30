//
//  OutfitCollectionViewCell.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/26/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class OutfitCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var outfitImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    var outfit: Outfit! {
        didSet {
            self.outfitImageView.image = Helper.image(atPath: outfit.combinedImgUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        closeButton.rounded()
    }

}
