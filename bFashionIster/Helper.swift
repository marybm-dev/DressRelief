//
//  Helper.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/12/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation
import UIKit

class Helper {

    static func getNavigationBarItem(menuItem: MenuItem, for navBar: UINavigationBar?) -> UIButton {
        let imageName = "\(menuItem.iconName.rawValue)Bar"
        let navBarTitleButton = UIButton(type: .custom)
        navBarTitleButton.setImage(UIImage(named: imageName), for: .normal)
        navBarTitleButton.setTitle(menuItem.title, for: .normal)
        navBarTitleButton.sizeToFit()
        
        guard navBar != nil else { return navBarTitleButton }
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.customBlue]
        
        return navBarTitleButton
    }
}
