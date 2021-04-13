//
//  UIViewController+Helpers.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

public extension UIViewController {
    func wrapToNavigationController(_ navigationController: UINavigationController? = nil) -> UINavigationController {
        if let navigationController = navigationController {
            navigationController.setViewControllers([self], animated: true)
            return navigationController
        } else {
            return UINavigationController(rootViewController: self)
        }
    }
    
    func changeRootWithFadeInAnimation(window: UIWindow, newRoot: UIViewController) {
        if let snapshot = window.snapshotView(afterScreenUpdates: true) {
            let viewController = newRoot
            viewController.view.addSubview(snapshot)
            window.rootViewController = viewController
            
            UIView.animate(withDuration: 0.3, animations: {
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }) { _ in
                snapshot.removeFromSuperview()
            }
        } else {
            let viewController = newRoot
            window.rootViewController = viewController
        }
    }
    
    func changeRootWithFadeOutAnimation(window: UIWindow, newRoot: UIViewController) {
        if let snapshot = window.snapshotView(afterScreenUpdates: true) {
            let viewController = newRoot
            viewController.view.addSubview(snapshot)
            window.rootViewController = viewController
            
            UIView.animate(withDuration: 0.3, animations: {
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
            }) { _ in
                snapshot.removeFromSuperview()
            }
        } else {
            let viewController = newRoot
            window.rootViewController = viewController
        }
    }
    
    func showModalAnimated(modal: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        
        if let layer = self.view.window?.layer {
            layer.add(transition, forKey: nil)
        }
        
        modal.modalPresentationStyle = .overFullScreen
        self.present(modal, animated: false, completion: nil)
    }
    
    func hideModalAnimated(modal: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        modal.view.window?.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    func removeChilController(child: UIViewController, animated: Bool) {
        let animationDuration: Double = animated ? 0.3 : 0
        
        UIView.animate(withDuration: animationDuration, animations: {
            child.view.layer.opacity = 0
        }) { _ in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    func addChildController(child: UIViewController) {
        self.addChild(child)
        child.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(child.view)
        self.view.bringSubviewToFront(child.view)
        child.didMove(toParent: self)
    }
    
    func showChild(child: UIViewController, window: UIWindow) {
        window.rootViewController?.addChildController(child: child)
    }
    
    func hideChild(child: UIViewController, window: UIWindow) {
        window.rootViewController?.removeChilController(child: child, animated: true)
    }
}
