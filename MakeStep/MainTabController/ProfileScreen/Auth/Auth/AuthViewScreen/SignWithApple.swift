//
//  SignWithApple.swift
//  MakeStep
//
//  Created by Sergey on 21.03.2022.
//

import UIKit

final class SignWithApple : UIView {
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let button: UIButton = {
        let but = UIButton()
        but.backgroundColor = .blueColor
        but.layer.cornerRadius = 19
        return but        
    }()
    
    let labelRight: UILabel = {
        let label = UILabel()
        label.text = "Sign up with Apple"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let imageApple: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "AppleIcon")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return im
    }()

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
        cardView.addSubview(button)
        button.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 0, paddingLeft: 0, paddingRight: 0 , height: 39)
   
        button.addSubview(labelRight)
        labelRight.anchor()
        labelRight.centerX(inView: button)
        labelRight.centerY(inView: button)
        
        button.addSubview(imageApple)
        imageApple.anchor(right: labelRight.leftAnchor,paddingRight: 5, width: 13.92, height: 17.08)
        NSLayoutConstraint.activate([
            imageApple.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2),
 
        ])
    }
}
