//
//  NotInternetViewCode.swift
//  MakeStep
//
//  Created by Sergey on 18.04.2022.
//

import Foundation
import UIKit


final class NotInternetViewCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F9FAFC")
        return view
    }()
    let imageView: UIImageView = {
        let imgeView = UIImageView()
        imgeView.translatesAutoresizingMaskIntoConstraints = false
        imgeView.image = UIImage(named: "notInternet")
        return imgeView
    }()
    let labelOps: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ooops!"
        label.textColor = UIColor(hexString: "#37474F")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    let labelCheck: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You’re offline. Check your connection."
        label.textColor = UIColor(hexString: "#37474F")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    let butTryAgain: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blueColor
        button.setTitle("TRY AGAIN", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        button.layer.cornerRadius = 21
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
        
        cardView.addSubview(imageView)
        imageView.centerX(inView: cardView)
        imageView.anchor( bottom: cardView.centerYAnchor,paddingBottom: 5)
        
        cardView.addSubview(butTryAgain)
        butTryAgain.centerX(inView: cardView)
        butTryAgain.anchor(bottom: cardView.bottomAnchor, paddingBottom: 80,width: 158, height: 42)
        
        cardView.addSubview(labelCheck)
        labelCheck.centerX(inView: cardView)
        labelCheck.anchor( bottom: butTryAgain.topAnchor, paddingBottom: 47 )
        
        cardView.addSubview(labelOps)
        labelOps.centerX(inView: cardView)
        labelOps.anchor( bottom: labelCheck.topAnchor, paddingBottom: 10 )
     
    }
   
}
