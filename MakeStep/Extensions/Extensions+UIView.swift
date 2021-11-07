//
//  Extensions+UIView.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit
import SwiftUI

extension UIView {
    
    func fillFull(for view: UIView, insets: UIEdgeInsets = .zero) {
        view.addConstraints([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
        ])
    }
  
    func fillSuperview() {
        anchor(top: superview?.safeAreaLayoutGuide.topAnchor,
               left: superview?.safeAreaLayoutGuide.leftAnchor,
               right: superview?.safeAreaLayoutGuide.rightAnchor,
               bottom: superview?.safeAreaLayoutGuide.bottomAnchor,
               paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
    }
    func fillSuperviewforCell() {
        anchor(top: superview?.safeAreaLayoutGuide.topAnchor,
               left: superview?.safeAreaLayoutGuide.leftAnchor,
               right: superview?.safeAreaLayoutGuide.rightAnchor,
               bottom: superview?.safeAreaLayoutGuide.bottomAnchor,
               paddingTop: 5, paddingLeft: 15, paddingRight: 15, paddingBottom: 5)
    }
    func fillSuperviewforCellRight() {
        anchor(top: superview?.safeAreaLayoutGuide.topAnchor,
               left: superview?.safeAreaLayoutGuide.leftAnchor,
               right: superview?.safeAreaLayoutGuide.rightAnchor,
               bottom: superview?.safeAreaLayoutGuide.bottomAnchor,
               paddingTop: 5, paddingLeft: 15, paddingRight: 45,width: 50, height: 88)
    }
    func fillSuperviewforLeft() {
        anchor(top: superview?.safeAreaLayoutGuide.topAnchor,
               left: superview?.safeAreaLayoutGuide.leftAnchor,
               right: superview?.safeAreaLayoutGuide.rightAnchor,
               bottom: superview?.safeAreaLayoutGuide.bottomAnchor,
               paddingTop: 5, paddingLeft: 45, paddingRight: 15, paddingBottom: 5)
    }


    func anchor (top:NSLayoutYAxisAnchor? = nil,
                 left:NSLayoutXAxisAnchor? = nil,
                 right:NSLayoutXAxisAnchor? = nil,
                 bottom:NSLayoutYAxisAnchor? = nil,
                 paddingTop:CGFloat = 0,
                 paddingLeft:CGFloat = 0,
                 paddingRight:CGFloat = 0,
                 paddingBottom:CGFloat = 0,
                 width:CGFloat? = nil,
                 height:CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    func centerX(inView view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    func centerY(inView view: UIView) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    func heightEqualToMultiplier (inView view: UIView,multiplier: CGFloat) {
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
    }
   
}

extension UIView {
    
    func allSubviews() -> [UIView] {
        var res = self.subviews
        for subview in self.subviews {
            let riz = subview.allSubviews()
            res.append(contentsOf: riz)
        }
        return res
    }
}

struct Tool {
    static func showTabBar() {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
            if let view = v as? UITabBar {
                view.isHidden = false
            }
        })
    }
    
    static func hiddenTabBar() {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.allSubviews().forEach({ (v) in
            if let view = v as? UITabBar {
                view.isHidden = true
            }
        })
    }
}
struct ShowTabBar: ViewModifier {
       func body(content: Content) -> some View {
           return content.padding(.zero).onAppear {
               Tool.showTabBar()
           }
       }
   }
   struct HiddenTabBar: ViewModifier {
       func body(content: Content) -> some View {
           return content.padding(.zero).onAppear {
               Tool.hiddenTabBar()
           }
       }
   }


extension View {
    func showTabBar() -> some View {
        return self.modifier(ShowTabBar())
    }
    func hiddenTabBar() -> some View {
        return self.modifier(HiddenTabBar())
    }
}
extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}
extension UINavigationController {

    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }

    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
    

}
import UIKit

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
extension UIImage {
    
    enum Theme {
        case triangle
        
        var name: String {
            switch self {
            case .triangle: return "triangle"
            }
        }
            
        var image: UIImage {
            return UIImage(named: self.name)!
        }
    }
}

extension UIView {
    
