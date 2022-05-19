//
//  Extesions+ UITextField.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
 
}
extension UITextView{
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.inputView = paddingView
    
    }

}

extension UITextField {

    func addShadowToTextField(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {

    self.backgroundColor = UIColor.white
    self.layer.masksToBounds = false
    self.layer.shadowColor = color.cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.layer.shadowOpacity = 1.0
    self.backgroundColor = .white
    self.layer.cornerRadius = cornerRadius
   }
}
