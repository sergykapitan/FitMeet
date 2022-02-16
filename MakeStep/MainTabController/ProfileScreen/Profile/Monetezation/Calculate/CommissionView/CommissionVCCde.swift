//
//  CommissionVCCde.swift
//  MakeStep
//
//  Created by Sergey on 16.02.2022.
//


import Foundation
import UIKit
import EasyPeasy


final class CommissionVCCde: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F9FAFC")
        return view
    }()

    var labelTotal: UILabel = {
        let label = UILabel()
        label.text = "MakeStep platform provides features such as broadcasting tools, group broadcasting, real-time chat, private rooms, unlimited VOD storage, payment gateways, and a scheduler. You can start using these features without any fees.\n As soon as you get subscribers, MakeStep will take 30% of the processed payments from your clients. That means that our trainer-creators take 70% of the revenue made from subscriptions and one-time-class payments. All transaction costs (excluding payout fees) are covered by MakeStep."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(hexString: "#868686")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    var labelTot: UILabel = {
        let label = UILabel()
        label.text = "Service commission 30%"
        label.textColor = UIColor(hexString: "#000000")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
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
 
        cardView.addSubview(labelTotal)
        labelTotal.anchor( left: cardView.leftAnchor, right: cardView.rightAnchor,  paddingLeft: 15, paddingRight: 15)
        labelTotal.centerY(inView: cardView)
        labelTotal.centerX(inView: cardView)
        
        cardView.addSubview(labelTot)
        labelTot.anchor( bottom: labelTotal.topAnchor, paddingBottom: 10)
        labelTot.centerX(inView: cardView)
        
 
    }
   
}
