//
//  ParentViewController.swift
//  FitMeet
//
//  Created by novotorica on 27.04.2021.
//

import Foundation
import UIKit
import SwiftUI

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
struct SupportedOrientationsPreferenceKey: PreferenceKey {
    typealias Value = UIInterfaceOrientationMask
    static var defaultValue: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        }
        else {
            return .allButUpsideDown
        }
    }
      
    static func reduce(value: inout UIInterfaceOrientationMask, nextValue: () -> UIInterfaceOrientationMask) {
        // use the most restrictive set from the stack
        value.formIntersection(nextValue())
    }
}
  
/// Use this in place of `UIHostingController` in your app's `SceneDelegate`.
///
/// Supported interface orientations come from the root of the view hierarchy.
class OrientationLockedController<Content: View>: UIHostingController<OrientationLockedController.Root<Content>> {
    class Box {
        var supportedOrientations: UIInterfaceOrientationMask
        init() {
            self.supportedOrientations =
                UIDevice.current.userInterfaceIdiom == .pad
                    ? .all
                    : .allButUpsideDown
        }
    }
      
    var orientations: Box!
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        orientations.supportedOrientations
    }
      
    init(rootView: Content) {
        let box = Box()
        let orientationRoot = Root(contentView: rootView, box: box)
        super.init(rootView: orientationRoot)
        self.orientations = box
    }
      
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
      
    struct Root<Content: View>: View {
        let contentView: Content
        let box: Box
          
        var body: some View {
            contentView
                .onPreferenceChange(SupportedOrientationsPreferenceKey.self) { value in
                    // Update the binding to set the value on the root controller.
                    self.box.supportedOrientations = value
            }
        }
    }
}
  
extension View {
    func supportedOrientations(_ supportedOrientations: UIInterfaceOrientationMask) -> some View {
        // When rendered, export the requested orientations upward to Root
        preference(key: SupportedOrientationsPreferenceKey.self, value: supportedOrientations)
    }
}
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
    
}
