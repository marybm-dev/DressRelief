//
//  MeuItemViewController.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/17/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class MeuItemViewController: UIViewController {

    var menuItem: MenuItem! {
        didSet {
            navigationItem.titleView = setNavigationBarItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationBarItem() -> UIButton {
        let imageName = "\(menuItem.iconName.rawValue)Color"
        let navBarTitleButton = UIButton(type: .custom)
        navBarTitleButton.setImage(UIImage(named: imageName), for: .normal)
        navBarTitleButton.setTitle(menuItem.title, for: .normal)
        navBarTitleButton.setTitleColor(UIColor.white, for: .normal)
        navBarTitleButton.sizeToFit()
        
        return navBarTitleButton
    }
}
