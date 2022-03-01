//
//  HomeVCCode.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import Foundation
import UIKit

final class HomeVCCode: UIView {

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
        cardView.fillSuperview()
        
        cardView.addSubview(tableView)
        tableView.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        
     
      
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

