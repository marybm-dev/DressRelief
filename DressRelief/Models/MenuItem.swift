//
//  MenuItem.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/11/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation

enum IconName: String {
    case closet,    closetFilled
    case favs,      favsFilled
    case tops,      topsFilled
    case bottoms,   bottomsFilled
    case account,   accountFilled
    case settings,  settingsFilled
    case about,     aboutFilled
    case star,      starFilled 
    
    case version, feedback, icons8 // used in about tableView
}

struct MenuItem {
    var title: String
    var iconName: IconName
    var iconFilledName: IconName
    
    init(title: String, iconName: IconName, iconFilledName: IconName) {
        self.title = title
        self.iconName = iconName
        self.iconFilledName = iconFilledName
    }
}

extension MenuItem: Equatable {
    static func ==(lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.title == rhs.title
    }
}
