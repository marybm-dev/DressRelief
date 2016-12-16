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

    static func getNavigationBarItem(menuItem: MenuItem) -> UIButton {
        let imageName = "\(menuItem.iconName.rawValue)Bar"
        let navBarTitleButton = UIButton(type: .custom)
        navBarTitleButton.setImage(UIImage(named: imageName), for: .normal)
        navBarTitleButton.setTitle(menuItem.title, for: .normal)
        navBarTitleButton.setTitleColor(UIColor.customBlue(), for: .normal)
        navBarTitleButton.sizeToFit()

        return navBarTitleButton
    }
}
