//
//  SearchUserCode.swift
//  MakeStep
//
//  Created by Sergey on 13.04.2022.
//

import UIKit

final class SearchUserCode: UIView {

    //MARK: - First layer in TopView
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
        }()
    let labelNtResult: UILabel = {
        var label = UILabel()
        label.text = "No results"
        label.textColor = UIColor(hexString: "#000000")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    } ()
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
        cardView.fillFull(for: self)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
  
        cardView.addSubview(labelNtResult)
        labelNtResult.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 20, paddingLeft: 20)
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
