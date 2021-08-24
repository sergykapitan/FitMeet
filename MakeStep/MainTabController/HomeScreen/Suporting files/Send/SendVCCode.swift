//
//  SendVCCode.swift
//  MakeStep
//
//  Created by novotorica on 23.08.2021.
//

import Foundation
import UIKit

final class SendVCCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
       // view.clipsToBounds = true
            return view
        }()
    var butH: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Line"), for: .normal)
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
       // cardView.fillSuperview()
        cardView.fillFull(for: self)
        cardView.addSubview(butH)
        butH.anchor(top: cardView.topAnchor, paddingTop: 25, width: 50)
        butH.centerX(inView: cardView)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: butH.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 15, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

