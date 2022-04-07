//
//  ParentViewController.swift
//  FitMeet
//
//  Created by novotorica on 27.04.2021.
//

import Foundation
import UIKit
import AVKit

extension UITabBarController {
    
override open var shouldAutorotate: Bool {
    get {
        if let selectedVC = selectedViewController{
            return selectedVC.shouldAutorotate
        }
        return super.shouldAutorotate
    }
}
override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
    get {
        if let selectedVC = selectedViewController{
            return selectedVC.preferredInterfaceOrientationForPresentation
        }
        return super.preferredInterfaceOrientationForPresentation
    }
}
override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
    get {
        if let selectedVC = selectedViewController{
            return selectedVC.supportedInterfaceOrientations
        }
        return super.supportedInterfaceOrientations
    }
}}
  

extension UIViewController {
    
    //MARK: Keyboard
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {}
    
    @objc func keyboardWillHide(notification: NSNotification) {}
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func addControllerInContainer(vc: UIViewController, containerView: UIView){
        addChild(vc)
        vc.view.frame = containerView.bounds
        containerView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    func vibrate() {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
}
