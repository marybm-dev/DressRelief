//
//  MenuViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/10/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var hamburgerViewController: HamburgerViewController!
    
    var viewControllers: [UIViewController]! {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var menuItems = [MenuItem]()
    
    private var myClosetNavigationController: UIViewController!
    private var myFavsNavigationController: UIViewController!
    private var topsNavigationController: UIViewController!
    private var bottomsNavigationController: UIViewController!
    private var accountNavigationController: UIViewController!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Collection View Cell boundaries
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.layoutIfNeeded()
        let radius = avatarImageView.frame.size.width / 2
        avatarImageView.layer.cornerRadius = radius
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 2.0
        avatarImageView.layer.masksToBounds = false
        avatarImageView.clipsToBounds = true

        let nib = UINib(nibName: "MenuItemCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "MenuItemCell")
        
        // setup menu items
        menuItems.append(MenuItem(title: "My Closet", iconName: .closet))
        menuItems.append(MenuItem(title: "My Favs", iconName: .favs))
        menuItems.append(MenuItem(title: "Tops", iconName: .tops))
        menuItems.append(MenuItem(title: "Bottoms", iconName: .bottoms))
        menuItems.append(MenuItem(title: "Account", iconName: .account))
        menuItems.append(MenuItem(title: "Settings", iconName: .settings))
        
        // setup navigation controllers
        let closetStoryboard = UIStoryboard(name: "Closet", bundle: nil)
        let articlesStoryboard = UIStoryboard(name: "Articles", bundle: nil)
        let accountStoryboard = UIStoryboard(name: "Account", bundle: nil)
        
        myClosetNavigationController = closetStoryboard.instantiateViewController(withIdentifier: "MyClosetNavigationController")
        myFavsNavigationController = closetStoryboard.instantiateViewController(withIdentifier: "MyFavsNavigationController")
        topsNavigationController = articlesStoryboard.instantiateViewController(withIdentifier: "TopsNavigationController")
        bottomsNavigationController = articlesStoryboard.instantiateViewController(withIdentifier: "BottomsNavigationController")
        accountNavigationController = accountStoryboard.instantiateViewController(withIdentifier: "AccountNavigationController")
        
        viewControllers = [bottomsNavigationController, topsNavigationController, myFavsNavigationController, myClosetNavigationController]
        
        hamburgerViewController.contentViewController = myClosetNavigationController
        
        // TODO: Accounts should be a modal view with it's own icon somewhere on the menu screen
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCollectionViewCell
        
        cell.menuItem = menuItems[indexPath.row]
        
        return cell
    }
    
    // MARK: Collection View Delegate Flow Layout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.sectionInsets.left
    }
}
