//
//  TopViewCapture.swift
//  MakeStep
//
//  Created by Sergey on 15.06.2022.
//

import UIKit

final class TopViewCapture : UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
  
    let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [ UIColor(red: 0.008, green: 0.008, blue: 0.008, alpha: 1).cgColor, UIColor(red: 0.183, green: 0.183, blue: 0.183, alpha: 0).cgColor]
        gradient.type = .axial
        return gradient
    }()
    let buttonStart: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .blueColor
        btn.setTitle("  Stop Stream  ", for: .normal)
        btn.titleLabel?.font  = UIFont(name: "SFProText-Semibold", size: 14)
        btn.layer.cornerRadius = 7
        return btn
    }()
    let usrButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "onlineUser"), for: .normal)
        return button
    }()
    let muteUser: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName:"volumeUser"), for: .normal)
        return button
    }()
    let viewUser: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "viewUser"), for: .normal)
        return button
    }()
    let collectionUser: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "view_module"), for: .normal)
        return button
    }()
    var userLabel: UILabel = {
        let label = UILabel()
        label.text = "12"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
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
        addSubview(cardView)
        
    }
    private func initLayout() {
        cardView.fillSuperview()
        cardView.layer.addSublayer(gradientLayer)
        
        cardView.addSubview(buttonStart)
        buttonStart.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 53, paddingLeft: 16, width: 110, height: 28)
        
        cardView.addSubview(muteUser)
        muteUser.anchor(right: cardView.rightAnchor, paddingRight: 15, width: 40, height: 40)
        muteUser.centerY(inView: buttonStart)
        
        cardView.addSubview(viewUser)
        viewUser.anchor(right: muteUser.leftAnchor, paddingRight: 8, width: 40, height: 40)
        viewUser.centerY(inView: buttonStart)
        
        cardView.addSubview(collectionUser)
        collectionUser.anchor(right: viewUser.leftAnchor , paddingRight: 19)
        collectionUser.centerY(inView: buttonStart)
        
        cardView.addSubview(usrButton)
        usrButton.anchor( right: cardView.centerXAnchor,  paddingRight: 0)
        usrButton.centerY(inView: buttonStart)
        
        cardView.addSubview(userLabel)
        userLabel.anchor( left: cardView.centerXAnchor, paddingLeft: 0)
        userLabel.centerY(inView: buttonStart)
            
    }
}
