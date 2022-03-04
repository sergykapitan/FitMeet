//
//  SignInViewControllerCode.swift
//  FitMeet
//
//  Created by novotorica on 15.04.2021.
//

import Foundation
import UIKit

final class SignInViewControllerCode: UIView {
    
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let labelSignUp: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    let buttonSocialNetwork: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blueColor
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
        button.backgroundColor = UIColor(red: 0.231, green: 0.345, blue: 0.643, alpha: 0.5)
        return button
    }()
    let oneLine: OneLineView = {
        let line = OneLineView()
        return line
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
        button.setTitleColor(.blueColor, for: .normal)
        let font = UIFont.systemFont(ofSize: 14)
        button.setAttributedTitle(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: font]), for: .normal)
        return button
    }()
    let viewSignIn: UIView = {
        let view = UIView()
        return view
    }()
    let alertImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "alert-triangle")
        return image
    }()
    
    let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "This phone number is incorrect"
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor(hexString: "#FF0000")
        label.textAlignment = .center
        return label
    }()
    let alertMailLabel: UILabel = {
        let label = UILabel()
        label.text = "This email is incorrect"
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor(hexString: "#FF0000")
        label.textAlignment = .center
        return label
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
       // cardView.fillSuperview()
        cardView.fillFull(for: self)

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
                       paddingTop: 25, paddingLeft: 10, paddingRight: 10, height: 39)
        cardView.addSubview(textFieldLogin)
        textFieldLogin.anchor(top: oneLine.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        textFieldLogin.addSubview(alertImage)
        alertImage.anchor( right: textFieldLogin.rightAnchor, paddingRight: 15)
        alertImage.centerY(inView: textFieldLogin)
        
        cardView.addSubview(alertLabel)
        alertLabel.anchor(top: textFieldLogin.bottomAnchor, paddingTop: 5)
        alertLabel.centerX(inView: cardView)
        
        cardView.addSubview(alertMailLabel)
        alertMailLabel.anchor(top: textFieldLogin.bottomAnchor, paddingTop: 5)
        alertMailLabel.centerX(inView: cardView)
        
 
        cardView.addSubview(buttonContinue)
        buttonContinue.anchor(top: textFieldLogin.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
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
