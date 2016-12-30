//
//  MyFavsViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import RealmSwift

class MyFavsViewController: MeuItemViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var outfits: Results<Outfit>!
    var favs: Results<Outfit>!
    var subscription: NotificationToken?
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    var selectedOutfit: Outfit!
    
    var editButton: UIBarButtonItem!
    var isEditingFavs = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(MyFavsViewController.didTapEditButton))
        navigationItem.setRightBarButton(editButton, animated: true)
        
        let nib = UINib(nibName: "OutfitCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "OutfitCell")
        
        favs = getFavs()
        subscription = notificationSubscription(for: favs)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapEditButton() {
        isEditingFavs = !isEditingFavs
        editButton.title = isEditingFavs ? "Done" : "Edit"
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
    
    func animateEditing(cell: OutfitCollectionViewCell) {
        if isEditingFavs {
            UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
                cell.closeButton.alpha += 1.0
            }, completion: nil)
            cell.wobble()
            
        } else {
            UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
                cell.closeButton.alpha = 0
            }, completion: nil)
            cell.stopWobbling()
        }
    }
    
    func unfavorite(outfit: Outfit) {
        let realm = try! Realm()
        try! realm.write {
            outfit.isLiked = false
        }
    }
    
    func getFavs() -> Results<Outfit> {
        let realm = try! Realm()
        outfits = realm.objects(Outfit.self)
        
        return outfits.filter("isLiked = true")
    }
    
    func notificationSubscription(for outfits: Results<Outfit>) -> NotificationToken {
        return outfits.addNotificationBlock({ [weak self] (changes: RealmCollectionChange<Results<Outfit>>) in
            self?.updateUI(with: changes)
        })
    }
    
    func updateUI(with changes: RealmCollectionChange<Results<Outfit>>) {
        switch changes {
        case .initial(_):
            collectionView.reloadData()
        case let .update(_, deletions, insertions, modifications):
            
            collectionView.performBatchUpdates({
                self.collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                self.collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                self.collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                
            }, completion: { (completed: Bool) in
                // do any updates
            })
            
            break
        case let .error(error):
            print(error.localizedDescription)
        }
    }
    
    // Mark: – UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutfitCell", for: indexPath) as! OutfitCollectionViewCell
        
        cell.outfit = favs[indexPath.row]
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        
        self.animateEditing(cell: cell)
        
        return cell
    }
    
    // Mark: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        let availableHeight = view.frame.height - paddingSpace - 64.0 // navBar space
        let heightPerItem = availableHeight / itemsPerRow
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedOutfit = favs[Int(indexPath.row)]
        
        if isEditingFavs {
            // prompt to delete this favorite outfit
            let alertController = UIAlertController(title: "Delete Favorite?", message: "This will remove the outfit from your favorites.", preferredStyle: UIAlertControllerStyle.alert)
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) { (result: UIAlertAction) -> Void in
                self.unfavorite(outfit: self.selectedOutfit)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (result: UIAlertAction) in
                print("canceled")
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            performSegue(withIdentifier: OutfitSegue.FromOutfitFavsToDetail.rawValue, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == OutfitSegue.FromOutfitFavsToDetail.rawValue {
            let outfitDetailViewController = segue.destination as! OutfitDetailViewController
            outfitDetailViewController.outfit = selectedOutfit
        }
    }
}
