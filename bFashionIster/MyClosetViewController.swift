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
import pop

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class MyClosetViewController: MeuItemViewController {
    
    var realm: Realm!
    var outfits: Results<Outfit>!
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        realm = try! Realm()
        outfits = realm.objects(Outfit.self)
        
        kolodaView.dataSource = self
        kolodaView.delegate = self

        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
//        kolodaView.clipsToBounds = true
//        kolodaView.layer.cornerRadius = 5
    }

    @IBAction func didTapDislikeButton(_ sender: Any) {
        kolodaView.swipe(SwipeResultDirection.left)
    }
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        kolodaView.swipe(SwipeResultDirection.right)
    }
}

//MARK: KolodaViewDelegate
extension MyClosetViewController: KolodaViewDelegate {
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}

// MARK: KolodaViewDataSource
extension MyClosetViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return outfits.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let outfit: Outfit = outfits[Int(index)]
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
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
