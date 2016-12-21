//
//  Texture.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/20/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation

enum Texture: Int, CustomStringConvertible {
    case denim, glossy, corduroy, display
    
    var description: String {
        switch self {
        case .denim:           return "Denim"
        case .glossy:          return "Glossy"
        case .corduroy:        return "Corduroy"
        case .display:         return "Select a Texture..."
        }
    }
    
    static let allRawValues = denim.rawValue...corduroy.rawValue
    static let allValues = allRawValues.map { Texture(rawValue: $0)!.description }
}
