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

    static func setNavigationBarTitle(menuItem: MenuItem) -> UIButton {
        let navBarTitleButton = UIButton(type: .custom)
        navBarTitleButton.setImage(UIImage(named: menuItem.iconFilledName.rawValue), for: .normal)
        navBarTitleButton.setTitle(menuItem.title, for: .normal)
        navBarTitleButton.sizeToFit()
        
        return navBarTitleButton
    }
}
