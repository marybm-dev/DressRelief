//
//  BottomsViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class BottomsViewController: UIViewController {

    var menuItem: MenuItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navBar = self.navigationController?.navigationBar
        menuItem = MenuItem(title: "Bottoms", iconName: .bottoms, iconFilledName: .bottomsFilled)
        self.navigationItem.titleView = Helper.getNavigationBarItem(menuItem: menuItem, for: navBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}