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

    var buttonSignIn: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle(" Sign In ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 15
        return button
    }()
    var buttonSignUp: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle(" Sign Up ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 15
        return button
    }()
    
    var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.backgroundColor = .cyan
        return scroll
    }()
    
    
    var firstLine: OneLine = {
        let line = OneLine()
        return line
    }()
    
    var imageWallet: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "wallet")?.withTintColor(.blueColor, renderingMode: .alwaysOriginal)
        return image
        }()
    
    var labelWallet: UILabel = {
        let label = UILabel()
        label.text = "Monetization"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    var buttonWallet: UIButton = {
        let button = UIButton()
        return button
    }()

    var secondLine: OneLine = {
        let line = OneLine()
        return line
    }()

    var treeLine: OneLine = {
        let line = OneLine()
        return line
    }()
 
    var fourLine: OneLine = {
        let line = OneLine()
        return line
    }()
    
    var labelAbout: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var buttonAbout: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var labelPartners: UILabel = {
        let label = UILabel()
        label.text = "How it works"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var buttonPartners: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var labelCommunityGuidelines: UILabel = {
        let label = UILabel()
        label.text = "Terms of service"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var buttonCommunityGuidelines: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var labelCookiePolicy: UILabel = {
        let label = UILabel()
        label.text = "Privacy Policy"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var buttonCookiePolicy: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var labelPrivacyPolicy: UILabel = {
        let label = UILabel()
        label.text = "DMCA"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var buttonPrivacyPolicy: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var labelSecurity: UILabel = {
        let label = UILabel()
        label.text = "Disclaimer"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var buttonSecurity: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var labelTerms: UILabel = {
        let label = UILabel()
        label.text = "Contact us"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var buttonTerms: UIButton = {
        let button = UIButton()
        return button
    }()
    let scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentSize.height = 1000
       // scroll.contentSize.width = 400
        scroll.backgroundColor = .white
        return scroll
    }()
    //MARK: - initial
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        initUI()
        createCardViewLayer()
    
    }
    private func initUI() {
        
        
      addSubview(scroll)
      scroll.fillSuperview()
      scroll.addSubview(cardView)
       
    }
    
    //MARK: - constraint First Layer
    
    func createCardViewLayer() {

        cardView.anchor(top: scroll.topAnchor,paddingTop: 0,width: 400)

        scroll.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 5, paddingLeft: 20)
  
        
        scroll.addSubview(buttonSignUp)
        buttonSignUp.anchor(top: welcomeLabel.bottomAnchor, left: cardView.leftAnchor, paddingTop: 5, paddingLeft: 20,width: 64, height: 30)
        
        scroll.addSubview(buttonSignIn)
        buttonSignIn.anchor(top: welcomeLabel.bottomAnchor, left: buttonSignUp.rightAnchor, paddingTop: 5, paddingLeft: 10,width: 64, height: 30)
        
       
        

        scroll.addSubview(firstLine)
        firstLine.anchor(top: buttonSignIn.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        scroll.addSubview(buttonWallet)
        buttonWallet.anchor(top: firstLine.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        buttonWallet.addSubview(imageWallet)
        imageWallet.anchor(top: buttonWallet.topAnchor, left: buttonWallet.leftAnchor,  bottom: buttonWallet.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, width: 20, height: 20)
        buttonWallet.addSubview(labelWallet)
        labelWallet.anchor(left: imageWallet.rightAnchor,paddingLeft: 5)
        labelWallet.centerY(inView: buttonWallet)
        
        scroll.addSubview(secondLine)
        secondLine.anchor(top: buttonWallet.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        

        scroll.addSubview(buttonAbout)
        buttonAbout.anchor(top: secondLine.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        buttonAbout.addSubview(labelAbout)
        labelAbout.anchor(left: buttonAbout.leftAnchor,paddingLeft: 5)
        labelAbout.centerY(inView: buttonAbout)
        
        
        scroll.addSubview(buttonPartners)
        buttonPartners.anchor(top: buttonAbout.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        buttonPartners.addSubview(labelPartners)
        labelPartners.anchor(left: buttonPartners.leftAnchor,paddingLeft: 5)
        labelPartners.centerY(inView: buttonPartners)
        
        
        scroll.addSubview(buttonCommunityGuidelines)
        buttonCommunityGuidelines.anchor(top: buttonPartners.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        buttonCommunityGuidelines.addSubview(labelCommunityGuidelines)
        labelCommunityGuidelines.anchor(left: buttonCommunityGuidelines.leftAnchor,paddingLeft: 5)
        labelCommunityGuidelines.centerY(inView: buttonCommunityGuidelines)
        
        scroll.addSubview(buttonCookiePolicy)
        buttonCookiePolicy.anchor(top: buttonCommunityGuidelines.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        buttonCookiePolicy.addSubview(labelCookiePolicy)
        labelCookiePolicy.anchor(left: buttonCookiePolicy.leftAnchor,paddingLeft: 5)
        labelCookiePolicy.centerY(inView: buttonCookiePolicy)
        
        scroll.addSubview(buttonPrivacyPolicy)
        buttonPrivacyPolicy.anchor(top: buttonCookiePolicy.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        buttonPrivacyPolicy.addSubview(labelPrivacyPolicy)
        labelPrivacyPolicy.anchor(left: buttonPrivacyPolicy.leftAnchor,paddingLeft: 5)
        labelPrivacyPolicy.centerY(inView: buttonPrivacyPolicy)
        
        scroll.addSubview(buttonSecurity)
        buttonSecurity.anchor(top: buttonPrivacyPolicy.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        buttonSecurity.addSubview(labelSecurity)
        labelSecurity.anchor(left: buttonSecurity.leftAnchor,paddingLeft: 5)
        labelSecurity.centerY(inView: buttonSecurity)
        
        
        scroll.addSubview(buttonTerms)
        buttonTerms.anchor(top: buttonSecurity.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        buttonTerms.addSubview(labelTerms)
        labelTerms.anchor(left: buttonTerms.leftAnchor,paddingLeft: 5)
        labelTerms.centerY(inView: buttonTerms)
        
        
        
        

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

