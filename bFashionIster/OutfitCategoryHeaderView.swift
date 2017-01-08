//
//  OutfitCategoryHeaderView.swift
//  bFashionIster
//
//  Created by Mary Martinez on 1/7/17.
//  Copyright © 2017 Mary Martinez. All rights reserved.
//

import UIKit

class OutfitCategoryHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    var category: String! {
        didSet {
            headerLabel.text = category
            let imageName = category.replacingOccurrences(of: " ", with: "").lowerFirstLetter()
            guard let image = UIImage(named: imageName) else { return }
            headerImageView.image = image
        }
    }
}
