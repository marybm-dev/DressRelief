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
    
    let allCategories = Category.allValues
    
    var categories = [String]()
    var outfits: Results<Outfit>!
    var favs: Results<Outfit>!
    var outfitsByCategory = [String: Results<Outfit>]()
    
    var notificationsSet = false
    var categoryTokens = [String: NotificationToken?]()
    
    let colors = Category.allColors
    var categoryColors = [String: UIColor]()
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0, right: 0.0)
    
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
        toggleHidden()
        collectionView.reloadData()

        categories = getOutfitCategories()
        setOutfitsHashTable()
        setCategoryColors()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
        toggleHidden()
    }
    
    func toggleHidden() {
        emptyImageView.isHidden = (favs?.count == 0) ? false : true
    }
}

// Mark: - Data Fetching
extension MyFavsViewController {
    
    func getFavs() -> Results<Outfit> {
        let realm = try! Realm()
        outfits = realm.objects(Outfit.self)
        return outfits.filter("isLiked = true")
    }
    
    func getOutfitCategories() -> [String] {
        let allCategories = favs.map { $0.category }
        return Array(Set(allCategories))
    }
    
    func setOutfitsHashTable() {
        outfits = getFavs()
        for category in categories {
            let results = outfits.filter("category = %@", category)
            outfitsByCategory[category] = results
            if !notificationsSet {
                categoryTokens[category] = notificationSubscription(for: results)
            }
        }
        notificationsSet = true
    }
    
    func setCategoryColors() {
        for (index,category) in allCategories.enumerated() {
            categoryColors[category] = colors[index]
        }
    }
    
    func refreshData() {
        categories = getOutfitCategories()
        setOutfitsHashTable()
        collectionView.reloadData()
    }
}

// Mark: - SwiftRealm Notifications
extension MyFavsViewController {
    
    func notificationSubscription(for outfits: Results<Outfit>) -> NotificationToken {
        return outfits.addNotificationBlock({ [weak self] (changes: RealmCollectionChange<Results<Outfit>>) in
            self?.updateUI(with: changes)
        })
    }
    
    func updateUI(with changes: RealmCollectionChange<Results<Outfit>>) {
        switch changes {
        case .initial(_):
            collectionView.reloadData()
        case .update(_, _, _, _):
            self.refreshData()
            break
        case let .error(error):
            print(error.localizedDescription)
        }
    }
}

// Mark: – UICollectionViewDataSource
extension MyFavsViewController: UICollectionViewDataSource {
    
    func outfit(for indexPath: IndexPath) -> Outfit? {
        let category = categories[indexPath.section]
        return outfitsByCategory[category]?[indexPath.row]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = categories[section]
        return outfitsByCategory[category]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutfitCell", for: indexPath) as! OutfitCollectionViewCell
        self.animateEditing(for: cell)
        guard let outfit = outfit(for: indexPath) else {
            return cell
        }
        cell.outfit = outfit
        guard let color = categoryColors[outfit.category] else {
            return cell
        }
        cell.layer.addBorder(edge: .left, color: color, thickness: 5.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OutfitCategoryHeaderView", for: indexPath) as! OutfitCategoryHeaderView
        let category = categories[indexPath.section]
        headerView.category = category
        headerView.containerView.layer.addBorder(edge: .top, color: UIColor.lightGray, thickness: 0.5)
        headerView.containerView.layer.addBorder(edge: .bottom, color: UIColor.lightGray, thickness: 0.5)
        return headerView
    }
}

// Mark: - UICollectionViewDelegateFlowLayout
extension MyFavsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        let availableHeight = view.frame.height - paddingSpace - 64.0 - 68.0 - 49.0 // navBar space - section headers - tabBar
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
        guard let outfit = outfit(for: indexPath) else { return }
        self.selectedOutfit = outfit
        
        if isEditingFavs {
            // prompt to delete this favorite outfit
            let alertController = UIAlertController(title: "Delete Favorite?", message: "This will remove the outfit from your favorites.", preferredStyle: UIAlertControllerStyle.alert)
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) { (result: UIAlertAction) -> Void in
                self.unfavorite(outfit: self.selectedOutfit)
                print("deleted \(self.selectedOutfit)")
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
    
    func didTapEditButton() {
        isEditingFavs = !isEditingFavs
        editButton.title = isEditingFavs ? "Done" : "Edit"
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
    
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
        }
    }
}
