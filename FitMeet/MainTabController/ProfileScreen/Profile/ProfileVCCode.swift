//
//  ProfileVCCode.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import UIKit

final class ProfileVCCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let labelSignUp: UILabel = {
        let label = UILabel()
        label.text = "PROFILE USER"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    let buttonLogOut: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        return button
        
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
        
        cardView.addSubview(labelSignUp)
        labelSignUp.anchor(top: cardView.topAnchor,
                           paddingTop: 46)
        labelSignUp.centerX(inView: cardView)
        
        cardView.addSubview(buttonLogOut)
        buttonLogOut.centerX(inView: cardView)
        buttonLogOut.anchor(bottom: cardView.bottomAnchor,
                           paddingBottom: 50, width: 50,height: 40)
    }
}
