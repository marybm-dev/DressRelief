//
//  AppDelegate.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/10/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit
import RealmSwift
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])

        
        var config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
//      *** DEVELOPMENT ONLY ***
//         - Drops DB and Recreates if migration is needed
//        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config

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
