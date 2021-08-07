//
//  ChatVCCode.swift
//  MakeStep
//
//  Created by novotorica on 02.07.2021.
//

import Foundation
import UIKit
import Kingfisher

final class UserVCCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0.8
        view.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        return view
        }()
    var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    var buttonChat: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Back1-2"), for: .normal)
       // button.backgroundColor = .blue
        return button
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
 
//        cardView.addSubview(buttonChat)
//        buttonChat.anchor(bottom: cardView.bottomAnchor,paddingBottom: 10)
//        buttonChat.centerX(inView: cardView)
//        
        cardView.addSubview(buttonChat)
        buttonChat.anchor(top: cardView.topAnchor, paddingTop: 10,width: 12,height: 12)
        buttonChat.centerX(inView: cardView)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: buttonChat.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 10)
 
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
