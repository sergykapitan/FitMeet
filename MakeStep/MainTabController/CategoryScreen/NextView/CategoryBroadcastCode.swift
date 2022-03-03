//
//  CategoryBroadcastCode.swift
//  FitMeet
//
//  Created by novotorica on 10.06.2021.
//

import Foundation
import UIKit

final class CategoryBroadcastCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    var buttonAll: UIButton = {
        var button = UIButton()
        button.backgroundColor = .blueColor
        button.setTitle("All", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        button.anchor(width: 64,height: 26)
        
        return button
    }()
    var buttonPopular: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("Popular", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        button.anchor(width: 64,height: 26)
        return button
    }()
    var buttonNew: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("New", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        button.anchor(width: 64,height: 26)
        return button
    }()
    var buttonViewers: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("Viewers", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        button.anchor(width: 64,height: 26)
        return button
    }()
    var tableView: UITableView = {
        let table = UITableView()
        return table
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

        cardView.addSubview(buttonAll)
        buttonAll.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 15, paddingLeft: 5, width: 74, height: 26)

        cardView.addSubview(buttonPopular)
        buttonPopular.anchor(top: cardView.topAnchor, left: buttonAll.rightAnchor, paddingTop: 15, paddingLeft: 5, width: 74, height: 26)

        cardView.addSubview(buttonNew)
        buttonNew.anchor(top: cardView.topAnchor, left: buttonPopular.rightAnchor, paddingTop: 15, paddingLeft: 5, width: 74, height: 26)

        cardView.addSubview(buttonViewers)
        buttonViewers.anchor(top: cardView.topAnchor, left: buttonNew.rightAnchor, paddingTop: 15, paddingLeft: 5, width: 74, height: 26)
 
        cardView.addSubview(tableView)
        tableView.anchor(top: buttonAll.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

