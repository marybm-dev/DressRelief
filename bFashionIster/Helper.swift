//
//  Helper.swift
//  bFashionIster
//
//  Created by Mary Martinez on 12/22/16.
//  Copyright © 2016 Mary Martinez. All rights reserved.
//

import UIKit

class Helper {
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
}
