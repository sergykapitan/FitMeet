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
    
    var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.backgroundColor = .cyan
        return scroll
    }()
    
    
    var firstLine: OneLine = {
        let line = OneLine()
        return line
    }()
    
    var imageLogo:UIImageView = {
        let image = UIImageView()
        image.image =  #imageLiteral(resourceName: "history 1")
        return image
        }()
    
    var labelHistory: UILabel = {
        let label = UILabel()
        label.text = "History"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    var buttonHistory: UIButton = {
        let button = UIButton()
        return button
    }()
    var imageWallet: UIImageView = {
        let image = UIImageView()
        image.image =  #imageLiteral(resourceName: "wallet")
        return image
        }()
    
    var labelWallet: UILabel = {
        let label = UILabel()
        label.text = "Wallet"
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
    var imageSettinh: UIImageView = {
        let image = UIImageView()
        image.image =  #imageLiteral(resourceName: "settings 1-1")
        return image
        }()
    var labelSetting: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    var buttonSetting: UIButton = {
        let button = UIButton()
        return button
    }()
    var imageLanguage: UIImageView = {
        let image = UIImageView()
        image.image =  #imageLiteral(resourceName: "globe 1-1")
        return image
        }()
    var labelLanguage: UILabel = {
        let label = UILabel()
        label.text = "Language"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    var buttonLanguage: UIButton = {
        let button = UIButton()
        return button
    }()
    var treeLine: OneLine = {
        let line = OneLine()
        return line
    }()
    
    var imageHelp: UIImageView = {
        let image = UIImageView()
        image.image =  #imageLiteral(resourceName: "help-circle 1-1")
        return image
        }()
    var labelHelp: UILabel = {
        let label = UILabel()
        label.text = "Help"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    var buttonHelp: UIButton = {
        let button = UIButton()
        return button
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
        label.text = "Partners"
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
        label.text = "Community Guidelines"
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
        label.text = "Cookie Policy"
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
        label.text = "Privacy Policy"
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
        label.text = "Security"
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
        label.text = "Terms"
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
        
        
      addSubview(cardView)
     // scroll.fillFull(for: self)
     // scroll.addSubview(cardView)
       
    }
    
    //MARK: - constraint First Layer
    
    func createCardViewLayer() {
        
        
       // addSubview(cardView)
        cardView.fillSuperview()

      //  cardView.anchor(top: scroll.topAnchor,paddingTop: 0,width: 400)
        
        
        cardView.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 5, paddingLeft: 20)
        
        cardView.addSubview(segmentControll)
        segmentControll.anchor(top: welcomeLabel.bottomAnchor, left: cardView.leftAnchor, paddingTop: 5, paddingLeft: 20, height: 30)

        cardView.addSubview(firstLine)
        firstLine.anchor(top: segmentControll.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        cardView.addSubview(buttonHistory)
        buttonHistory.anchor(top: firstLine.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        buttonHistory.addSubview(imageLogo)
        imageLogo.anchor(top: buttonHistory.topAnchor, left: buttonHistory.leftAnchor,  bottom: buttonHistory.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, width: 20, height: 20)
        buttonHistory.addSubview(labelHistory)
        labelHistory.anchor(left: imageLogo.rightAnchor,paddingLeft: 5)
        labelHistory.centerY(inView: buttonHistory)
        
        cardView.addSubview(secondLine)
        secondLine.anchor(top: buttonHistory.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        cardView.addSubview(buttonWallet)
        buttonWallet.anchor(top: secondLine.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        buttonWallet.addSubview(imageWallet)
        imageWallet.anchor(top: buttonWallet.topAnchor, left: buttonWallet.leftAnchor,  bottom: buttonWallet.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, width: 20, height: 20)
        
        buttonWallet.addSubview(labelWallet)
        labelWallet.anchor(left: imageWallet.rightAnchor,paddingLeft: 5)
        labelWallet.centerY(inView: buttonWallet)
        
        cardView.addSubview(buttonSetting)
        buttonSetting.anchor(top: buttonWallet.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        buttonSetting.addSubview(imageSettinh)
        imageSettinh.anchor(top: buttonSetting.topAnchor, left: buttonSetting.leftAnchor,  bottom: buttonSetting.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, width: 20, height: 20)
        
        buttonSetting.addSubview(labelSetting)
        labelSetting.anchor(left: imageSettinh.rightAnchor,paddingLeft: 5)
        labelSetting.centerY(inView: buttonSetting)
        
        cardView.addSubview(buttonLanguage)
        buttonLanguage.anchor(top: buttonSetting.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        buttonLanguage.addSubview(imageLanguage)
        imageLanguage.anchor(top: buttonLanguage.topAnchor, left: buttonLanguage.leftAnchor,  bottom: buttonLanguage.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, width: 20, height: 20)
        
        buttonLanguage.addSubview(labelLanguage)
        labelLanguage.anchor(left: imageLanguage.rightAnchor,paddingLeft: 5)
        labelLanguage.centerY(inView: buttonLanguage)
        
        cardView.addSubview(treeLine)
        treeLine.anchor(top: buttonLanguage.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        cardView.addSubview(buttonHelp)
        buttonHelp.anchor(top: treeLine.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        buttonHelp.addSubview(imageHelp)
        imageHelp.anchor(top: buttonHelp.topAnchor, left: buttonHelp.leftAnchor,  bottom: buttonHelp.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, width: 20, height: 20)
        
        buttonHelp.addSubview(labelHelp)
        labelHelp.anchor(left: imageHelp.rightAnchor,paddingLeft: 5)
        labelHelp.centerY(inView: buttonHelp)
        
        cardView.addSubview(fourLine)
        fourLine.anchor(top: buttonHelp.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        cardView.addSubview(buttonAbout)
        buttonAbout.anchor(top: fourLine.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        buttonAbout.addSubview(labelAbout)
        labelAbout.anchor(left: buttonAbout.leftAnchor,paddingLeft: 5)
        labelAbout.centerY(inView: buttonAbout)
        
        
        cardView.addSubview(buttonPartners)
        buttonPartners.anchor(top: buttonAbout.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        buttonPartners.addSubview(labelPartners)
        labelPartners.anchor(left: buttonPartners.leftAnchor,paddingLeft: 5)
        labelPartners.centerY(inView: buttonPartners)
        
        
        cardView.addSubview(buttonCommunityGuidelines)
        buttonCommunityGuidelines.anchor(top: buttonPartners.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        buttonCommunityGuidelines.addSubview(labelCommunityGuidelines)
        labelCommunityGuidelines.anchor(left: buttonCommunityGuidelines.leftAnchor,paddingLeft: 5)
        labelCommunityGuidelines.centerY(inView: buttonCommunityGuidelines)
        
        cardView.addSubview(buttonCookiePolicy)
        buttonCookiePolicy.anchor(top: buttonCommunityGuidelines.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        buttonCookiePolicy.addSubview(labelCookiePolicy)
        labelCookiePolicy.anchor(left: buttonCookiePolicy.leftAnchor,paddingLeft: 5)
        labelCookiePolicy.centerY(inView: buttonCookiePolicy)
        
        cardView.addSubview(buttonPrivacyPolicy)
        buttonPrivacyPolicy.anchor(top: buttonCookiePolicy.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        buttonPrivacyPolicy.addSubview(labelPrivacyPolicy)
        labelPrivacyPolicy.anchor(left: buttonPrivacyPolicy.leftAnchor,paddingLeft: 5)
        labelPrivacyPolicy.centerY(inView: buttonPrivacyPolicy)
        
        cardView.addSubview(buttonSecurity)
        buttonSecurity.anchor(top: buttonPrivacyPolicy.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        buttonSecurity.addSubview(labelSecurity)
        labelSecurity.anchor(left: buttonSecurity.leftAnchor,paddingLeft: 5)
        labelSecurity.centerY(inView: buttonSecurity)
        
        
        cardView.addSubview(buttonTerms)
        buttonTerms.anchor(top: buttonSecurity.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        buttonTerms.addSubview(labelTerms)
        labelTerms.anchor(left: buttonTerms.leftAnchor,paddingLeft: 5)
        labelTerms.centerY(inView: buttonTerms)
        
        
        
        

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

