//
//  ActionTransishionChatManadger.swift
//  MakeStep
//
//  Created by novotorica on 26.08.2021.
//

import UIKit

final class ActionTransishionChatManadger: NSObject, UIViewControllerTransitioningDelegate {
    
    var intWidth: CGFloat?
    var intHeight: CGFloat?
    var presentTransition: UIViewControllerAnimatedTransitioning?
    var dismissTransition: UIViewControllerAnimatedTransitioning?
    var isLandscape: Bool = false
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil

    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
  
        return nil
       
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let actionChat = ActionChatPresentationController(presentedViewController: presented, presenting: presenting)
        guard let width = intWidth,let height = intHeight else { return actionChat}
        actionChat.intWith = width
        actionChat.intHeight = height
        return actionChat
    }
}
