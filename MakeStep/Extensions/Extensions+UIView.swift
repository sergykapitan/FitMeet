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
               paddingTop: 5, paddingLeft: 15, paddingRight: 45, paddingBottom: 5,height: 88)
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
           // topAnchor.
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

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
