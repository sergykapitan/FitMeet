//
//  SecurityCodeVCCode.swift
//  FitMeet
//
//  Created by novotorica on 16.04.2021.
//

import Foundation
import UIKit

final class SecurityCodeVCCode: UIView {
    
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let labelSignIn: UILabel = {
        let label = UILabel()
        label.text = "Security Code"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    let labelText: UILabel = {
        let label = UILabel()
        label.text = "Enter the code sent to you by Email"
        label.textColor = UIColor(hexString: "999999")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    let textFieldCode: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Enter the code ", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.textAlignment = .center
        textField.textColor = .black
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    let buttonSendCode: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
        button.setTitle("Send Code", for: .normal)
        button.layer.cornerRadius = 19
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
       // cardView.fillSuperview()
        cardView.fillFull(for: self)

        cardView.addSubview(labelSignIn)
        labelSignIn.anchor(top: cardView.topAnchor,
                           paddingTop: 46, height: 40)
        labelSignIn.centerX(inView: cardView)
        
        cardView.addSubview(labelText)
        labelText.anchor(top: labelSignIn.bottomAnchor,
                                   left: cardView.leftAnchor,
                                   right: cardView.rightAnchor,
                                   paddingTop: 15, paddingLeft: 16, paddingRight: 16)
        
        cardView.addSubview(textFieldCode)
        textFieldCode.anchor(top: labelText.bottomAnchor,
                       left: cardView.leftAnchor,
                       right: cardView.rightAnchor,
                       paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 39)
        
        cardView.addSubview(buttonSendCode)
        buttonSendCode.anchor(top: textFieldCode.bottomAnchor,
                       left: cardView.leftAnchor,
                       right: cardView.rightAnchor,
                       paddingTop: 20, paddingLeft: 10, paddingRight: 10, height: 39)
       
    }
}
