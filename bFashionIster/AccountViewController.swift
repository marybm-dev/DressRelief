//
//  AccountViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    var menuItem: MenuItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuItem = MenuItem(title: "Account", iconName: .account, iconFilledName: .accountFilled)
        self.navigationItem.titleView = Helper.getNavigationBarItem(menuItem: menuItem)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
