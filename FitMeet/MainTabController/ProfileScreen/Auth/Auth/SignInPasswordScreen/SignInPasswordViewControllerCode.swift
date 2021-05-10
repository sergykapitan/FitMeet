//
//  SignInPasswordViewControllerCode.swift
//  FitMeet
//
//  Created by novotorica on 15.04.2021.
//

import Foundation
import UIKit

final class SignInPasswordViewControllerCode: UIView {
    
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let labelSignIn: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    let textFieldLogin: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    let buttonSignIn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "0099AE")
        button.setTitle("Sign In", for: .normal)
        button.layer.cornerRadius = 19
        return button
    }()
    let buttonFoggotPassword: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hexString: "0099AE"), for: .normal)
        let font = UIFont.systemFont(ofSize: 14)
        button.setAttributedTitle(NSAttributedString(string: "Forgot password?", attributes: [NSAttributedString.Key.font: font]), for: .normal)
        return button
    }()
    let viewSignIn: UIView = {
        let view = UIView()
        return view
    }()
    let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "This password is incorrect, please choose diffrent."
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor(hexString: "#FF0000")
        label.textAlignment = .center
        return label
    }()
    let alertImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "alert-triangle")
        return image
    }()
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        initUI()
        initLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        addSubview(cardView)
 
    }
    private func initLayout() {
        cardView.fillSuperview()
        cardView.addSubview(labelSignIn)
        labelSignIn.anchor(top: cardView.topAnchor,
                           paddingTop: 46, height: 40)
        labelSignIn.centerX(inView: cardView)
        
        cardView.addSubview(textFieldLogin)
        textFieldLogin.anchor(top: labelSignIn.bottomAnchor,
                                   left: cardView.leftAnchor,
                                   right: cardView.rightAnchor,
                                   paddingTop: 15, paddingLeft: 16, paddingRight: 16, height: 39)
        
        textFieldLogin.addSubview(alertImage)
        alertImage.anchor( right: textFieldLogin.rightAnchor, paddingRight: 15)
        alertImage.centerY(inView: textFieldLogin)
        
        cardView.addSubview(alertLabel)
        alertLabel.anchor(top: textFieldLogin.bottomAnchor, paddingTop: 5)
        alertLabel.centerX(inView: cardView)
        
        
        cardView.addSubview(buttonSignIn)
        buttonSignIn.anchor(top: textFieldLogin.bottomAnchor,
                       left: cardView.leftAnchor,
                       right: cardView.rightAnchor,
                       paddingTop: 15, paddingLeft: 10, paddingRight: 10, height: 39)
        
        cardView.addSubview(buttonFoggotPassword)
        buttonFoggotPassword.anchor(top: buttonSignIn.bottomAnchor, paddingTop: 10)
        buttonFoggotPassword.centerX(inView: cardView)

    }
}
