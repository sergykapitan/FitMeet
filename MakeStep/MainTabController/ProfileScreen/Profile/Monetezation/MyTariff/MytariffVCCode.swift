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
        view.backgroundColor = UIColor(hexString: "#F9FAFC")
        return view
    }()
    let buttonAddNewMonet: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "AddNewMonet"), for: .normal)
        return btn
    }()
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(hexString: "#F9FAFC")
        return table
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
        buttonAddNewMonet.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingRight: 16)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: buttonAddNewMonet.bottomAnchor,
                         left: cardView.leftAnchor,
                         right: cardView.rightAnchor,
                         bottom: cardView.bottomAnchor, paddingTop: 16, paddingLeft: 10, paddingRight: 10, paddingBottom: 0)
 
    }
   
}
