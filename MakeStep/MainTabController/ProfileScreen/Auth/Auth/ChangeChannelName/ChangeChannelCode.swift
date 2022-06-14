//
//  ChangeChannelCode.swift
//  MakeStep
//
//  Created by Sergey on 09.06.2022.
//


import Foundation
import UIKit
import TagListView
import iOSDropDown


final class ChangeChannelCode: UIView {
    
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
    let buttonOK: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 19
        button.backgroundColor = .blueColor
        return button
    }()
//    let scroll: UIScrollView = {
//        let scroll = UIScrollView()
//        scroll.translatesAutoresizingMaskIntoConstraints = false
//        scroll.contentSize.height = 1000
//        scroll.backgroundColor = .white
//        return scroll
//    }()
   
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
        cardView.fillFull(for: self)
    }
    private func initLayout() {
       
        cardView.addSubview(labelNameOfChannel)
        cardView.addSubview(textViewNameofCHannel)
        cardView.addSubview(buttonOK)

    }
}
