//
//  SearchVCCode.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import Foundation
import UIKit

final class SearchVCCode: UIView {

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
    var segmentControll: CustomSegmentedControl = {
        let segment = CustomSegmentedControl()
        return segment
        
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
        cardView.addSubview(segmentControll)
        segmentControll.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 5, paddingLeft: 20, height: 30)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: segmentControll.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        

    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

