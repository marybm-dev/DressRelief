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
    var subscription: NotificationToken?
    
    var didUpdate = false
    var originalCount = 0

    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        realm = try! Realm()
        outfits = getUnfavoritedOutfits()
        originalCount = outfits.count
        subscription = notificationSubscription(for: outfits)
    }

    @IBAction func didTapDislikeButton(_ sender: Any) {
        kolodaView.swipe(SwipeResultDirection.left)
    }
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        kolodaView.swipe(SwipeResultDirection.right)
    }
    
    func getUnfavoritedOutfits() -> Results<Outfit> {
        let allOutfits = realm.objects(Outfit.self)
        return allOutfits.filter("isLiked = false")
    }
    
    func notificationSubscription(for outfits: Results<Outfit>) -> NotificationToken {
        return outfits.addNotificationBlock({ [weak self] (changes: RealmCollectionChange<Results<Outfit>>) in
            self?.updateUI(with: changes)
        })
    }
    
    func updateUI(with changes: RealmCollectionChange<Results<Outfit>>) {
        switch changes {
        case .initial(_):
            kolodaView.reloadData()
        case .update(_, _, _, _):
            didUpdate = true
        case let .error(error):
            print(error.localizedDescription)
        }

        didUpdate = false
    }
}

//MARK: KolodaViewDelegate
extension MyClosetViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        originalCount = outfits.count
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
        return outfits != nil ? outfits.count : 0
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        var indexToUse = index
        if didUpdate || outfits.count == index {
            indexToUse -= 1
        }

        let outfit: Outfit = outfits[indexToUse]
        outfit.setImagePath()
        let image = Helper.image(atPath: outfit.combinedImgUrl)
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        return imageView
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        let offset = originalCount - outfits.count
        let indexToUse = index - offset
        
        try! realm.write {
            if direction == SwipeResultDirection.right {
                let outfit = outfits[indexToUse]
                outfit.isLiked = true
            }
        }
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
