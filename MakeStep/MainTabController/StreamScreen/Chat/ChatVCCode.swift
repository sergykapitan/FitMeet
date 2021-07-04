//
//  ChatVCCode.swift
//  MakeStep
//
//  Created by novotorica on 02.07.2021.
//

import Foundation
import UIKit

final class ChatVCCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
            return view
        }()
    var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    var buttonChat: UIButton = {
        let button = UIButton()
        button.setTitle("JOIN", for: .normal)
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
 
        cardView.addSubview(buttonChat)
        buttonChat.anchor(bottom: cardView.bottomAnchor,paddingBottom: 10)
        buttonChat.centerX(inView: cardView)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: buttonChat.topAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 10)
 
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

