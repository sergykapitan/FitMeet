//
//  EditStreamCode.swift
//  MakeStep
//
//  Created by novotorica on 30.09.2021.
//

import Foundation
import UIKit
import iOSDropDown
import TagListView

final class EditStreamCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let imageButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "Rectangle 966gggg"), for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
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
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        textField.selectedRowColor = UIColor(hexString: "F9F9F9")
        return textField
    }()
//    let textFieldStartDate: DropDown = {
//        let textField = DropDown()
//        textField.layer.cornerRadius = 19
//        textField.backgroundColor = UIColor(hexString: "F9F9F9")
//        textField.attributedPlaceholder =
//            NSAttributedString(string: "Start Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
//        textField.setLeftPaddingPoints(25)
//        textField.textColor = .black
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
//        textField.selectedRowColor = UIColor(hexString: "F9F9F9")
//        return textField
//    }()
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
        textField.selectedRowColor = UIColor(hexString: "F9F9F9")
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
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = .blueColor
        return button
    }()
    let scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentSize.height = 800
        scroll.backgroundColor = .white
        return scroll
    }()
    var tagView: TagListView = {
        let tag = TagListView()
        tag.textFont = UIFont.systemFont(ofSize: 18)
        tag.cornerRadius = 15
        tag.enableRemoveButton = true
        tag.removeIconLineColor = .black
        tag.removeButtonIconSize = 10
        tag.tagBackgroundColor = UIColor(hexString: "#E5E5E5")
        tag.textColor = .black
        tag.paddingX = 10
        tag.paddingY = 5
        tag.selectedTextColor = .black
        return tag
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
        cardView.anchor(top: scroll.topAnchor,paddingTop: 0)
        
        scroll.addSubview(imageButton)
        imageButton.anchor(top: cardView.topAnchor,
                               left: cardView.leftAnchor,
                               right: cardView.rightAnchor,
                               paddingTop: 20,paddingLeft: 10, paddingRight: 10,height: 160)
        imageButton.centerX(inView: cardView)

        scroll.addSubview(textFieldName)
        textFieldName.anchor(top: imageButton.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(textFieldCategory)
        textFieldCategory.anchor(top: textFieldName.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10)
        
//        scroll.addSubview(textFieldStartDate)
//        textFieldStartDate.anchor(top: textFieldCategory.bottomAnchor,
//                              left: cardView.leftAnchor,
//                              right: cardView.rightAnchor,
//                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(textFieldAviable)
        textFieldAviable.anchor(top: textFieldCategory.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        
        scroll.addSubview(textFieldDescription)
        textFieldDescription.anchor(top: textFieldAviable.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(buttonOK)
        buttonOK.anchor(top: textFieldDescription.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        textFieldCategory.addSubview(tagView)
        tagView.anchor(top:textFieldCategory.topAnchor,
                       left: textFieldCategory.leftAnchor,
                       right: textFieldCategory.rightAnchor,
                       bottom: textFieldCategory.bottomAnchor,
                       paddingTop: 5,paddingLeft: 10, paddingRight: 40,paddingBottom: 5)

        
    }
}
