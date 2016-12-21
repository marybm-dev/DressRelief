//
//  Category.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/20/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation

enum Category: Int, CustomStringConvertible {
    case business, casual, dressy, dressyCasual, nightOut, sporty, comfy, display
    
    var description: String {
        switch self {
        case .business:         return "Business"
        case .casual:           return "Casual"
        case .dressy:           return "Dressy"
        case .dressyCasual:     return "Dressy Casual"
        case .nightOut:         return "Night Out"
        case .sporty:           return "Sporty"
        case .comfy:            return "Comfy"
        case .display:          return "Select a Category..."
        }
    }
    
    static let allRawValues = business.rawValue...comfy.rawValue
    static let allValues = allRawValues.map { Category(rawValue: $0)!.description }
}
