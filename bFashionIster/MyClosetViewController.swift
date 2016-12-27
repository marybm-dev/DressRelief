//
//  MyClosetViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import Koloda
import RealmSwift

class MyClosetViewController: MeuItemViewController, KolodaViewDataSource, KolodaViewDelegate {
    
    var realm: Realm!
    var outfits: Results<Outfit>!
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        realm = try! Realm()
        outfits = realm.objects(Outfit.self)
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        kolodaView.clipsToBounds = true
        kolodaView.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapDislikeButton(_ sender: Any) {
        kolodaView.swipe(SwipeResultDirection.left)
    }
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        kolodaView.swipe(SwipeResultDirection.right)
    }
    
    // Mark: Koloda
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return outfits.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let outfit: Outfit = outfits[Int(index)]
        outfit.setImagePath()
        let image = Helper.image(atPath: outfit.combinedImgUrl)
        return UIImageView(image: image)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        let outfit = outfits[index]
        
        try! realm.write {
            if direction == SwipeResultDirection.left {
                outfit.isLiked = false
            
            } else if direction == SwipeResultDirection.right {
                outfit.isLiked = true
            }
        }
    }
}
