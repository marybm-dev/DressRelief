//
//  Extensions.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/14/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func customBlue() -> UIColor {
        return UIColor(netHex: 0x1a3e84)
    }
    
    class func appleLightestGray() -> UIColor {
        return UIColor(netHex: 0xF0F0F0)
    }
}
