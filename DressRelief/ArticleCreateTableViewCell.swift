//
//  CategoryTableViewCell.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/20/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class ArticleCreateTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
