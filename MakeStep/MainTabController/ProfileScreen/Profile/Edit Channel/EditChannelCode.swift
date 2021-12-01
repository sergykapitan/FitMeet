//
//  EditChannelCode.swift
//  MakeStep
//
//  Created by Sergey on 11.10.2021.
//


import Foundation
import UIKit
import TagListView
import iOSDropDown


final class EditChannelCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let labelNameOfChannel: UILabel = {
        let label = UILabel()
        label.text = "Name of Channel"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let textViewNameofCHannel: UITextView = {
        let tv = UITextView()
        return tv
    }()
    let labelDescription: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let textViewDescription: UITextView = {
        let tv = UITextView()
        return tv
    }()
    let labelPhotoBackground: UILabel = {
        let label = UILabel()
        label.text = "Photo Background"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let textViewPhotoBackground: UITextView = {
        let tv = UITextView()
        return tv
    }()
    let labelFaceBook: UILabel = {
        let label = UILabel()
        label.text = "Facebook"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let textViewFaceboook: UITextView = {
        let tv = UITextView()
        return tv
    }()
    let labelInstagram: UILabel = {
        let label = UILabel()
        label.text = "Instagram"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let textViewInstagram: UITextView = {
        let tv = UITextView()
        return tv
    }()
    let labelTwitter: UILabel = {
        let label = UILabel()
        label.text = "Twitter"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let textViewTwitter: UITextView = {
        let tv = UITextView()
        return tv
    }()
    let labelFavoriteCategories: UILabel = {
        let label = UILabel()
        label.text = "Favorite Categories"
        label.textColor = UIColor(hexString: "#999999")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let textViewFavoriteCategories: DropDown = {
        let tv = DropDown()
        tv.layer.cornerRadius = 19
        tv.backgroundColor = UIColor(hexString: "F9F9F9")
        tv.attributedPlaceholder =
            NSAttributedString(string: "Available for...", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "BBBCBC")])
        tv.setLeftPaddingPoints(25)
        tv.textColor = .black
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        tv.clipsToBounds = true
        tv.selectedRowColor = UIColor(hexString: "F9F9F9")
        return tv
    }()

    let buttonOK: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(hexString: "#3B58A4")
        return button
    }()
    let scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentSize.height = 1000
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
        
        scroll.addSubview(labelNameOfChannel)
        scroll.addSubview(textViewNameofCHannel)
        scroll.addSubview(labelDescription)
        scroll.addSubview(textViewDescription)
        scroll.addSubview(labelPhotoBackground)
        scroll.addSubview(textViewPhotoBackground)
        scroll.addSubview(labelPhotoBackground)
        scroll.addSubview(textViewPhotoBackground)
        scroll.addSubview(labelFaceBook)
        scroll.addSubview(textViewFaceboook)
        scroll.addSubview(labelInstagram)
        scroll.addSubview(textViewInstagram)
        scroll.addSubview(labelTwitter)
        scroll.addSubview(textViewTwitter)
        scroll.addSubview(labelFavoriteCategories)
        scroll.addSubview(textViewFavoriteCategories)
        scroll.addSubview(tagView)
        scroll.addSubview(buttonOK)

    }
}
