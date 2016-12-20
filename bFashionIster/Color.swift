//
//  Color.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/20/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation

enum Color: Int, CustomStringConvertible {
    case multi, pattern, blackAndWhite, bold, earthy, warm, cool

    var description: String {
        switch self {
        case .multi:            return "Multi"
        case .pattern:          return "Pattern"
        case .blackAndWhite:     return "B&W"
        case .bold:             return "Bold"
        case .earthy:           return "Earthy"
        case .warm:             return "Warm"
        case .cool:             return "Cool"
        }
    }
    
    static let allRawValues = multi.rawValue...cool.rawValue
    static let allValues = allRawValues.map { Color(rawValue: $0)!.description }
}
