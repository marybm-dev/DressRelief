//
//  ViewControllerPannable.swift
//  bFashionIster
//
//  Created by Mary Martinez on 1/11/17.
//  Copyright © 2017 Mary Martinez. All rights reserved.
//

import UIKit

class PannableViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var originalFrame: CGRect?
    var detailViewFrame: CGRect?
    var currentPositionTouched: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        guard let finalFrame = originalFrame,
            let initialFrame = detailViewFrame else {
                return
        }
        
        let xScaleFactor = finalFrame.width / initialFrame.width
        let yScaleFactor = finalFrame.height / initialFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
            
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint( x: translation.x, y: translation.y)
            
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= 1500 {
                UIView.animate(withDuration: 0.2,
                    animations: {
                        self.view.transform = scaleTransform
                        self.view.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                        self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.frame.size.height)
                    },
                    completion: { (isCompleted) in
                        if isCompleted { self.dismiss(animated: false, completion: nil) }
                    }
                )
                
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
}

