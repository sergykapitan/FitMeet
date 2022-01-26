//
//  VideosVCCode.swift
//  MakeStep
//
//  Created by Sergey on 01.12.2021.
//



import Foundation
import UIKit
import HHCustomCorner
import Kingfisher
import MMPlayerView
import AVFoundation

final class VideosVCCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F6F6F6")
        return view
        }()
    
    var buttonOnline: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("Online", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        return button
    }()
    var buttonOffline: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("Recording", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        return button
    }()
    var buttonComing: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("Upcoming", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        return button
    }()
    let selfView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
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
     
        cardView.addSubview(buttonOffline)
        buttonOffline.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 15, paddingLeft: 10, width: 78, height: 26)
        
        cardView.addSubview(buttonComing)
        buttonComing.anchor(top: cardView.topAnchor, left: buttonOffline.rightAnchor, paddingTop: 15, paddingLeft: 10, width: 78, height: 26)
        
        cardView.addSubview(selfView)
        selfView.anchor(top: buttonOffline.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 6, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
  

    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

