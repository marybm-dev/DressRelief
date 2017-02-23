//
//  Helper.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/22/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class Helper {

    static func applicationDocumentDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    static func displayAlert(with errorDescription: String, in viewController: UIViewController) {
        let stickFigure = "\n\\(•_•)\n  (   (>\n /   \\"
        let alertController = UIAlertController(title: "Uh oh. Something went wrong", message: "We're emailing the nerd that created this bug. Sorry bout that. \(stickFigure)", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func set(article: Article, in imageView: UIImageView) {
        guard let url = Helper.urlForBookmark(bookmark: article.image) else {
            imageView.image = nil
            return
        }
        let image = UIImage(contentsOfFile: url.path)
        imageView.image = image
    }
    
    static func set(outfit: Outfit, in imageView: UIImageView) {
        guard let url = Helper.urlForBookmark(bookmark: outfit.combinedImage) else {
            imageView.image = nil
            return
        }
        let image = UIImage(contentsOfFile: url.path)
        imageView.image = image
    }
    
    static func bookmarkForURL(url: URL) -> Data? {
        var bookmarkData: Data?
        do {
            try bookmarkData = url.bookmarkData(options: URL.BookmarkCreationOptions.suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
        } catch (_) {
            bookmarkData = nil
        }
        
        return bookmarkData
    }
    
    static func urlForBookmark(bookmark: Data) -> URL? {
        var bookmarkIsStale = false
        var bookmarkURL: URL?
        do {
            try bookmarkURL = URL(resolvingBookmarkData: bookmark, options: URL.BookmarkResolutionOptions.withoutUI, relativeTo: nil, bookmarkDataIsStale: &bookmarkIsStale)
        } catch (_) {
            bookmarkURL = nil
        }
        
        return bookmarkURL
    }
    
    static func image(from bookmarkData: Data) -> UIImage? {
        guard let url = Helper.urlForBookmark(bookmark: bookmarkData) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    static func createImagesFolder() {
        let fileManager = FileManager.default
        let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let photoDir = docsURL.appendingPathComponent("Images").path
        var isDir : ObjCBool = false
        
        // if path does not exist, create it
        if !fileManager.fileExists(atPath: photoDir, isDirectory:&isDir) {
            do {
                try fileManager.createDirectory(atPath: photoDir, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    static func initNavigationControllers() -> [UINavigationController] {
        // init storyboards
        let closetStoryboard = UIStoryboard(name: "Closet", bundle: nil)
        let articlesStoryboard = UIStoryboard(name: "Articles", bundle: nil)
        let accountStoryboard = UIStoryboard(name: "Account", bundle: nil)
        
        // init navigation controllers
        let myClosetNavigationController = closetStoryboard.instantiateViewController(withIdentifier: "MyClosetNavigationController") as! UINavigationController
        let myFavsNavigationController = closetStoryboard.instantiateViewController(withIdentifier: "MyFavsNavigationController") as! UINavigationController
        let topsNavigationController = articlesStoryboard.instantiateViewController(withIdentifier: "TopsNavigationController") as! UINavigationController
        let bottomsNavigationController = articlesStoryboard.instantiateViewController(withIdentifier: "BottomsNavigationController") as! UINavigationController
        let settingsNavigationController = accountStoryboard.instantiateViewController(withIdentifier: "SettingsNavigationController") as! UINavigationController
        
        // init tabBar items
        myClosetNavigationController.tabBarItem = UITabBarItem(title: nil, image: (#imageLiteral(resourceName: "closet")).withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "closetFilled"))
        myClosetNavigationController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.normal)
        myClosetNavigationController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.customBlue()], for:.selected)
        myClosetNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        myFavsNavigationController.tabBarItem = UITabBarItem(title: nil, image: (#imageLiteral(resourceName: "favs")).withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "favsFilled"))
        myFavsNavigationController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.normal)
        myFavsNavigationController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.customBlue()], for:.selected)
        myFavsNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
        
        topsNavigationController.tabBarItem = UITabBarItem(title: nil, image: (#imageLiteral(resourceName: "tops")).withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "topsFilled"))
        topsNavigationController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.normal)
        topsNavigationController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.customBlue()], for:.selected)
        topsNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        bottomsNavigationController.tabBarItem = UITabBarItem(title: nil, image: (#imageLiteral(resourceName: "bottoms")).withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "bottomsFilled"))
        bottomsNavigationController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.normal)
        bottomsNavigationController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.customBlue()], for:.selected)
        bottomsNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        settingsNavigationController.tabBarItem = UITabBarItem(title: nil, image: (#imageLiteral(resourceName: "about")).withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "aboutFilled"))
        settingsNavigationController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.normal)
        settingsNavigationController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.customBlue()], for:.selected)
        settingsNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        // init navBar items
        let closetItem = MenuItem(title: "Wardrobe", iconName: .closet, iconFilledName: .closetFilled)
        let myFavsItem = MenuItem(title: "Favorites", iconName: .favs, iconFilledName: .favsFilled)
        let topsItem = MenuItem(title: "Tops", iconName: .tops, iconFilledName: .topsFilled)
        let bottomsItem = MenuItem(title: "Bottoms", iconName: .bottoms, iconFilledName: .bottomsFilled)
        let aboutItem = MenuItem(title: "About", iconName: .about, iconFilledName: .aboutFilled)
        
        // add the menuItems to their respected viewController
        (myClosetNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = closetItem
        (myFavsNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = myFavsItem
        (topsNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = topsItem
        (bottomsNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = bottomsItem
        (settingsNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = aboutItem
        
        return [myClosetNavigationController, myFavsNavigationController, topsNavigationController, bottomsNavigationController, settingsNavigationController]
    }
    
    static func initTabBarController() -> UITabBarController {
        // setup the tab bar
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = initNavigationControllers()
        
        // add styles to nav and tab bars
        let navBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor.appleLightestGray()
        navBar.barStyle = UIBarStyle.black
        navBar.barTintColor = UIColor.emeraldGreen()
        
        let tabBar = UITabBar.appearance()
        tabBar.tintColor = UIColor.customBlue()                // bar button items
        let tabBarBackground = #imageLiteral(resourceName: "bgFlatGray")
        tabBar.backgroundImage = tabBarBackground
        
        return tabBarController
    }
}
