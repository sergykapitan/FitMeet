//
//  CoachCode.swift
//  MakeStep
//
//  Created by novotorica on 07.09.2021.
//

import UIKit
import Kingfisher

final class CoachCode: UIView {
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F6F6F6")
        return view
        }()
    
    var buttonHelp: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8"), for: .normal)
        return button
    }()
    var imageLogoProfile: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Group 17091")
        return image
    }()
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    var labelFollow : UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    var buttonSubscribe: UIButton = {
        var button = UIButton()
        button.setTitle("Subscribed", for: .normal)
        button.setTitleColor(UIColor(hexString: "#000000"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(hexString: "#DADADA")
        button.layer.borderWidth = 0.5
        button.layer.masksToBounds = false
        button.layer.borderColor = UIColor(hexString: "3B58A4").cgColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()
    var buttonFollow: UIButton = {
        var button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(UIColor(hexString: "#000000"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(hexString: "#DADADA")
        button.layer.borderWidth = 0.5
        button.layer.masksToBounds = false
        button.layer.borderColor = UIColor(hexString: "3B58A4").cgColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()
    var buttonTwiter: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Vector1-3"), for: .normal)
        return button
    }()
    var buttonfaceBook: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Vector1-2"), for: .normal)
        return button
    }()
    var buttonInstagram: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Vector1-4"), for: .normal)
        return button
    }()
    var labelVideo : UILabel  = {
        let label  = UILabel()
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Video"
        label.textAlignment = .center
        return label
    }()
    var labelINTVideo : UILabel  = {
        let label  = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text  = "2"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    var labelFollows : UILabel  = {
        let label  = UILabel()
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.textAlignment = .center
        label.text = "Followers"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    var labelINTFollows : UILabel  = {
        let label  = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    var labelFolowers : UILabel  = {
        let label  = UILabel()
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.textAlignment = .center
        label.text = "Following"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    var labelINTFolowers : UILabel  = {
        let label  = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    var labelDescription : UILabel  = {
        let label  = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
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

        cardView.fillSuperview()
     
        

        cardView.addSubview(imageLogoProfile)

        imageLogoProfile.anchor( top: cardView.topAnchor,
                                 paddingTop: 42,
                                 width: 95, height: 95)
        imageLogoProfile.centerX(inView: cardView)


        cardView.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: imageLogoProfile.bottomAnchor,
                            left: cardView.leftAnchor,
                            right: cardView.rightAnchor,
                            paddingTop: 10, paddingLeft: 20,paddingRight: 20)
        welcomeLabel.centerX(inView: cardView)
        

        cardView.addSubview(labelFollow)
        labelFollow.anchor(top: welcomeLabel.bottomAnchor,
                           left: imageLogoProfile.rightAnchor,
                           paddingTop: 5, paddingLeft: 20)

        cardView.addSubview(buttonHelp)
        buttonHelp.anchor(bottom: cardView.bottomAnchor,paddingBottom: 10, width: 40, height: 40)
        buttonHelp.centerX(inView: cardView)
        
        cardView.addSubview(buttonSubscribe)
        buttonSubscribe.anchor(top: welcomeLabel.bottomAnchor, left: cardView.leftAnchor, paddingTop: 20, paddingLeft: 18,  width: 102, height: 28)
        
        cardView.addSubview(buttonFollow)
        buttonFollow.anchor(top: welcomeLabel.bottomAnchor, paddingTop: 20, width: 102, height: 28)
        buttonFollow.centerX(inView: cardView)
        

        

        
        
        cardView.addSubview(buttonInstagram)
        buttonInstagram.anchor(  right: cardView.rightAnchor,paddingRight: 17, width: 28, height: 28)
        buttonInstagram.centerY(inView: buttonSubscribe)
        
        
                cardView.addSubview(buttonTwiter)
                buttonTwiter.anchor(right: buttonInstagram.leftAnchor,paddingRight: 8,  width: 28, height: 28)
                buttonTwiter.centerY(inView: buttonInstagram)

                cardView.addSubview(buttonfaceBook)
                buttonfaceBook.anchor( right: buttonTwiter.leftAnchor, paddingRight: 8, width: 28, height: 28)
                buttonfaceBook.centerY(inView: buttonInstagram)
        
        cardView.addSubview(labelINTVideo)
        labelINTVideo.anchor(top: buttonSubscribe.bottomAnchor, left: cardView.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 100, height: 20)
        cardView.addSubview(labelVideo)
        labelVideo.anchor(top: labelINTVideo.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        labelVideo.centerX(inView: labelINTVideo)
        
        
        cardView.addSubview(labelINTFollows)
        labelINTFollows.anchor(top: buttonSubscribe.bottomAnchor, paddingTop: 16, width: 100, height: 16)
        labelINTFollows.centerX(inView: cardView)
        cardView.addSubview(labelFollows)
        labelFollows.anchor(top: labelINTFollows.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        labelFollows.centerX(inView: labelINTFollows)
        
        
        
        cardView.addSubview(labelINTFolowers)
        labelINTFolowers.anchor(top: buttonSubscribe.bottomAnchor, right: cardView.rightAnchor, paddingTop: 16, paddingRight:  16, width: 100, height: 20)
        cardView.addSubview(labelFolowers)
        labelFolowers.anchor(top: labelINTFolowers.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        labelFolowers.centerX(inView: labelINTFolowers)
        
        cardView.addSubview(labelDescription)
        labelDescription.anchor(top: labelFollows.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,  paddingTop: 10, paddingLeft: 15, paddingRight: 5)
        
        
        
        
        
        

    }
    func setImage(image:String) {
        let url = URL(string: image)
        imageLogoProfile.kf.setImage(with: url)
    }
    func setLabel(description: String,category: String) {
       // labelCategory.text = category
       // labelStreamDescription.text = description
    }
    
    
    required init?(coder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    

}
