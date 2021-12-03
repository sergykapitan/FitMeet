//
//  TimeTableCode.swift
//  MakeStep
//
//  Created by novotorica on 04.08.2021.
//


import UIKit

final class TimeTableCode: UIView {

    let cardView: UIView = {
        let view = UIView()
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
        addSubview(cardView)
        cardView.fillFull(for: self)
        cardView.addSubview(tableView)
        tableView.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

