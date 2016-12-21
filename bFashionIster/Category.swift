//
//  Category.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/20/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation

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
    
    static let allRawValues = professional.rawValue...comfy.rawValue
    static let allValues = allRawValues.map { Category(rawValue: $0)!.description }
}
