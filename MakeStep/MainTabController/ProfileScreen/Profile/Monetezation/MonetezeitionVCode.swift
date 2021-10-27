//
//  MonetezeitionVCode.swift
//  MakeStep
//
//  Created by Sergey on 27.10.2021.
//

import Foundation
import UIKit


final class MonetezeitionVCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let selfView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    var buttonMytariffs: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle(" My tariffs ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 15
        return button
    }()
    var buttonIncomecalculator: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle(" Income calculator ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 15
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
        
        cardView.addSubview(buttonMytariffs)
        buttonMytariffs.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        cardView.addSubview(buttonIncomecalculator)
        buttonIncomecalculator.anchor(top: cardView.topAnchor, left: buttonMytariffs.rightAnchor, paddingTop: 20, paddingLeft: 14)
        
        cardView.addSubview(selfView)
        selfView.anchor(top: buttonMytariffs.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 20, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
 
    }
   
}
