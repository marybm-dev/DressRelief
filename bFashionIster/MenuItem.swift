//
//  MenuItem.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/11/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation

enum IconName: String {
    case closet, favs, tops, bottoms, account, settings
}

struct MenuItem {
    var title: String
    var iconName: IconName
    
    init(title: String, iconName: IconName) {
        self.title = title
        self.iconName = iconName
    }
}
