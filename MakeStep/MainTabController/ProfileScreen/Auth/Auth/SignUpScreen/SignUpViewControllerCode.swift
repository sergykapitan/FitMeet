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
    let alertImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "alert-triangle")
        return image
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
    let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "Name must be a valid "
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor(hexString: "#FF0000")
        label.textAlignment = .center
        return label
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
        button.backgroundColor = .blueColor
        return button
    }()
    let textPrivacyPolice: UILabel = {
        let label = UILabel()
        label.text = "By signing up, you agree to our "
        label.textColor = UIColor(hexString: "#BBBCBC")
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let buttonTerms: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blueColor, for: .normal)
        let font = UIFont.systemFont(ofSize: 10)
        button.setAttributedTitle(NSAttributedString(string: "Terms", attributes: [NSAttributedString.Key.font: font]), for: .normal)
        return button
    }()
    let buttonPrivacyPolicy: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blueColor, for: .normal)
        let font = UIFont.systemFont(ofSize: 10)
        button.setAttributedTitle(NSAttributedString(string: ",Privacy Policy", attributes: [NSAttributedString.Key.font: font]), for: .normal)
        return button
    }()
    let buttonPrivacyDMCA: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blueColor, for: .normal)
        let font = UIFont.systemFont(ofSize: 10)
        button.setAttributedTitle(NSAttributedString(string: ", DMCA", attributes: [NSAttributedString.Key.font: font]), for: .normal)
        return button
    }()
    let alertImage2: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "alert-triangle")
        image.isHidden = true
        return image
    }()
    let alertLabel2: UILabel = {
        let label = UILabel()
        label.text = "User Name must be a valid"
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor(hexString: "#FF0000")
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    let alertImage3: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "alert-triangle")
        image.isHidden = true
        return image
    }()
    let alertLabel3: UILabel = {
        let label = UILabel()
        label.text = "Password must be a valid"
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor(hexString: "#FF0000")
        label.textAlignment = .center
        label.isHidden = true
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
        cardView.fillFull(for: self)

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
        textFieldUserName.anchor(
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                               paddingLeft: 10, paddingRight: 10,height: 39)
        
        textFieldUserName.addSubview(alertImage)
        alertImage.anchor( right: textFieldName.rightAnchor, paddingRight: 15)
        alertImage.centerY(inView: textFieldName)
        
        cardView.addSubview(alertLabel)
        alertLabel.anchor(top: textFieldName.bottomAnchor, paddingTop: 5)
        alertLabel.centerX(inView: cardView)
        
        cardView.addSubview(textFieldPassword)
        textFieldPassword.anchor( left: cardView.leftAnchor,
                                  right: cardView.rightAnchor,
                                 paddingLeft: 10, paddingRight: 10,height: 39)

        cardView.addSubview(buttonContinue)
        buttonContinue.anchor( left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                               paddingLeft: 10, paddingRight: 10,height: 39)

        cardView.addSubview(textPrivacyPolice)
        textPrivacyPolice.anchor(top: buttonContinue.bottomAnchor,right: cardView.centerXAnchor,
                                 paddingTop: 11,paddingRight: 0)
        
        cardView.addSubview(buttonTerms)
        buttonTerms.anchor(left: textPrivacyPolice.rightAnchor, paddingLeft: 2)
        buttonTerms.centerY(inView: textPrivacyPolice)
       
        cardView.addSubview(buttonPrivacyPolicy)
        buttonPrivacyPolicy.anchor(left: buttonTerms.rightAnchor, paddingLeft: 2)
        buttonPrivacyPolicy.centerY(inView: textPrivacyPolice)
        
        cardView.addSubview(buttonPrivacyDMCA)
        buttonPrivacyDMCA.anchor(left: buttonPrivacyPolicy.rightAnchor, paddingLeft: 2)
        buttonPrivacyDMCA.centerY(inView: textPrivacyPolice)
        
        textFieldUserName.addSubview(alertImage2)
        alertImage2.anchor( right: textFieldUserName.rightAnchor, paddingRight: 15)
        alertImage2.centerY(inView: textFieldUserName)
        
        cardView.addSubview(alertLabel2)
        alertLabel2.anchor(top: textFieldUserName.bottomAnchor, paddingTop: 5)
        alertLabel2.centerX(inView: cardView)
        
        textFieldPassword.addSubview(alertImage3)
        alertImage3.anchor( right: textFieldPassword.rightAnchor, paddingRight: 15)
        alertImage3.centerY(inView: textFieldPassword)
        
        cardView.addSubview(alertLabel3)
        alertLabel3.anchor(top: textFieldPassword.bottomAnchor, paddingTop: 5)
        alertLabel3.centerX(inView: cardView)
        
    }
}
