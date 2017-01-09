//
//  OutfitCategoryHeaderView.swift
//  bFashionIster
//
//  Created by Mary Martinez on 1/7/17.
//  Copyright © 2017 Mary Martinez. All rights reserved.
//

import UIKit

class OutfitCategoryHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var color: UIColor!
    
    var category: String! {
        didSet {
            headerLabel.text = category
//            guard color != nil else { return }
//            headerLabel.textColor = color
        }
    }
}
