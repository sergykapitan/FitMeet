//
//  StartScreenCode.swift
//  FitMeet
//
//  Created by novotorica on 22.06.2021.
//

import Foundation
import UIKit

final class StartScreenCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
            return view
        }()
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    var segmentControll: CustomSegmentedControl = {
        let segment = CustomSegmentedControl()
        return segment
        
    }()
    var firstLine: OneLine = {
        let line = OneLine()
        return line
    }()
    
    var imageLogo:UIImageView = {
            let image = UIImageView()
            image.image =  #imageLiteral(resourceName: "Group1")
            return image
        }()

    var buttonHistory: UIButton = {
        let button = UIButton()

       // button.setImage(#imageLiteral(resourceName: "Group1"), for: .normal)
       // button.setTitle("History", for: .normal)
        return button
    }()
    var secondLine: OneLine = {
        let line = OneLine()
        return line
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
        
        cardView.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 5, paddingLeft: 20)
        
        cardView.addSubview(segmentControll)
        segmentControll.anchor(top: welcomeLabel.bottomAnchor, left: cardView.leftAnchor, paddingTop: 5, paddingLeft: 20, height: 30)
        
        cardView.addSubview(firstLine)
        firstLine.anchor(top: segmentControll.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 30, paddingLeft: 16, paddingRight: 16)
        
        cardView.addSubview(buttonHistory)
        buttonHistory.anchor(top: firstLine.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 30, paddingLeft: 16, paddingRight: 16)
        
        buttonHistory.addSubview(imageLogo)
        imageLogo.anchor(top: buttonHistory.topAnchor, left: buttonHistory.leftAnchor,  bottom: buttonHistory.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, width: 10, height: 10)
        
        cardView.addSubview(secondLine)
        secondLine.anchor(top: buttonHistory.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 30, paddingLeft: 16, paddingRight: 16)
        

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

