//
//  AboutTableViewCell.swift
//  bFashionIster
//
//  Created by Mary Martinez on 1/4/17.
//  Copyright © 2017 Mary Martinez. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item: AboutItem! {
        didSet {
            self.itemLabel.text = item.title
            self.iconImageView.image = Helper.image(atPath: item.imageName.rawValue)
            self.descriptionLabel.text = item.description != nil ? item.description : ""
            
            if item.title == "Icons8" {
                self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        }
    }
}
