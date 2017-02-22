//
//  OutfitDetailViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/26/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class OutfitDetailViewController: PannableViewController {

    var outfit: Outfit!
    
    @IBOutlet weak var outfitImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.detailViewFrame = self.view.layer.frame
        guard outfit != nil else {
            return
        }
        outfitImageView.image = UIImage(data: outfit.combinedImage)
        categoryLabel.text = outfit.category
    }

    override var prefersStatusBarHidden: Bool {
        return true
    } 
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
