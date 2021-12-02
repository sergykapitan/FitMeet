//
//  TimetableVCCode.swift
//  MakeStep
//
//  Created by Sergey on 01.12.2021.
//

import UIKit
import HHCustomCorner
import Kingfisher
import MMPlayerView
import AVFoundation

final class TimetableVCCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F6F6F6")
        return view
        }()
    
    var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(hexString: "#F6F6F6")
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
        tableView.fillFull(for: cardView)
 
  

    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

