//
//  SettingView.swift
//  MakeStep
//
//  Created by Sergey on 28.03.2022.
//

import UIKit

final class SettingView : UIView {
    let cardView: UIView = {
        let view = UIView()
        return view
    }()
    var stackButton: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        return stack
    }()
    let button480: UIButton = {
        let but = UIButton()
        but.backgroundColor = .blueColor
        but.setTitle("480", for: .normal)
        but.anchor( height: 20)
        but.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return but
    }()
    let button4801: UIButton = {
        let but = UIButton()
        but.backgroundColor = .blueColor
        but.setTitle("4802", for: .normal)
        but.anchor( height: 20)
        but.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return but
    }()
    let button4802: UIButton = {
        let but = UIButton()
        but.backgroundColor = .blueColor
        but.setTitle("4803", for: .normal)
        but.anchor( height: 20)
        but.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return but
    }()
    let button4803: UIButton = {
        let but = UIButton()
        but.backgroundColor = .blueColor
        but.setTitle("4804", for: .normal)
        but.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        but.anchor( height: 20)
        return but
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
        stackButton = UIStackView(arrangedSubviews: [button480,button4801,button4802,button4803])
        stackButton.axis = .vertical
        stackButton.spacing = 1
        cardView.addSubview(stackButton)
        stackButton.anchor( left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingLeft: 0, paddingRight: 0, paddingBottom: 8)
        
        stackButton.centerX(inView: cardView)
        
    }
}
