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
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class MyClosetViewController: MeuItemViewController {
    
    var realm: Realm!
    var outfits: Results<Outfit>!
    var allOutfits: Results<Outfit>!

    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        outfits = getUnfavoritedOutfits()
        allOutfits = outfits

        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshArrays()
    }
    
    @IBAction func didTapDislikeButton(_ sender: Any) {
        kolodaView.swipe(SwipeResultDirection.left)
    }
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        kolodaView.swipe(SwipeResultDirection.right)
    }
    
    func getUnfavoritedOutfits() -> Results<Outfit> {
        allOutfits = realm.objects(Outfit.self)
        return allOutfits.filter("isLiked = false")
    }
    
    func refreshArrays() {
        guard realm != nil else { return }
        realm.refresh()
        outfits = getUnfavoritedOutfits()
        if allOutfits.count > outfits.count {
            allOutfits = outfits
        }
        kolodaView.reloadData()
    }
}

//MARK: KolodaViewDelegate
extension MyClosetViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        refreshArrays()
        koloda.resetCurrentCardIndex()
    }
    
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
        let outfit: Outfit = allOutfits[index]
        outfit.setImagePath()
        let image = Helper.image(atPath: outfit.combinedImgUrl)
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        return imageView
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        guard index != allOutfits.count else { return }
        
        let outfit = allOutfits[index]
        
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
