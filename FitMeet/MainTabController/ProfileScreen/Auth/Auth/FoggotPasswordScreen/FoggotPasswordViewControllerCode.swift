//
//  FoggotPasswordViewControllerCode.swift
//  FitMeet
//
//  Created by novotorica on 15.04.2021.
//

import Foundation
import UIKit

final class FoggotPasswordViewControllerCode: UIView {
    
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let labelSignIn: UILabel = {
        let label = UILabel()
        label.text = "Forgot passwod?"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    let labelText: UILabel = {
        let label = UILabel()
        label.text = "Enter the email address you used when registering and we will send you instructions on how to change your password or enter your phone number and we will send you an SMS with a code"
        label.textColor = UIColor(hexString: "999999")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    let textFieldLogin: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Phone Number or Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    let buttonContinue: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
        button.setTitle("Continue", for: .normal)
        button.layer.cornerRadius = 19
        return button
    }()
    let labelAccount: UILabel = {
        let label = UILabel()
        label.text = "Don’t have an account?"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    let buttonSignUp: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hexString: "0099AE"), for: .normal)
        let font = UIFont.systemFont(ofSize: 14)
        button.setAttributedTitle(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: font]), for: .normal)
        return button
    }()
    let viewSignIn: UIView = {
        let view = UIView()
        return view
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
        
        cardView.addSubview(labelText)
        labelText.anchor(top: labelSignIn.bottomAnchor,
                                   left: cardView.leftAnchor,
                                   right: cardView.rightAnchor,
                                   paddingTop: 15, paddingLeft: 16, paddingRight: 16)
        
        cardView.addSubview(textFieldLogin)
        textFieldLogin.anchor(top: labelText.bottomAnchor,
                       left: cardView.leftAnchor,
                       right: cardView.rightAnchor,
                       paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 39)
        
        cardView.addSubview(buttonContinue)
        buttonContinue.anchor(top: textFieldLogin.bottomAnchor,
                       left: cardView.leftAnchor,
                       right: cardView.rightAnchor,
                       paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 39)
        cardView.addSubview(viewSignIn)
        viewSignIn.centerX(inView: cardView)
        viewSignIn.anchor(top: buttonContinue.bottomAnchor, paddingBottom: 10) 
        cardView.addSubview(labelAccount)
        labelAccount.anchor(top: viewSignIn.topAnchor,
                            left: viewSignIn.leftAnchor,
                            paddingTop: 10, paddingLeft: 10, height: 14)
        cardView.addSubview(buttonSignUp)
        buttonSignUp.anchor(top: viewSignIn.topAnchor,
                            left: labelAccount.rightAnchor,
                            right: viewSignIn.rightAnchor,
                            paddingTop: 10, paddingLeft: 4, paddingRight: 10, height: 14)


    }
}
