//
//  OutfitDetailViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/26/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class OutfitDetailViewController: UIViewController {

    var outfit: Outfit!
    
    @IBOutlet weak var outfitImageView: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var textureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard outfit != nil else {
            return
        }
        
        outfitImageView.image = Helper.image(atPath: outfit.combinedImgUrl)
        categoryImageView.image = Helper.image(atPath: "category")
        categoryLabel.text = outfit.category
        colorLabel.text = "Color: \(outfit.color)"
        textureLabel.text = "Texture: \(outfit.texture)"
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(OutfitDetailViewController.handleSwipe))
        self.view.addGestureRecognizer(gesture)
    }
    
    func handleSwipe() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
