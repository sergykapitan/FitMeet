//
//  AddedVideoCode.swift
//  MakeStep
//
//  Created by Sergey on 07.02.2022.
//

import Foundation
import UIKit
import iOSDropDown
import TagListView

final class AddedVideoCode: UIView {
    
    //MARK: - UI
    let buttonUploadVideo: UIButton = {
        let button = UIButton()
        button.setTitle(" Upload Video ", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = .blueColor
        return button
    }()
    var resetVideo: UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named: "x1"), for: .normal)
        but.isHidden = true
        return but
    }()
    var labelNameVOD: UILabel = {
        let label = UILabel()
        label.text = "file.mp4"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        label.isHidden = true
        return label
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
        textField.attributedPlaceholder =
        NSAttributedString(string: "Category", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        textField.clipsToBounds = true
        textField.selectedRowColor = UIColor(hexString: "F9F9F9")
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
        textField.selectedRowColor = UIColor(hexString: "F9F9F9")
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
        button.backgroundColor = .blueColor.alpha(0.4)
        return button
    }()
    let buttonOK: UIButton = {
        let button = UIButton()
        button.setTitle("Ok", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = .blueColor.alpha(0.4)
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
 
    }
    private func initLayout() {

        scroll.addSubview(buttonUploadVideo)
        buttonUploadVideo.anchor(top: scroll.topAnchor, left: scroll.leftAnchor,  paddingTop: 20, paddingLeft: 10,width: 130,  height: 36)
        
        scroll.addSubview(labelNameVOD)
        labelNameVOD.anchor(top: scroll.topAnchor, left: scroll.leftAnchor,right: scroll.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 40)
        
        scroll.addSubview(resetVideo)
        resetVideo.anchor(left: labelNameVOD.rightAnchor, paddingLeft: 5, width: 20, height: 20)
        resetVideo.centerY(inView: labelNameVOD)
        
        scroll.addSubview(imageButton)
        imageButton.anchor(top: buttonUploadVideo.bottomAnchor,
                               left: scroll.leftAnchor,
                               right: scroll.rightAnchor,
                               paddingTop: 20,paddingLeft: 10, paddingRight: 10,height: 160)
        imageButton.centerX(inView: scroll)

        scroll.addSubview(textFieldName)
        textFieldName.anchor(top: imageButton.bottomAnchor,
                              left: scroll.leftAnchor,
                              right: scroll.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(textFieldCategory)
        textFieldCategory.anchor(top: textFieldName.bottomAnchor,
                              left: scroll.leftAnchor,
                              right: scroll.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10)
        
        scroll.addSubview(textFieldAviable)
        textFieldAviable.anchor(top: textFieldCategory.bottomAnchor,
                              left: scroll.leftAnchor,
                              right: scroll.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(textFieldFree)
        textFieldFree.anchor(top: textFieldAviable.bottomAnchor,
                              left: scroll.leftAnchor,
                              right: scroll.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(textFieldDescription)
        textFieldDescription.anchor(
                              left: scroll.leftAnchor,
                              right: scroll.rightAnchor,
                               paddingLeft: 10, paddingRight: 10,height: 39)
        
        scroll.addSubview(buttonOK)
        buttonOK.anchor(top: textFieldDescription.bottomAnchor,
                              left: scroll.leftAnchor,
                              right: scroll.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        textFieldCategory.addSubview(tagView)
        tagView.anchor(top:textFieldCategory.topAnchor,
                       left: textFieldCategory.leftAnchor,
                       right: textFieldCategory.rightAnchor,
                       bottom: textFieldCategory.bottomAnchor,
                       paddingTop: 5,paddingLeft: 10, paddingRight: 40,paddingBottom: 5)
 
    }
}
