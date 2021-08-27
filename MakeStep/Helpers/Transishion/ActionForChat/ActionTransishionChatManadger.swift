//
//  ActionTransishionChatManadger.swift
//  MakeStep
//
//  Created by novotorica on 26.08.2021.
//

import UIKit

final class ActionTransishionChatManadger: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ActionChatPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
