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
        view.layer.cornerRadius = 30
        return view
    }()
    var butH: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let labelSettings: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    let imageButton: UIButton = {
        let button = UIButton(type: .custom)
        //button.setBackgroundImage(#imageLiteral(resourceName: "Rectangle"), for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()

    let textFieldCategory: DropDown = {
        let textField = DropDown()      
        textField.layer.cornerRadius = 23
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

    let textFieldDescription: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 23
        textField.backgroundColor = UIColor(hexString: "F9F9F9")
        textField.attributedPlaceholder =
            NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        textField.setLeftPaddingPoints(25)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        textField.clipsToBounds = true
        return textField
    }()
    let spinner: IMProgressHUD = {
        let hud = IMProgressHUD()
        hud.configuration.isUserInteractionEnabled = false
        hud.configuration.contentInsets = .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        hud.configuration.cornerRadius = 8.0
        hud.configuration.backgroundColor = .clear
        hud.configuration.color = .clear
        hud.configuration.indicatorSize = CGSize(width: 18.0, height: 18.0)
        hud.configuration.lineWidth = 2.0
        hud.configuration.dimmingColor = .clear
        hud.configuration.indicatorColor = .lightGray    
        hud.axis = .horizontal
        hud.setActivity(.circle)
       // hud.hide()
        
        hud.translatesAutoresizingMaskIntoConstraints = false
        return hud
    }()
    let labelSaved: UILabel = {
        let label = UILabel()
        label.text = "Saved"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.alpha = 0
        return label
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
        addSubview(capturePreviewView)
        capturePreviewView.fillFull(for: self)
        capturePreviewView.addSubview(butH)
        butH.setContentHuggingPriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            butH.centerXAnchor.constraint(equalTo: capturePreviewView.centerXAnchor),
            butH.topAnchor.constraint(equalTo: capturePreviewView.topAnchor, constant: 0),
            butH.heightAnchor.constraint(equalToConstant:35),
            butH.widthAnchor.constraint(equalToConstant: 45)
           
        ])
    }
    private func initLayout() {
        capturePreviewView.addSubview(labelSettings)
        labelSettings.anchor(top: butH.bottomAnchor,
                             left: capturePreviewView.leftAnchor,
                              paddingTop: 20,paddingLeft: 10)
        capturePreviewView.addSubview(spinner)
        spinner.centerY(inView: labelSettings)
        spinner.anchor(right: capturePreviewView.rightAnchor, paddingRight: 20)
        spinner.alpha = 0
        
        capturePreviewView.addSubview(labelSaved)
        labelSaved.centerY(inView: labelSettings)
        labelSaved.anchor(right: capturePreviewView.rightAnchor, paddingRight: 20)
        
        capturePreviewView.addSubview(imageButton)
        imageButton.anchor(top: labelSettings.bottomAnchor,
                               left: capturePreviewView.leftAnchor,
                                paddingTop: 20,paddingLeft: 10,width: 130,height: 82.5)
  
        capturePreviewView.addSubview(textFieldCategory)
        textFieldCategory.anchor(top: imageButton.bottomAnchor,
                              left: capturePreviewView.leftAnchor,
                              right: capturePreviewView.rightAnchor,
                              paddingTop: 23, paddingLeft: 10, paddingRight: 10)
        
        capturePreviewView.addSubview(textFieldDescription)
        textFieldDescription.anchor(top: textFieldCategory.bottomAnchor,
                              left: capturePreviewView.leftAnchor,
                              right: capturePreviewView.rightAnchor,
                              bottom: capturePreviewView.bottomAnchor,
                              paddingTop: 27, paddingLeft: 10, paddingRight: 10,paddingBottom: 30)
        textFieldCategory.addSubview(tagView)
        tagView.anchor(top:textFieldCategory.topAnchor,
                       left: textFieldCategory.leftAnchor,
                       right: textFieldCategory.rightAnchor,
                       bottom: textFieldCategory.bottomAnchor,
                       paddingTop: 5,paddingLeft: 10, paddingRight: 40,paddingBottom: 5)
    }
}
