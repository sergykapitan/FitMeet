//
//  VCControllerCode.swift
//  FitMeet
//
//  Created by novotorica on 18.06.2021.
//

import Foundation
import UIKit

final class VCControllerCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let labelSignUp: UILabel = {
        let label = UILabel()
        label.text = "Please register you Profile"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
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
        cardView.addSubview(labelSignUp)
        labelSignUp.anchor(top: cardView.topAnchor,
                           paddingTop: 46, height: 40)
        labelSignUp.centerX(inView: cardView)
        
       
    }
}
