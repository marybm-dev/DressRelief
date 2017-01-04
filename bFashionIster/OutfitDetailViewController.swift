//
//  OutfitDetailViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/26/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class OutfitDetailViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var outfit: Outfit!
    
    @IBOutlet weak var outfitImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard outfit != nil else {
            return
        }
        
        outfitImageView.image = Helper.image(atPath: outfit.combinedImgUrl)
        categoryLabel.text = outfit.category
        
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    } 
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
