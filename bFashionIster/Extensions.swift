//
//  Extensions.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/14/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

extension Dictionary {
    var keyCount: Int {
        get {
            let values = Array(self.values)
            return values.flatMap { $0 }.count
        }
    }
}

extension FileManager {
    static func documentsDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    static func cachesDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func lowerFirstLetter() -> String {
        let first = String(characters.prefix(1)).lowercased()
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func lowerFirstLetter() {
        self = self.lowerFirstLetter()
    }
}

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

    class func appleLightestGray() -> UIColor {
        return UIColor(netHex: 0xF0F0F0)
    }
    
    class func emeraldGreen() -> UIColor {
        return UIColor(netHex: 0x169c78)
    }
    
    class func customBlue() -> UIColor {
        return UIColor(netHex: 0x3a99d8)
    }
    
    class func flatTurquoise() -> UIColor {
        return UIColor(netHex: 0x1abc9c)
    }
    
    class func flatGreen() -> UIColor {
        return UIColor(netHex: 0x2ecc71)
    }
    
    class func flatBlue() -> UIColor {
        return UIColor(netHex: 0x3498db)
    }
    
    class func flatPurple() -> UIColor {
        return UIColor(netHex: 0x9b59b6)
    }
    
    class func flatYellow() -> UIColor {
        return UIColor(netHex: 0xf1c40f)
    }
    
    class func flatOrange() -> UIColor {
        return UIColor(netHex: 0xe67e22)
    }
    
    class func flatRed() -> UIColor {
        return UIColor(netHex: 0xe74c3c)
    }
    
    class func flatGray() -> UIColor {
        return UIColor(netHex: 0xbdc3c7)
    }
    
    class func flatDarkGray() -> UIColor {
        return UIColor(netHex: 0x95a5a6)
    }
    
    class func flatDarkBlue() -> UIColor {
        return UIColor(netHex: 0x34495e)
    }
    
    class func coolBlue() -> UIColor {
        return UIColor(netHex: 0x56c4e1)
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
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
    
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }

    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}

extension UIView {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
}

private extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}


extension UIImage {
    var squared: UIImage {
        let square = size.width < size.height ? CGSize(width: size.width, height: size.width) : CGSize(width: size.height, height: size.height)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    var circle: UIImage {
        let square = size.width < size.height ? CGSize(width: size.width, height: size.width) : CGSize(width: size.height, height: size.height)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    func resizeToWidth(width:Int)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: CGFloat(width), height: CGFloat(ceil(CGFloat(width)/size.width * size.height)))))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
}
