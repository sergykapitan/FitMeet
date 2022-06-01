//
//  LiveVCCode.swift
//  MakeStep
//
//  Created by Sergey on 06.05.2022.
//


import UIKit

final class LiveVCCode: UIView {

//MARK: - First layer in TopView    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
   
    var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
   
//MARK: - initial
    init() {
        super.init(frame: CGRect.zero)
        initUI()
        createCardViewLayer()
    }
//MARK: - constraint First Layer
    private func initUI() {
        addSubview(cardView)
    }
    func createCardViewLayer() {
        cardView.fillFull(for: self)
        cardView.addSubview(tableView)
        tableView.anchor(top: cardView.topAnchor,left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 3, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

