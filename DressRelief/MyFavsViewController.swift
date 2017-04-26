//
//  MyFavsViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import RealmSwift

class MyFavsViewController: MeuItemViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyImageView: UIImageView!
    
    var outfits: Results<Outfit>!
    var favs: Results<Outfit>!
    var subscription: NotificationToken?
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 1.0, bottom: 0, right: 0.0)
    
    var selectedOutfit: Outfit!
    var selectedImage: UIImageView!
    var selectedImageFrame: CGRect!
    
    var editButton: UIBarButtonItem!
    var isEditingFavs = false
    
    let transition = TransitionAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(MyFavsViewController.didTapEditButton))
        navigationItem.setLeftBarButton(editButton, animated: true)
        
        let nib = UINib(nibName: "OutfitCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "OutfitCell")
        
        favs = getFavs()
        subscription = notificationSubscription(for: favs)
        toggleHidden()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toggleHidden()
        toggleEditing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        toggleEditing(true)
    }

    deinit {
        subscription?.stop()
    }
}

// Mark: - Data Fetching
extension MyFavsViewController {
    func getFavs() -> Results<Outfit> {
        let realm = try! Realm()
        outfits = realm.objects(Outfit.self)
        return outfits.filter("isLiked = true")
    }
}

// Mark: - Editing Logid
extension MyFavsViewController {
    func toggleHidden() {
        emptyImageView.isHidden = (favs?.count == 0) ? false : true
    }
    
    func didTapEditButton() {
        isEditingFavs = !isEditingFavs
        editButton.title = isEditingFavs ? "Done" : "Edit"
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
    
    func toggleEditing(_ willDisappear: Bool? = nil) {
        guard favs != nil else {
            return
        }
        
        let shouldHide = favs.count == 0 ? true : false
        if isEditingFavs {
            // there are no more items
            if shouldHide {
                isEditingFavs = false
                shouldDisplayEditButton(false)
                toggleHidden()
                return
            }
            // there still are items but I am leaving the view
            if let willDisappear = willDisappear {
                if willDisappear {
                    didTapEditButton()
                    return
                }
            }
            // there still are items and I am editing - do nothing
            
        } else {
            if shouldHide {
                shouldDisplayEditButton(false)
            } else {
                shouldDisplayEditButton(true)
            }
        }
    }
    
    func shouldDisplayEditButton(_ shouldDisplay: Bool) {
        editButton.title = shouldDisplay ? "Edit" : ""
        editButton.isEnabled = shouldDisplay ? true : false
    }
}

// Mark: - SwiftRealm Notifications
extension MyFavsViewController {
    
    func notificationSubscription(for favorites: Results<Outfit>) -> NotificationToken {
        return favorites.addNotificationBlock({ [weak self] (changes: RealmCollectionChange<Results<Outfit>>) in
            self?.updateUI(with: changes)
        })
    }
    
    func updateUI(with changes: RealmCollectionChange<Results<Outfit>>) {
        switch changes {
        case .initial(_):
            print("favs initial")
            collectionView.reloadData()
            break
        case .update(_, let deletions , let insertions, let modifications):
            print("\n\nfavs updates ... total: \(favs.count) \ndel:\(deletions.count) \ninsert:\(insertions.count) \nmod:\(modifications.count)")
            collectionView.reloadData()
            break
        case let .error(error):
            print("*** ERROR in favs notificationBlock ***")
            print(error.localizedDescription)
            break
        }
    }
}

// Mark: – UICollectionViewDataSource
extension MyFavsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemInSection -favs- \(favs?.count)")
        return favs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutfitCell", for: indexPath) as! OutfitCollectionViewCell
        self.animateEditing(for: cell)
        let outfit = favs[indexPath.row]
        cell.outfit = outfit
        return cell
    }
}

// Mark: - UICollectionViewDelegateFlowLayout
extension MyFavsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        let availableHeight = collectionView.frame.height - paddingSpace - 64.0 // navBar space - section headers
        let heightPerItem = availableHeight / itemsPerRow
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let outfit = favs[indexPath.row]
        self.selectedOutfit = outfit
        
        if isEditingFavs {
            // prompt to delete this favorite outfit
            let alertController = UIAlertController(title: "Delete Favorite?", message: "This will remove the outfit from your favorites.", preferredStyle: UIAlertControllerStyle.alert)
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) { (result: UIAlertAction) -> Void in
                self.unfavorite(outfit: self.selectedOutfit)
                self.toggleEditing(nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (result: UIAlertAction) in
                print("canceled")
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! OutfitCollectionViewCell
            self.selectedImage = cell.outfitImageView
            
            guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
            
            let cellRect = attributes.frame
            let cellFrameInSuperview = collectionView.convert(cellRect, to: collectionView.superview)
            self.selectedImageFrame = cellFrameInSuperview
            performSegue(withIdentifier: OutfitSegue.FromOutfitFavsToDetail.rawValue, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == OutfitSegue.FromOutfitFavsToDetail.rawValue {
            let outfitDetailViewController = segue.destination as! OutfitDetailViewController
            outfitDetailViewController.outfit = selectedOutfit
            outfitDetailViewController.transitioningDelegate = self
            outfitDetailViewController.originalFrame = self.selectedImageFrame
        }
    }
}

// Mark: - UIViewControllerTransitioningDelegate
extension MyFavsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = selectedImage!.superview!.convert(selectedImage!.frame, to: nil)
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

// Mark: - Actions
extension MyFavsViewController {
    func animateEditing(for cell: OutfitCollectionViewCell) {
        if isEditingFavs {
            UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
                cell.closeButton.alpha += 1.0
            }, completion: nil)
            cell.containerView.wobble()
            
        } else {
            UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
                cell.closeButton.alpha = 0
            }, completion: nil)
            cell.containerView.stopWobbling()
        }
    }
    
    func unfavorite(outfit: Outfit) {
        let realm = try! Realm()
        try! realm.write {
            outfit.isLiked = false
            
            guard let top = Article.find(by: outfit.topId, withRealm: realm),
                let bottom = Article.find(by: outfit.bottomId, withRealm: realm) else {
                    print("didn't find top or bottom to update as dis liked")
                    return
            }
            
            top.first?.countLikes -= 1
            bottom.first?.countLikes -= 1
        }
    }
}
