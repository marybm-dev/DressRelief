//
//  Category.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/20/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation
import UIKit

enum Category: Int, CustomStringConvertible {
    case professional, casual, formal, dressyCasual, nightOut, sportsware, anytime, comfy, display
    
    var description: String {
        switch self {
        case .professional:     return "Professional"
        case .casual:           return "Casual"
        case .formal:           return "Formal"
        case .dressyCasual:     return "Dressy Casual"
        case .nightOut:         return "Night Out"
        case .sportsware:       return "Sportsware"
        case .anytime:          return "Anytime"
        case .comfy:            return "Comfy"
        case .display:          return "Select a Category..."
        }
    }
    
    var color: UIColor {
        switch self {
        case .professional:     return UIColor.flatOrange()
        case .casual:           return UIColor.flatBlue()
        case .formal:           return UIColor.flatDarkBlue()
        case .dressyCasual:     return UIColor.flatGreen()
        case .nightOut:         return UIColor.flatRed()
        case .sportsware:       return UIColor.flatPurple()
        case .anytime:          return UIColor.flatYellow()
        case .comfy:            return UIColor.flatDarkGray()
        default:                return UIColor.white
        }
    }
    
    static let allRawValues = professional.rawValue...comfy.rawValue
    static let allValues = allRawValues.map { Category(rawValue: $0)!.description }
    static let allColors = allRawValues.map { Category(rawValue: $0)!.color }
    
    static func colors() -> [String: UIColor] {
        let colors = Category.allColors
        var categoryColors = [String: UIColor]()
        let allCategories = Category.allValues
        for (index,category) in allCategories.enumerated() {
            categoryColors[category] = colors[index]
        }
        
        return categoryColors
    }
}

struct CategoryItem {
    var name: String
    var color: UIColor
    
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
}
