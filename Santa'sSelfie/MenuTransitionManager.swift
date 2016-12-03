//
//  MenuTransitionManager.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 12/2/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit

@objc protocol MenuTransitionManagerDelegate {
    func dismiss()
}

class MenuTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var delegate:MenuTransitionManagerDelegate?
    
    var duration = 0.5
    var isPresenting = false
    
    var snapshot: UIView?
    {
        didSet {
            if let _delegate = delegate {
                let tapGestureRecognizer = UITapGestureRecognizer(target: _delegate, action: #selector(MenuTransitionManagerDelegate.dismiss))
                snapshot?.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get reference to out fromView, toView and the container view
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        // Setup transform for sliding
        let container = transitionContext.containerView
        let moveDown = CGAffineTransform(translationX: 0, y: 270)
        let moveUp = CGAffineTransform(translationX: 0, y: -300)
        
        // Add both view to the container view
        if isPresenting {
            toView?.transform = moveUp
            snapshot = fromView?.snapshotView(afterScreenUpdates: true)
            container.addSubview(toView!)
            container.addSubview(snapshot!)
        }
        
        // Perfom the animation 
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: [], animations: {
            if self.isPresenting {
                self.snapshot?.transform = moveDown
                toView?.transform = CGAffineTransform.identity
            } else {
                self.snapshot?.transform = CGAffineTransform.identity
                fromView?.transform = moveUp
            }
        }, completion: { (finished) in
            transitionContext.completeTransition(true)
            if !self.isPresenting {
                self.snapshot?.removeFromSuperview()
            }
        })
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
            return self
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    
}
