//
//  ButtonOfflineCode.swift
//  MakeStep
//
//  Created by Sergey on 24.11.2021.
//

import Foundation
import UIKit
import MMPlayerView
import AVFoundation


final class ButtonOfflineCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F9FAFC")
        return view
    }()
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(hexString: "#F9FAFC")
        return table
    }()
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
        l.cacheType = .memory(count: 5)
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspect
        l.replace(cover: CoverA.instantiateFromNib())
        l.repeatWhenEnd = true
        return l
    }()
 
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        initUI()
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        addSubview(cardView)
        cardView.fillSuperview()
  
        cardView.addSubview(tableView)
        tableView.anchor(top: cardView.topAnchor,
                         left: cardView.leftAnchor,
                         right: cardView.rightAnchor,
                         bottom: cardView.bottomAnchor, paddingTop: 5, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
 
    }
   
}
