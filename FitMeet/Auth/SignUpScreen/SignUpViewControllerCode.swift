//
//  SignUpViewControllerCode.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import Foundation
import UIKit

final class SignUpViewControllerCode: UIView {
    
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
    let textFieldName: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    let textFieldUserName: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    let textFieldPassword: UITextField = {
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
    let buttonContinue: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(hexString: "0099AE")
        return button
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

        cardView.addSubview(textFieldName)
        textFieldName.anchor(top: labelSignUp.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        cardView.addSubview(textFieldUserName)
        textFieldUserName.anchor(top: textFieldName.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        cardView.addSubview(textFieldPassword)
        textFieldPassword.anchor(top: textFieldUserName.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)

        cardView.addSubview(buttonContinue)
        buttonContinue.anchor(top: textFieldPassword.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)


        
    }
}
