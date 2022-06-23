//
//  BottomViewCapture.swift
//  MakeStep
//
//  Created by Sergey on 17.06.2022.
//


import UIKit

final class BottomViewCapture : UIView {
   
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [ UIColor(red: 0.183, green: 0.183, blue: 0.183, alpha: 0).cgColor, UIColor(red: 0.008, green: 0.008, blue: 0.008, alpha: 1).cgColor]
        gradient.type = .axial
        return gradient
    }()
    let buttonPause: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "pauseStream"), for: .normal)
        return btn
    }()
    let microfoneBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "microfoneUser"), for: .normal)
        return button
    }()
    let volumeBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName:"volumeCoach"), for: .normal)
        return button
    }()
    let chatBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "chatUser"), for: .normal)
        return button
    }()
    let rotateCamera: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "rotateCamera"), for: .normal)
        return button
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
        cardView.layer.addSublayer(gradientLayer)
        
        cardView.addSubview(buttonPause)
        buttonPause.anchor( bottom: cardView.bottomAnchor,  paddingBottom: 14, width: 50, height: 50)
        buttonPause.centerX(inView: cardView)
        
        cardView.addSubview(rotateCamera)
        rotateCamera.anchor( right: cardView.rightAnchor,  paddingRight: 15, width: 40, height: 40)
        rotateCamera.centerY(inView: buttonPause)
        
        cardView.addSubview(chatBtn)
        chatBtn.anchor( right: rotateCamera.leftAnchor, paddingRight: 10, width: 40, height: 40)
        chatBtn.centerY(inView: buttonPause)
        
        cardView.addSubview(microfoneBtn)
        microfoneBtn.anchor(left: cardView.leftAnchor, paddingLeft: 16, width: 40, height: 40)
        microfoneBtn.centerY(inView: buttonPause)
        
        cardView.addSubview(volumeBtn)
        volumeBtn.anchor( left: microfoneBtn.rightAnchor, paddingLeft: 10, width: 40, height: 40)
        volumeBtn.centerY(inView: buttonPause)

    }
}
