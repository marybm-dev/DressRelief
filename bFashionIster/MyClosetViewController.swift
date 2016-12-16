//
//  MyClosetViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class MyClosetViewController: UIViewController {

    var menuItem: MenuItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuItem = MenuItem(title: "My Closet", iconName: .closet, iconFilledName: .closetFilled)
        self.navigationItem.titleView = Helper.getNavigationBarItem(menuItem: menuItem)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
