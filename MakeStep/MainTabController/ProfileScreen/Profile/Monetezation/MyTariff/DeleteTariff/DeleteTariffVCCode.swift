//
//  DeleteTariffVCCode.swift
//  MakeStep
//
//  Created by Sergey on 07.11.2021.
//

import Foundation
import UIKit



final class DeleteTariffVCCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var buttonCloseChat: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8"), for: .normal)
        return button
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Delete tariff"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Are you sure you want to delete this tariff?"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.init(hexString: "#868686")
        return label
    }()
    var buttonNo: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#3B58A4")
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
        buttonYes.anchor(top: buttonNo.bottomAnchor, paddingTop: 22, width: 102, height: 28)
        buttonYes.centerX(inView: cardView)
        
 
    }
   
}
