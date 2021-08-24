//
//  ActionSheetTransitionManager.swift
//  MakeStep
//
//  Created by novotorica on 20.08.2021.
//

import UIKit

final class ActionSheetTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ActionSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
