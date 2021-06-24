//
//  EditProfileCode.swift
//  FitMeet
//
//  Created by novotorica on 23.06.2021.
//

import Foundation
import UIKit
import iOSDropDown

final class EditProfileCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    var imageLogoProfile: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Group 17091")
        return image
    }()
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Profile"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    var labelFullName: UILabel = {
        let label = UILabel()
        label.text = "Full Name"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.boldSystemFont(ofSize: 12)
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
    var labelUserName: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
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
        label.text = "This username is taken, please choose diffrent."
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor(hexString: "#FF0000")
        label.textAlignment = .center
        return label
    }()
    var labelGender: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    let textGender: DropDown = {
        let textField = DropDown()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Gender", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    var labelBirthday: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    let textBirthday: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Birthday", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    var labelEmail: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    let textEmail: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    var labelPhoneNumber: UILabel = {
        let label = UILabel()
        label.text = "Phone Number"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    let textPhoneNumber: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Phone Number", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        return textField
    }()
    let labelSoshial: UILabel = {
        let label = UILabel()
        label.text = "Connect with Social Networks:"
        label.textColor = UIColor(hexString: "#868686")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    let imageTwitter: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Vector1-1")
        return image
    }()
    let buttonTwitter: UIButton = {
        let button = UIButton()
        button.setTitle("Connect with Facebook", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(hexString: "0099AE")
        return button
    }()
    let imageFacebook: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "facebook 21")
        return image
    }()
    let buttonFacebook: UIButton = {
        let button = UIButton()
        button.setTitle("Connect with Google", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(hexString: "0099AE")
        return button
    }()
    let imageGoogle: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Goole1")
        return image
    }()
    let buttonGoogle: UIButton = {
        let button = UIButton()
        button.setTitle("Connect with Twitter", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(hexString: "0099AE")
        return button
    }()
    
    let buttonSave : UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(hexString: "0099AE")
        return button
    }()
    let scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentSize.height = 1000
       // scroll.contentSize.width = 400
        scroll.backgroundColor = .white
        return scroll
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
        
        
      addSubview(scroll)
      scroll.fillFull(for: self)
      scroll.addSubview(cardView)
       
    }
    private func initLayout() {
       // cardView.fillSuperview()
       // cardView.fillFull(for: self)
        cardView.anchor(top: scroll.topAnchor,paddingTop: 0,width: 400)

        scroll.addSubview(imageLogoProfile)
        imageLogoProfile.anchor(top: cardView.topAnchor, left: cardView.leftAnchor,
                                paddingTop: 10, paddingLeft: 20, width: 80, height: 80)
        
        scroll.addSubview(welcomeLabel)
        welcomeLabel.anchor(left: imageLogoProfile.rightAnchor, paddingLeft: 10)
        welcomeLabel.centerY(inView: imageLogoProfile)

        
        scroll.addSubview(labelFullName)
        labelFullName.anchor(top: imageLogoProfile.bottomAnchor,
                             left: cardView.leftAnchor,
                             right: cardView.rightAnchor,
                             paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
     

        scroll.addSubview(textFieldName)
        textFieldName.anchor(top: labelFullName.bottomAnchor,
                              left: cardView.leftAnchor,
                              right:  cardView.rightAnchor,
                              paddingTop: 1, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(labelUserName)
        labelUserName.anchor(top: textFieldName.bottomAnchor,
                             left: cardView.leftAnchor,
                             right: cardView.rightAnchor,
                             paddingTop: 5, paddingLeft: 10, paddingRight: 10,height: 39)
     
        
        
        
        scroll.addSubview(textFieldUserName)
        textFieldUserName.anchor(top: labelUserName.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 1, paddingLeft: 10, paddingRight: 10,height: 39)
        
        textFieldUserName.addSubview(alertImage)
        alertImage.anchor( right: textFieldUserName.rightAnchor, paddingRight: 15)
        alertImage.centerY(inView: textFieldUserName)
        
        scroll.addSubview(alertLabel)
        alertLabel.anchor(top: textFieldUserName.bottomAnchor, paddingTop: 5)
        alertLabel.centerX(inView: cardView)
        
        
        scroll.addSubview(labelGender)
        labelGender.anchor(top: textFieldUserName.bottomAnchor,
                             left: cardView.leftAnchor,
                             right: cardView.rightAnchor,
                             paddingTop: 5, paddingLeft: 10, paddingRight: 10,height: 39)
     
        scroll.addSubview(textGender)
        textGender.anchor(top: labelGender.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 1, paddingLeft: 10, paddingRight: 10,height: 39)
        
        
        scroll.addSubview(labelBirthday)
        labelBirthday.anchor(top: textGender.bottomAnchor,
                             left: cardView.leftAnchor,
                             right: cardView.rightAnchor,
                             paddingTop: 5, paddingLeft: 10, paddingRight: 10,height: 39)
     
        scroll.addSubview(textBirthday)
        textBirthday.anchor(top: labelBirthday.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 1, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(labelEmail)
        labelEmail.anchor(top: textBirthday.bottomAnchor,
                             left: cardView.leftAnchor,
                             right: cardView.rightAnchor,
                             paddingTop: 5, paddingLeft: 10, paddingRight: 10,height: 39)
     
        scroll.addSubview(textEmail)
        textEmail.anchor(top: labelEmail.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 0, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(labelPhoneNumber)
        labelPhoneNumber.anchor(top: textEmail.bottomAnchor,
                             left: cardView.leftAnchor,
                             right: cardView.rightAnchor,
                             paddingTop: 5, paddingLeft: 10, paddingRight: 10,height: 39)
     
        scroll.addSubview(textPhoneNumber)
        textPhoneNumber.anchor(top: labelPhoneNumber.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 0, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(labelSoshial)
        labelSoshial.anchor(top: textPhoneNumber.bottomAnchor,
                     left: cardView.leftAnchor,
                     paddingTop: 15, paddingLeft: 10)

        scroll.addSubview(buttonTwitter)
        buttonTwitter.anchor(top: labelSoshial.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        buttonTwitter.addSubview(imageTwitter)
        imageTwitter.anchor(left: buttonTwitter.leftAnchor, paddingLeft: 30)
        imageTwitter.centerY(inView: buttonTwitter)
        
        scroll.addSubview(buttonFacebook)
        buttonFacebook.anchor(top: buttonTwitter.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        buttonFacebook.addSubview(imageFacebook)
        imageFacebook.anchor(left: buttonFacebook.leftAnchor, paddingLeft: 30)
        imageFacebook.centerY(inView: buttonFacebook)
        
        scroll.addSubview(buttonGoogle)
        buttonGoogle.anchor(top: buttonFacebook.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        buttonGoogle.addSubview(imageGoogle)
        imageGoogle.anchor(left: buttonGoogle.leftAnchor, paddingLeft: 30)
        imageGoogle.centerY(inView: buttonGoogle)
        
        scroll.addSubview(buttonSave)
        buttonSave.anchor(top: buttonGoogle.bottomAnchor, paddingTop: 30, width: 137)
        buttonSave.centerX(inView: cardView)

        
    }
}
