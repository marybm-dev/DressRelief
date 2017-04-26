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
    @IBOutlet weak var topCategoryLabel: UILabel!
    @IBOutlet weak var topColorLabel: UILabel!
    @IBOutlet weak var topTextureLabel: UILabel!
    @IBOutlet weak var bottomCategoryLabel: UILabel!
    @IBOutlet weak var bottomColorLabel: UILabel!
    @IBOutlet weak var bottomTextureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.detailViewFrame = self.view.layer.frame
        guard outfit != nil else {
            return
        }
        
        outfitImageView.clipsToBounds = true
        outfitImageView.layer.cornerRadius = 5
        outfitImageView.image = Helper.image(from: outfit.combinedImage)
        topCategoryLabel.text = outfit.topCategory
        topColorLabel.text = outfit.topColor
        topTextureLabel.text = outfit.topTexture
        bottomColorLabel.text = outfit.bottomCategory
        bottomColorLabel.text = outfit.bottomColor
        bottomTextureLabel.text = outfit.bottomTexture
    }

    override var prefersStatusBarHidden: Bool {
        return true
    } 
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
