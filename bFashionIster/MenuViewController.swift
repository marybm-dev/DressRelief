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
    
    var viewControllers = [UIViewController]()
    var menuItems = [MenuItem]()
    
    var selectedMenuItem: MenuItem! {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var myClosetNavigationController: UIViewController!
    private var myFavsNavigationController: UIViewController!
    private var topsNavigationController: UIViewController!
    private var bottomsNavigationController: UIViewController!
    private var accountNavigationController: UIViewController!
    private var settingsNavigationController: UIViewController!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    
    // Collection View Cell boundaries
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update constraint to be off center to the left (because of hamburger contentView exposure)
        centerConstraint.constant -= 25
        
        // round the user's avatar image
        roundAvatarImage()

        // setup the navigation controllers
        setupNavigationControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationControllers() {
        let nib = UINib(nibName: "MenuItemCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "MenuItemCell")
        
        // setup menu items
        let closetItem = MenuItem(title: "My Closet", iconName: .closet, iconFilledName: .closetFilled)
        let myFavsItem = MenuItem(title: "My Favs", iconName: .favs, iconFilledName: .favsFilled)
        let topsItem = MenuItem(title: "Tops", iconName: .tops, iconFilledName: .topsFilled)
        let bottomsItem = MenuItem(title: "Bottoms", iconName: .bottoms, iconFilledName: .bottomsFilled)
        let accountItem = MenuItem(title: "Account", iconName: .account, iconFilledName: .accountFilled)
        let settingsItem = MenuItem(title: "Settings", iconName: .settings, iconFilledName: .settingsFilled)
        menuItems.append(closetItem)
        menuItems.append(myFavsItem)
        menuItems.append(topsItem)
        menuItems.append(bottomsItem)
        menuItems.append(accountItem)
        menuItems.append(settingsItem)
        
        // set the default selected menuItem
        selectedMenuItem = closetItem
        
        // init navigation controllers
        let closetStoryboard = UIStoryboard(name: "Closet", bundle: nil)
        let articlesStoryboard = UIStoryboard(name: "Articles", bundle: nil)
        let accountStoryboard = UIStoryboard(name: "Account", bundle: nil)
        myClosetNavigationController = closetStoryboard.instantiateViewController(withIdentifier: "MyClosetNavigationController")
        myFavsNavigationController = closetStoryboard.instantiateViewController(withIdentifier: "MyFavsNavigationController")
        topsNavigationController = articlesStoryboard.instantiateViewController(withIdentifier: "TopsNavigationController")
        bottomsNavigationController = articlesStoryboard.instantiateViewController(withIdentifier: "BottomsNavigationController")
        accountNavigationController = accountStoryboard.instantiateViewController(withIdentifier: "AccountNavigationController")
        settingsNavigationController = accountStoryboard.instantiateViewController(withIdentifier: "SettingsNavigationController")
        
        // add the menuItems to their respected viewController
        (myClosetNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = closetItem
        (myFavsNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = myFavsItem
        (topsNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = topsItem
        (bottomsNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = bottomsItem
        (accountNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = accountItem
        (settingsNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = settingsItem
        
        // add the viewControllers to navigation array
        viewControllers.append(myClosetNavigationController)
        viewControllers.append(myFavsNavigationController)
        viewControllers.append(topsNavigationController)
        viewControllers.append(bottomsNavigationController)
        viewControllers.append(accountNavigationController)
        viewControllers.append(settingsNavigationController)
        
        hamburgerViewController.contentViewController = myClosetNavigationController
    }
    
    func roundAvatarImage() {
        avatarImageView.layoutIfNeeded()
        let radius = avatarImageView.frame.size.width / 2
        avatarImageView.layer.cornerRadius = radius
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 2.0
        avatarImageView.layer.masksToBounds = false
        avatarImageView.clipsToBounds = true
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCollectionViewCell
        
        let menuItem = menuItems[indexPath.row]
        cell.menuItem = menuItem
        
        guard selectedMenuItem != nil else { return cell }
        cell.isCurrentMenuItem = (selectedMenuItem == menuItem) ? true : false

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let cell = collectionView.cellForItem(at: indexPath) as! MenuItemCollectionViewCell
        let menuItem = cell.menuItem
        self.selectedMenuItem = menuItem
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
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
