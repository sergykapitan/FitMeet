//
//  AddMonetezationCode.swift
//  MakeStep
//
//  Created by Sergey on 28.10.2021.
//

import UIKit
import iOSDropDown
import Kingfisher

final class AddMonetezationCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()     
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        return view
        }()
    
    var buttonCloseChat: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8"), for: .normal)
        return button
    }()
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Add New +"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    let textViewName: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
        tv.layer.borderWidth = 1.5
        tv.layer.cornerRadius = 20
        tv.text = "Name"
        tv.textColor = UIColor.lightGray
        tv.returnKeyType = .done
        tv.clipsToBounds = true
        tv.font =  UIFont.systemFont(ofSize: 18)
        tv.textContainerInset = UIEdgeInsets(top: 9, left: 25, bottom: 9, right: 5)
        tv.isScrollEnabled = false
        return tv
    }()
    let textFieldPeriodType: DropDown = {
        let textField = DropDown()
        textField.layer.cornerRadius = 19
        textField.attributedPlaceholder =
            NSAttributedString(string: "Period Type", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
        return textField
    }()
    let textFieldPrice: DropDown = {
        let textField = DropDown()
        textField.layer.cornerRadius = 19
        textField.attributedPlaceholder =
            NSAttributedString(string: "Price", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
        return textField
    }()
    let textViewDescription: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
        tv.layer.borderWidth = 1.5
        tv.layer.cornerRadius = 20
        tv.text = "Description"
        tv.textColor = UIColor.lightGray
        tv.returnKeyType = .done
        tv.clipsToBounds = true
        tv.font =  UIFont.systemFont(ofSize: 18)
        tv.textContainerInset = UIEdgeInsets(top: 9, left: 25, bottom: 9, right: 5)
        tv.isScrollEnabled = false
        return tv
    }()
    var buttonSave: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle(" Create ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 15
        return button
    }()
    var buttonCancel: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle(" Cancel ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 15
        return button
    }()

    //MARK: - initial
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCardViewLayer()
    
    }
    
    //MARK: - constraint First Layer
    
    func createCardViewLayer() {
        addSubview(cardView)
        cardView.fillSuperview()
  
    
 
        cardView.addSubview(buttonCloseChat)
        buttonCloseChat.anchor( top: cardView.topAnchor,paddingTop: 0,width: 40, height: 30)
        buttonCloseChat.centerX(inView: cardView)
        
        cardView.addSubview(titleLabel)
        titleLabel.anchor(top: buttonCloseChat.bottomAnchor, paddingTop: 0)
        titleLabel.centerX(inView: cardView)
        
        cardView.addSubview(textViewName)
        textViewName.anchor(top: titleLabel.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16,height: 40)
        
        cardView.addSubview(textFieldPeriodType)
        textFieldPeriodType.anchor(top: textViewName.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16,height: 40)
        
        cardView.addSubview(textFieldPrice)
        textFieldPrice.anchor(top: textFieldPeriodType.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16,height: 40)
        
        cardView.addSubview(textViewDescription)
        textViewDescription.anchor(top: textFieldPrice.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16)
        
        
        
        cardView.addSubview(buttonCancel)
        buttonCancel.anchor(bottom: cardView.bottomAnchor, paddingBottom: 10, width: 102, height: 30)
        buttonCancel.centerX(inView: cardView)
        
        
        cardView.addSubview(buttonSave)
        buttonSave.anchor(bottom: buttonCancel.topAnchor, paddingBottom: 10, width: 102, height: 30)
        buttonSave.centerX(inView: cardView)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

