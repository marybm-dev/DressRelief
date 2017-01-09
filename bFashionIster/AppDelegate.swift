//
//  AppDelegate.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/10/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Create a folder for images
        Helper.createImagesFolder()
        
        // Drops DB and Recreates if migration is needed
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
        
        // Test data
        TestData.defaults()
        
        // Setup styles
        self.configureAppStyling()
        
        return true
    }

    func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
        var adjustment: CGFloat = 0;
        
        if (UIApplication.shared.statusBarFrame.size.height == 40) {
            adjustment = -20;
        } else if (UIApplication.shared.statusBarFrame.size.height == 20 && oldStatusBarFrame.size.height == 40) {
            adjustment = 20;
        } else {
            return
        }
        
        let duration = UIApplication.shared.statusBarOrientationAnimationDuration
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        
        let frame = window?.rootViewController?.view.frame
        guard let viewFrame = frame else { return }
        window?.rootViewController?.view.frame = CGRect(x: viewFrame.origin.x, y: viewFrame.origin.y + adjustment, width: viewFrame.size.width, height: viewFrame.size.height)
        UIView.commitAnimations()
    }
}

extension AppDelegate {
    
    func configureAppStyling() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = initTabBarController()
        window?.makeKeyAndVisible()
    }
    
    func initNavigationControllers() -> [UINavigationController] {
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
        myClosetNavigationController.tabBarItem = UITabBarItem(title: "My Closet", image: #imageLiteral(resourceName: "closet"), selectedImage: #imageLiteral(resourceName: "closetFilled"))
        myFavsNavigationController.tabBarItem = UITabBarItem(title: "My Favs", image: #imageLiteral(resourceName: "favs"), selectedImage: #imageLiteral(resourceName: "favsFilled"))
        topsNavigationController.tabBarItem = UITabBarItem(title: "Tops", image: #imageLiteral(resourceName: "tops"), selectedImage: #imageLiteral(resourceName: "topsFilled"))
        bottomsNavigationController.tabBarItem = UITabBarItem(title: "Bottoms", image: #imageLiteral(resourceName: "bottoms"), selectedImage: #imageLiteral(resourceName: "bottomsFilled"))
        settingsNavigationController.tabBarItem = UITabBarItem(title: "About", image: #imageLiteral(resourceName: "settings"), selectedImage: #imageLiteral(resourceName: "aboutFilled"))
        
        // init navBar items
        let closetItem = MenuItem(title: "My Closet", iconName: .closet, iconFilledName: .closetFilled)
        let myFavsItem = MenuItem(title: "My Favs", iconName: .favs, iconFilledName: .favsFilled)
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
    
    func initTabBarController() -> UITabBarController {
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
        let tabBarBackground = #imageLiteral(resourceName: "bgWhite")
        tabBar.backgroundImage = tabBarBackground
        
        return tabBarController
    }
    
}
