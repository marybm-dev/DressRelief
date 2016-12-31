//
//  Extensions.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/14/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

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
    
    class func emeraldGreen() -> UIColor {
        return UIColor(netHex: 0x169c78)
    }
}


extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }

    func wobble() {
        let degrees: CGFloat = 5.0
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.duration = 0.6
        animation.isCumulative = true
        animation.repeatCount = Float.infinity
        animation.values = [0.0,
                            (-degrees).degreesToRadians * 0.25,
                            0.0,
                            (degrees).degreesToRadians * 0.5,
                            0.0,
                            (-degrees).degreesToRadians,
                            0.0,
                            (degrees).degreesToRadians,
                            0.0,
                            (-degrees).degreesToRadians * 0.5,
                            0.0,
                            (degrees).degreesToRadians * 0.25,
                            0.0]
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.isRemovedOnCompletion = true
        
        layer.add(animation, forKey: "wobble")
    }
    
    func stopWobbling() {
        self.layer.removeAllAnimations()
        self.transform = CGAffineTransform.identity
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func rounded() {
        let radius = self.frame.size.width / 2
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.alpha = 0
    }
}
