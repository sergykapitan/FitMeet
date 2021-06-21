//
//  NewStartStreamCode.swift
//  FitMeet
//
//  Created by novotorica on 18.06.2021.
//

import Foundation
import UIKit
import iOSDropDown

final class NewStartStreamCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let labelAddImage: UILabel = {
        let label = UILabel()
        label.text = "Add a preview"
        label.textColor = UIColor(hexString: "#BBBCBC")
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let imageBackground: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Rectangle 966gggg")
        return image
    }()
    let imageButton: UIButton = {
        let image = UIButton()
        image.setImage(#imageLiteral(resourceName: "Vector1"), for: .normal)
        return image
    }()

    let textFieldName: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    let textFieldCategory: DropDown = {
        let textField = DropDown()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Category", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    let textFieldStartDate: DropDown = {
        let textField = DropDown()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Start Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    let textFieldAviable: DropDown = {
        let textField = DropDown()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Available for...", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    var textFieldFree: DropDown = {
        let textField = DropDown()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Free", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        
        return textField
    }()
    let textFieldDescription: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()

    let buttonContinue: UIButton = {
        let button = UIButton()
        button.setTitle("Planned", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
        return button
    }()
    let buttonOK: UIButton = {
        let button = UIButton()
        button.setTitle("Ok", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
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
        
        cardView.addSubview(imageBackground)
        
        imageBackground.anchor(top: cardView.topAnchor,
                               left: cardView.leftAnchor,
                               right: cardView.rightAnchor,
                               paddingTop: 20,paddingLeft: 20, paddingRight: 20)
        imageBackground.centerX(inView: cardView)
        
       
        cardView.addSubview(textFieldName)
        textFieldName.anchor(top: imageBackground.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        cardView.addSubview(textFieldCategory)
        textFieldCategory.anchor(top: textFieldName.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        cardView.addSubview(textFieldStartDate)
        textFieldStartDate.anchor(top: textFieldCategory.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        cardView.addSubview(textFieldAviable)
        textFieldAviable.anchor(top: textFieldStartDate.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        cardView.addSubview(textFieldFree)
        textFieldFree.anchor(top: textFieldAviable.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        cardView.addSubview(textFieldDescription)
        textFieldDescription.anchor(top: textFieldFree.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
   
        cardView.addSubview(buttonContinue)
        buttonContinue.anchor(top: textFieldDescription.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        cardView.addSubview(buttonOK)
        buttonOK.anchor(top: buttonContinue.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)

        
    }
}
