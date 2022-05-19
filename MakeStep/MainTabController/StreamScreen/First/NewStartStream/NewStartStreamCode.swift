//
//  NewStartStreamCode.swift
//  FitMeet
//
//  Created by novotorica on 18.06.2021.
//

import Foundation
import UIKit
import iOSDropDown
import TagListView

final class NewStartStreamCode: UIView {
    
    //MARK: - UI
    let capturePreviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
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
    let textFieldStartDate: DropDown = {
        let textField = DropDown()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Start now ", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "000000")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        textField.selectedRowColor = UIColor(hexString: "F9F9F9")
        return textField
    }()
    let textFieldAviable: DropDown = {
        let textField = DropDown()
        textField.layer.cornerRadius = 19
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
        NSAttributedString(string: "Available for all", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "000000")])
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
        button.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
        return button
    }()
    let buttonOK: UIButton = {
        let button = UIButton()
        button.setTitle("Start stream", for: .normal)
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
       // addSubview(scroll)
       // scroll.fillFull(for: self)
        addSubview(capturePreviewView)
        capturePreviewView.fillFull(for: self)
    }
    private func initLayout() {
 
        capturePreviewView.addSubview(imageButton)
        imageButton.anchor(top: capturePreviewView.topAnchor,
                               left: capturePreviewView.leftAnchor,
                                paddingTop: 20,paddingLeft: 10,width: 130,height: 82.5)
    //    imageButton.centerX(inView: scroll)

//        scroll.addSubview(textFieldName)
//        textFieldName.anchor(top: imageButton.bottomAnchor,
//                              left: scroll.leftAnchor,
//                              right: scroll.rightAnchor,
//                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        capturePreviewView.addSubview(textFieldCategory)
        textFieldCategory.anchor(top: imageButton.bottomAnchor,
                              left: capturePreviewView.leftAnchor,
                              right: capturePreviewView.rightAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10)
        
//        scroll.addSubview(textFieldStartDate)
//        textFieldStartDate.anchor(top: textFieldCategory.bottomAnchor,
//                              left: scroll.leftAnchor,
//                              right: scroll.rightAnchor,
//                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
//
//        scroll.addSubview(textFieldAviable)
//        textFieldAviable.anchor(top: textFieldStartDate.bottomAnchor,
//                              left: scroll.leftAnchor,
//                              right: scroll.rightAnchor,
//                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
//
//        scroll.addSubview(textFieldFree)
//        textFieldFree.anchor(top: textFieldAviable.bottomAnchor,
//                              left: scroll.leftAnchor,
//                              right: scroll.rightAnchor,
//                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        capturePreviewView.addSubview(textFieldDescription)
        textFieldDescription.anchor(top: textFieldCategory.bottomAnchor,
                              left: capturePreviewView.leftAnchor,
                              right: capturePreviewView.rightAnchor,
                              
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,height: 39)
        
        capturePreviewView.addSubview(buttonOK)
        buttonOK.anchor(top: textFieldDescription.bottomAnchor,
                              left: capturePreviewView.leftAnchor,
                              right: capturePreviewView.rightAnchor,
                        bottom: capturePreviewView.bottomAnchor,
                              paddingTop: 15, paddingLeft: 10, paddingRight: 10,paddingBottom: 0,height: 39)
        textFieldCategory.addSubview(tagView)
        tagView.anchor(top:textFieldCategory.topAnchor,
                       left: textFieldCategory.leftAnchor,
                       right: textFieldCategory.rightAnchor,
                       bottom: textFieldCategory.bottomAnchor,
                       paddingTop: 5,paddingLeft: 10, paddingRight: 40,paddingBottom: 5)
    }
}
