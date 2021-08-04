//
//  TimeTableCode.swift
//  MakeStep
//
//  Created by novotorica on 04.08.2021.
//

import Foundation
import UIKit
import HHCustomCorner
import Kingfisher

final class TimeTableCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        //view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
       // view.backgroundColor = .white
       // view.translatesAutoresizingMaskIntoConstraints = false
      //  view.backgroundColor = UIColor(hexString: "#F6F6F6")
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
    func setImage(image:String,imagepromo: String) {
        let url = URL(string: image)
        let urlPromo = URL(string: imagepromo)
        
    }
    func setLabel(description: String,category: String) {
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

