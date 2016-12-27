//
//  Helper.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/22/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class Helper {
    
    static let fileDirectory : NSURL  = {
        return try! FileManager.default.url(for: .documentDirectory , in: .userDomainMask , appropriateFor: nil, create: true)
        }() as NSURL
    
    static func displayAlert(with errorDescription: String, in viewController: UIViewController) {
        let stickFigure = "\n\\(•_•)\n  (   (>\n /   \\"
        let alertController = UIAlertController(title: "Uh oh. Something went wrong", message: "We're emailing the nerd that created this bug. Sorry bout that. \(stickFigure)", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
        
        // TODO how do I email myself about bugs like these?
        // - I'll already know 1. the error and 2. the viewController this happened
    }
    
    static func set(article: Article, in imageView: UIImageView) {
        if FileManager.default.fileExists(atPath: article.imgUrl) {
            let imageURL = URL(fileURLWithPath: article.imgUrl)
            imageView.image = UIImage(contentsOfFile: imageURL.path)
            
        } else {
            // attempt to load "named" image
            if let image = UIImage(named: article.imgUrl) {
                imageView.image = image
                
            } else {
                // defaults image - just in case
                if article.articleType == ArticleType.top.rawValue {
                    imageView.image = #imageLiteral(resourceName: "topsBar")
                    
                } else {
                    imageView.image = #imageLiteral(resourceName: "bottomsBar")
                }
            }
        }
    }
    
    static func articleImage(forArticle article: Article) -> UIImage? {
        if FileManager.default.fileExists(atPath: article.imgUrl) {
            let imageURL = URL(fileURLWithPath: article.imgUrl)
            return UIImage(contentsOfFile: imageURL.path)
            
        } else {
            // attempt to load "named" image
            if let image = UIImage(named: article.imgUrl) {
                return image
                
            } else {
                // defaults image - just in case
                if article.articleType == ArticleType.top.rawValue {
                    return #imageLiteral(resourceName: "topsBar")
                    
                } else {
                    return #imageLiteral(resourceName: "bottomsBar")
                }
            }
        }
    }
    
    static func articleImage(atPath articlePath: String) -> UIImage? {
        if FileManager.default.fileExists(atPath: articlePath) {
            let imageURL = URL(fileURLWithPath: articlePath)
            return UIImage(contentsOfFile: imageURL.path)
            
        } else {
            // attempt to load "named" image
            if let image = UIImage(named: articlePath) {
                return image
                
            } else {
                return nil
            }
        }
    }
}
