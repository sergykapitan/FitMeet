//
//  EditProfileCode.swift
//  FitMeet
//
//  Created by novotorica on 23.06.2021.
//

import Foundation
import UIKit
import iOSDropDown
import Kingfisher

final class EditProfileCode: UIView {
    
    //MARK: - UI
    let imageButtonss: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "Rectangle 966gggg"), for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    var imageLogoProfile: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Group 17091")
        return image
    }()
    let imageRed: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "redProfile")
        image.clipsToBounds = false
        return image
    }()
    var imageButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.borderWidth = 0.2
        button.layer.masksToBounds = false
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 40
        return button
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
        button.setTitle("Connect with Twitter", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(hexString: "#3B58A4")
        return button
    }()
    let imageFacebook: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "facebook 21")
        return image
    }()
    let buttonFacebook: UIButton = {
        let button = UIButton()
        button.setTitle("Connect with Facebook", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(hexString: "#3B58A4")
        return button
    }()
    let imageGoogle: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Goole1-1")
        return image
    }()
    let buttonGoogle: UIButton = {
        let button = UIButton()
        button.setTitle("Connect with Google", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(hexString: "#3B58A4")
        return button
    }()
    let buttonSave : UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = .blueColor
        return button
    }()
    let scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
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
       
    }
    private func initLayout() {
        scroll.addSubview(imageButton)
        imageButton.anchor(top: scroll.topAnchor, left: scroll.leftAnchor,
                                paddingTop: 10, paddingLeft: 20, width: 80, height: 80)
        
        scroll.addSubview(imageRed)
        imageRed.anchor( right: imageButton.rightAnchor, bottom: imageButton.bottomAnchor, paddingRight: -5, paddingBottom: -5, width: 30, height: 30)
        
        scroll.addSubview(welcomeLabel)
        welcomeLabel.anchor(left: imageButton.rightAnchor, paddingLeft: 10)
        welcomeLabel.centerY(inView: imageButton)

        
        scroll.addSubview(labelFullName)
        labelFullName.anchor(top: imageButton.bottomAnchor,
                             left: scroll.leftAnchor,
                             right: scroll.rightAnchor,
                             paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
     

        scroll.addSubview(textFieldName)
        textFieldName.anchor(top: labelFullName.bottomAnchor,
                              left: scroll.leftAnchor,
                              right:  scroll.rightAnchor,
                              paddingTop: 1, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(labelUserName)
        labelUserName.anchor(top: textFieldName.bottomAnchor,
                             left: scroll.leftAnchor,
                             right: scroll.rightAnchor,
                             paddingTop: 5, paddingLeft: 10, paddingRight: 10,height: 39)
     
        
        
        
        scroll.addSubview(textFieldUserName)
        textFieldUserName.anchor(top: labelUserName.bottomAnchor,
                              left: scroll.leftAnchor,
                              right: scroll.rightAnchor,
                              paddingTop: 1, paddingLeft: 10, paddingRight: 10,height: 39)
        
        textFieldUserName.addSubview(alertImage)
        alertImage.anchor( right: textFieldUserName.rightAnchor, paddingRight: 15)
        alertImage.centerY(inView: textFieldUserName)
        
        scroll.addSubview(alertLabel)
        alertLabel.anchor(top: textFieldUserName.bottomAnchor, paddingTop: 5)
        alertLabel.centerX(inView: scroll)
        
        
        scroll.addSubview(labelGender)
        labelGender.anchor(top: textFieldUserName.bottomAnchor,
                             left: scroll.leftAnchor,
                             right: scroll.rightAnchor,
                             paddingTop: 5, paddingLeft: 10, paddingRight: 10,height: 39)
     
        scroll.addSubview(textGender)
        textGender.anchor(top: labelGender.bottomAnchor,
                              left: scroll.leftAnchor,
                              right: scroll.rightAnchor,
                              paddingTop: 1, paddingLeft: 10, paddingRight: 10,height: 39)
        
        
        scroll.addSubview(labelBirthday)
        labelBirthday.anchor(top: textGender.bottomAnchor,
                             left: scroll.leftAnchor,
                             right: scroll.rightAnchor,
                             paddingTop: 5, paddingLeft: 10, paddingRight: 10,height: 39)
     
        scroll.addSubview(textBirthday)
        textBirthday.anchor(top: labelBirthday.bottomAnchor,
                              left: scroll.leftAnchor,
                              right: scroll.rightAnchor,
                              paddingTop: 1, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(labelEmail)
        labelEmail.anchor(top: textBirthday.bottomAnchor,
                             left: scroll.leftAnchor,
                             right: scroll.rightAnchor,
                             paddingTop: 5, paddingLeft: 10, paddingRight: 10,height: 39)
     
        scroll.addSubview(textEmail)
        textEmail.anchor(top: labelEmail.bottomAnchor,
                              left: scroll.leftAnchor,
                              right: scroll.rightAnchor,
                              paddingTop: 0, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(labelPhoneNumber)
        labelPhoneNumber.anchor(top: textEmail.bottomAnchor,
                             left: scroll.leftAnchor,
                             right: scroll.rightAnchor,
                             paddingTop: 5, paddingLeft: 10, paddingRight: 10,height: 39)
     
        scroll.addSubview(textPhoneNumber)
        textPhoneNumber.anchor(top: labelPhoneNumber.bottomAnchor,
                              left: scroll.leftAnchor,
                              right: scroll.rightAnchor,
                              paddingTop: 0, paddingLeft: 10, paddingRight: 10,height: 39)
        
//        scroll.addSubview(labelSoshial)
//        labelSoshial.anchor(top: textPhoneNumber.bottomAnchor,
//                     left: cardView.leftAnchor,
//                     paddingTop: 15, paddingLeft: 10)
//
//        scroll.addSubview(buttonTwitter)
//        buttonTwitter.anchor(top: labelSoshial.bottomAnchor,
//                              left: cardView.leftAnchor,
//                              right: cardView.rightAnchor,
//                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
//        buttonTwitter.addSubview(imageTwitter)
//        imageTwitter.anchor(left: buttonTwitter.leftAnchor, paddingLeft: 30)
//        imageTwitter.centerY(inView: buttonTwitter)
//
//        scroll.addSubview(buttonFacebook)
//        buttonFacebook.anchor(top: buttonTwitter.bottomAnchor,
//                              left: cardView.leftAnchor,
//                              right: cardView.rightAnchor,
//                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
//        buttonFacebook.addSubview(imageFacebook)
//        imageFacebook.anchor(left: buttonFacebook.leftAnchor, paddingLeft: 30)
//        imageFacebook.centerY(inView: buttonFacebook)
//
//        scroll.addSubview(buttonGoogle)
//        buttonGoogle.anchor(top: buttonFacebook.bottomAnchor,
//                              left: cardView.leftAnchor,
//                              right: cardView.rightAnchor,
//                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
//        buttonGoogle.addSubview(imageGoogle)
//        imageGoogle.anchor(left: buttonGoogle.leftAnchor, paddingLeft: 30)
//        imageGoogle.centerY(inView: buttonGoogle)
        
        scroll.addSubview(buttonSave)
        buttonSave.anchor(top: textPhoneNumber.bottomAnchor, paddingTop: 30, width: 137)
        buttonSave.centerX(inView: scroll)
        
        scroll.addSubview(imageButtonss)
        imageButtonss.anchor(top: buttonSave.bottomAnchor,
                               left: scroll.leftAnchor,
                               right: scroll.rightAnchor,
                               paddingTop: 20,paddingLeft: 10, paddingRight: 10,height: 1)
        imageButtonss.centerX(inView: scroll)

        
    }
    
    func setImageLogo(image:String) {
        let url = URL(string: image)
        imageLogoProfile.kf.setImage(with: url)
 
        //imageButton.imageView?.kf.setImage(with: url)
        imageButton.setImage(imageLogoProfile.image, for: .normal)
       
    }
    
    
}
