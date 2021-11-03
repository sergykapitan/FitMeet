//
//  SubscribeVCCode.swift
//  MakeStep
//
//  Created by Sergey on 03.11.2021.
//

import Foundation
import UIKit


final class SubscribeVCCode: UIView {

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
        label.text = "Pick your plan"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    var descriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "Please select three of our plans to suit you"
        label.textColor = UIColor(hexString: "#9F9F9F")
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
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
        
        cardView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, paddingTop: 8)
        descriptionLabel.centerX(inView: cardView)
        
        
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

