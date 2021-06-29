//
//  OneLine.swift
//  FitMeet
//
//  Created by novotorica on 23.06.2021.
//

import Foundation
import UIKit

final class OneLine : UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let lineleftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "DADADA")
        return view
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        initUI()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        addSubview(cardView)
        
    }
    private func initLayout() {
        cardView.fillSuperview()
        
       
        cardView.addSubview(lineleftView)
        lineleftView.anchor( left: cardView.leftAnchor, right: cardView.rightAnchor, paddingLeft: 5, paddingRight: 5,   height: 1)
        lineleftView.centerY(inView: cardView)
            
    }
}
