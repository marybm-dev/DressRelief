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
                imageView.image = nil
            }
        }
    }

    static func image(atPath articlePath: String) -> UIImage? {
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
    
    static func createImagesFolder() {
        let fileManager = FileManager.default
        let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let photoDir = docsURL.appendingPathComponent("Images").path
        var isDir : ObjCBool = false
        
        // if path does not exist, create it
        if !fileManager.fileExists(atPath: photoDir, isDirectory:&isDir) {
            do {
                try fileManager.createDirectory(atPath: photoDir, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

}
