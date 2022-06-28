//
//  DisableTariffCode.swift
//  MakeStep
//
//  Created by Sergey on 28.06.2022.
//

import Foundation
import UIKit



final class DisableTariffCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    var buttonCloseChat: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8"), for: .normal)
        return button
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Disable tariff"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Are you sure you want to disable the tariff?"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.init(hexString: "#868686")
        return label
    }()
    var buttonNo: UIButton = {
        var button = UIButton()
        button.backgroundColor = .blueColor
        button.setTitle(" No ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 14
        return button
    }()
    var buttonYes: UIButton = {
        var button = UIButton()
        button.setTitle(" Yes ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.init(hexString: "#3B58A4"), for: .normal)
        button.layer.cornerRadius = 14
        return button
    }()
   
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        initUI()
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        addSubview(cardView)
        cardView.fillSuperview()
        
        cardView.addSubview(buttonCloseChat)
        buttonCloseChat.anchor( top: cardView.topAnchor,paddingTop: 0,width: 40, height: 30)
        buttonCloseChat.centerX(inView: cardView)
        
        cardView.addSubview(titleLabel)
        titleLabel.anchor(top: cardView.topAnchor, paddingTop: 38)
        titleLabel.centerX(inView: cardView)
        
        cardView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, paddingTop: 18)
        descriptionLabel.centerX(inView: cardView)
        
        cardView.addSubview(buttonNo)
        buttonNo.anchor(top: descriptionLabel.bottomAnchor, paddingTop: 22, width: 102, height: 28)
        buttonNo.centerX(inView: cardView)
        
        cardView.addSubview(buttonYes)
        buttonYes.anchor(top: buttonNo.bottomAnchor,bottom: cardView.bottomAnchor, paddingTop: 22,paddingBottom: 10, width: 102, height: 28)
        buttonYes.centerX(inView: cardView)
        
 
    }
   
}
