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
//        TestData.defaults()
        
        // Setup styles
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = Helper.initTabBarController()
        window?.makeKeyAndVisible()
        
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
