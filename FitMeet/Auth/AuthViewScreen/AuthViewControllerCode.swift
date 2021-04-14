//
//  AuthViewControllerCode.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit

final class AuthViewControllerCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let labelSignUp: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 23)
        return label
    }()
    let buttonSocialNetwork: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "0099AE")
        button.setTitle("Sign up with Social Network", for: .normal)
        button.layer.cornerRadius = 19
        return button
    }()
    let textFieldLogin: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Phone number or Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(15)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    let buttonContinue: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
        return button
    }()
    let oneLine: OneLineView = {
        let line = OneLineView()
        return line
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
        cardView.addSubview(labelSignUp)
        labelSignUp.anchor(top: cardView.topAnchor,
                           paddingTop: 46, height: 40)
        labelSignUp.centerX(inView: cardView)
        
        cardView.addSubview(buttonSocialNetwork)
        buttonSocialNetwork.anchor(top: labelSignUp.bottomAnchor,
                                   left: cardView.leftAnchor,
                                   right: cardView.rightAnchor,
                                   paddingTop: 15, paddingLeft: 16, paddingRight: 16, height: 39)
        cardView.addSubview(oneLine)
        oneLine.anchor(top: buttonSocialNetwork.bottomAnchor,
                       left: cardView.leftAnchor,
                       right: cardView.rightAnchor,
                       paddingTop: 15, paddingLeft: 10, paddingRight: 10, height: 39)
        cardView.addSubview(textFieldLogin)
        textFieldLogin.anchor(top: oneLine.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        cardView.addSubview(buttonContinue)
        buttonContinue.anchor(top: textFieldLogin.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        
        
    }
}