    func constraintsPinTo(leading: NSLayoutXAxisAnchor, trailing: NSLayoutXAxisAnchor, top: NSLayoutYAxisAnchor, bottom: NSLayoutYAxisAnchor) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: leading),
            self.trailingAnchor.constraint(equalTo: trailing),
            self.topAnchor.constraint(equalTo: top),
            self.bottomAnchor.constraint(equalTo: bottom)
            ])
    }
}

extension UIView {
    public func turnOffAutoResizing() {
        self.translatesAutoresizingMaskIntoConstraints = false
        for view in self.subviews as [UIView] {
           view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    public func orientationHasChanged(_ isInPortrait:inout Bool) -> Bool {
        if self.frame.width > self.frame.height {
            if isInPortrait {
                isInPortrait = false
                return true
            }
        } else {
            if !isInPortrait {
                isInPortrait = true
                return true
            }
        }
        return false
    }
    public func setOrientation(_ p:[NSLayoutConstraint], _ l:[NSLayoutConstraint]) {
        NSLayoutConstraint.deactivate(l)
        NSLayoutConstraint.deactivate(p)
        if self.bounds.width > self.bounds.height {
            NSLayoutConstraint.activate(l)
        } else {
            NSLayoutConstraint.activate(p)
        }
    }
}
extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 2
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
extension UIView {

    func edges(_ edges: UIRectEdge, to view: UIView, offset: UIEdgeInsets) {
        if edges.contains(.top) || edges.contains(.all) {
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: offset.top).isActive = true
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: offset.bottom).isActive = true
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset.left).isActive = true
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: offset.right).isActive = true
        }
    }
    
    func edges(_ edges: UIRectEdge, to layoutGuide: UILayoutGuide, offset: UIEdgeInsets) {
        if edges.contains(.top) || edges.contains(.all) {
            self.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: offset.top).isActive = true
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            self.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: offset.bottom).isActive = true
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            self.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: offset.left).isActive = true
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            self.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: offset.right).isActive = true
        }
    }
    
}
extension UIViewController {
    
func transitionVc(vc: UIViewController, duration: CFTimeInterval, type: CATransitionSubtype) {
    let customVcTransition = vc
    let transition = CATransition()
    transition.duration = duration
    transition.type = CATransitionType.moveIn
    transition.subtype = type
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    view.window!.layer.add(transition, forKey: kCATransition)
    present(customVcTransition, animated: false, completion: nil)
 }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismisssKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismisssKeyboard() {
        view.endEditing(true)
    }
}
public extension UIView {
    func round() {
    let width = bounds.width < bounds.height ? bounds.width : bounds.height
    let mask = CAShapeLayer()
        mask.path = UIBezierPath(ovalIn: CGRect(x: bounds.midX - width / 2, y: bounds.midY - width / 2, width: width, height: width)).cgPath
    self.layer.mask = mask
}
}

extension UIView {
  func animateTo(frame: CGRect, withDuration duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
    guard let _ = superview else {
      return
    }
    
    let xScale = frame.size.width / self.frame.size.width
    let yScale = frame.size.height / self.frame.size.height
    let x = frame.origin.x + (self.frame.width * xScale) * self.layer.anchorPoint.x
    let y = frame.origin.y + (self.frame.height * yScale) * self.layer.anchorPoint.y
   
    UIView.animate(withDuration: duration, delay: 0, options: .allowUserInteraction, animations: {
      self.layer.position = CGPoint(x: x, y: y)
      self.transform = self.transform.scaledBy(x: xScale, y: yScale)
    }, completion: completion)
  }
}
extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
extension UIViewController {
    /// Taken from this great StackOverflow post by Phani Sai: https://stackoverflow.com/a/35473300/78336
        func configureChildViewController(_ childController: UIViewController, onView: UIView?) {
            var holderView = self.view
            if let onView = onView {
                holderView = onView
            }
            addChild(childController)
            holderView?.addSubview(childController.view)
            holderView?.constrainViewEqual(childController.view)
            childController.didMove(toParent: self)
        }
    func removeAllChildViewController(_ childController: UIViewController) {
        childController.willMove(toParent: nil)

        // Then, remove the child from its parent
        childController.removeFromParent()

        // Finally, remove the child’s view from the parent’s
        childController.view.removeFromSuperview()
        }


    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                    toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                       toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                     toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                      toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)

        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
}
extension UIView {
    fileprivate func constrainViewEqual(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: self, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: self, attribute: .right, multiplier: 1.0, constant: 0)
        self.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
}
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
