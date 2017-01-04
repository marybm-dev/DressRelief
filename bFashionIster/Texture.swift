//
//  Texture.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/20/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import Foundation

enum Texture: Int, CustomStringConvertible {
    case denim, silk, knit, linen, cotton, pleated, lace, sequence, glossy, matte, display
    
    var description: String {
        switch self {
        case .denim:           return "Denim"
        case .silk:            return "Silk"
        case .knit:            return "Knit"
        case .linen:           return "Linen"
        case .cotton:          return "Cotton"
        case .pleated:         return "Pleated"
        case .lace:            return "Lace"
        case .sequence:        return "Sequence"
        case .glossy:          return "Glossy"
        case .matte:           return "Matte"
        case .display:         return "Select a Texture..."
        }
    }
    
    static let allRawValues = denim.rawValue...matte.rawValue
    static let allValues = allRawValues.map { Texture(rawValue: $0)!.description }
}
