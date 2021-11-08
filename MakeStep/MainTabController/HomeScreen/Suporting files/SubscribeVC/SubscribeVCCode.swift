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
   
    var buttonProduct: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#F4F4F4")
        button.layer.cornerRadius = 30
        return button
    }()
    var labelProduct: UILabel = {
        var label = UILabel()
        label.text = "1 Month"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    var labelProductPrice: UILabel = {
        var label = UILabel()
        label.text = "$ 5.99"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    var buttonPay: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#3B58A4")
        button.setTitle(" Pay ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 30
        return button
    }()
    var labelTotal: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Total payable $ 0.0"
        return label
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
        
        
        cardView.addSubview(buttonProduct)
        buttonProduct.anchor(top: descriptionLabel.bottomAnchor,left:cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 16,paddingLeft:16,paddingRight: 16,height: 61)
        buttonProduct.centerX(inView: cardView)
        
        buttonProduct.addSubview(labelProduct)
        labelProduct.anchor(left: buttonProduct.leftAnchor, paddingLeft: 30)
        labelProduct.centerY(inView: buttonProduct)
        
        buttonProduct.addSubview(labelProductPrice)
        labelProductPrice.anchor( right: buttonProduct.rightAnchor, paddingRight: 30)
        labelProductPrice.centerY(inView: buttonProduct)
        
        
        cardView.addSubview(buttonPay)
        buttonPay.anchor(left:cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor,paddingLeft:16, paddingRight: 16, paddingBottom: 16, height: 61)
        buttonPay.centerX(inView: cardView)
        
        cardView.addSubview(labelTotal)
        labelTotal.anchor( right: cardView.rightAnchor, bottom: buttonPay.topAnchor, paddingRight: 16, paddingBottom: 16 )
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

