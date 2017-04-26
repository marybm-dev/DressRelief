//
//  ControllerDelegate.swift
//  bFashionIster
//
//  Created by Mary Martinez on 1/11/17.
//  Copyright © 2017 Mary Martinez. All rights reserved.
//

import UIKit

class ControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    @IBOutlet weak var navigationController: UINavigationController?
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimator()
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
}
