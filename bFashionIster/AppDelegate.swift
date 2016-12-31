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

    // navy blue hex #1a3e84
    // tinder swipes, use Koloda cocoapod - https://github.com/Yalantis/Koloda

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Helper.createImagesFolder()
        
        // Drops DB and Recreates if migration is needed
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
        
        TestData.defaults()
        
        self.configureAppStyling()
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let hamburgerVC = storyboard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
//        let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
//        
//        menuVC.hamburgerViewController = hamburgerVC
//        hamburgerVC.menuViewController = menuVC
//        
//        window?.rootViewController = hamburgerVC
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
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
        myClosetNavigationController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "closet"), selectedImage: #imageLiteral(resourceName: "closetFilled"))
        myFavsNavigationController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "favs"), selectedImage: #imageLiteral(resourceName: "favsFilled"))
        topsNavigationController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tops"), selectedImage: #imageLiteral(resourceName: "topsFilled"))
        bottomsNavigationController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "bottoms"), selectedImage: #imageLiteral(resourceName: "bottomsFilled"))
        settingsNavigationController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "settings"), selectedImage: #imageLiteral(resourceName: "settingsFilled"))
        
        // init navBar items
        let closetItem = MenuItem(title: "My Closet", iconName: .closet, iconFilledName: .closetFilled)
        let myFavsItem = MenuItem(title: "My Favs", iconName: .favs, iconFilledName: .favsFilled)
        let topsItem = MenuItem(title: "Tops", iconName: .tops, iconFilledName: .topsFilled)
        let bottomsItem = MenuItem(title: "Bottoms", iconName: .bottoms, iconFilledName: .bottomsFilled)
        let settingsItem = MenuItem(title: "Settings", iconName: .settings, iconFilledName: .settingsFilled)

        // add the menuItems to their respected viewController
        (myClosetNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = closetItem
        (myFavsNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = myFavsItem
        (topsNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = topsItem
        (bottomsNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = bottomsItem
        (settingsNavigationController.childViewControllers.first as? MeuItemViewController)?.menuItem = settingsItem
        
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
        navBar.barTintColor = UIColor.customBlue()
        
        let tabBar = UITabBar.appearance()
        tabBar.tintColor = UIColor.customBlue()                // bar button items
        let tabBarBackground = #imageLiteral(resourceName: "bgWhite")
        tabBar.backgroundImage = tabBarBackground
        
        return tabBarController
    }
    
}
