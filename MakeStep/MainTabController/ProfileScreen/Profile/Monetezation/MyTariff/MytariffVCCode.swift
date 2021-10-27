//
//  LandscapeVCCode.swift
//  MakeStep
//
//  Created by Sergey on 26.10.2021.
//


import Foundation
import UIKit


final class MytariffVCCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let buttonAddNewMonet: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "AddNewMonet"), for: .normal)
        return btn
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
        
        cardView.addSubview(buttonAddNewMonet)
        buttonAddNewMonet.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
 
    }
   
}
