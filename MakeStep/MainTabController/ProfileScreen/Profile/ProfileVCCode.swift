//
//  ProfileVCCode.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import Foundation
import UIKit
import Kingfisher

final class ProfileVCCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
       // view.clipsToBounds = true
            return view
        }()
    var imageLogoProfile: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Group 17091")
        image.layer.borderWidth = 0.2
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true

        image.layer.borderColor = UIColor.black.cgColor
        image.clipsToBounds = true
        image.layer.cornerRadius = 40
        return image
    }()
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
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
    var imageProfile:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "edit")?.withTintColor(.blueColor, renderingMode: .alwaysOriginal)
        return image
        }()
    
    var labelProfile: UILabel = {
        let label = UILabel()
        label.text = "Edit Profile"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    var buttonProfile: UIButton = {
        let button = UIButton()
        return button
    }()
    var firstAndLine: OneLine = {
        let line = OneLine()
        return line
    }()
    var firstAndLineChannel: OneLine = {
        let line = OneLine()
        return line
    }()
 
    var imageChanell:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "youtube")?.withTintColor(.blueColor, renderingMode: .alwaysOriginal)
        return image
        }()
    
    var labelChanell: UILabel = {
        let label = UILabel()
        label.text = "Channel"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    var buttonChanell: UIButton = {
        let button = UIButton()   
        return button
    }()
    var imageEditChanell:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "edit")?.withTintColor(.blueColor, renderingMode: .alwaysOriginal)
        return image
        }()
    
    var labelEditChanell: UILabel = {
        let label = UILabel()
        label.text = "Edit Channel"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    var buttonEditChanell: UIButton = {
        let button = UIButton()
        return button
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

    var fourLine: OneLine = {
        let line = OneLine()
        return line
    }()
    var imageSignOut: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logout")?.withTintColor(.blueColor, renderingMode: .alwaysOriginal)
        return image
        }()
    var labelSignOut: UILabel = {
        let label = UILabel()
        label.text = "Sign Out"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    var buttonSignOut: UIButton = {
        let button = UIButton()
        return button
    }()
    var fourAndLine: OneLine = {
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
    
    var labelContact: UILabel = {
        let label = UILabel()
        label.text = "Contact us"
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var buttonContact: UIButton = {
        let button = UIButton()
        return button
    }()
    lazy var appVersionLabel:  UILabel = {
        let label = UILabel()
        if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            label.text = "App version: \(text)"
        }
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "AvenirNext-Medium", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentSize.height = 1000
        scroll.backgroundColor = .white
        return scroll
    }()
    //MARK: - initial
    
    init() {
        super.init(frame: CGRect.zero)
        initUI()
        createCardViewLayer()
        
    }
    
    //MARK: - constraint First Layer
    private func initUI() {
        
      addSubview(scroll)
      scroll.fillSuperview()
      scroll.addSubview(cardView)
       
    }
    func createCardViewLayer() {
 
        cardView.anchor(top: scroll.topAnchor,paddingTop: 0,width: 400)
        
        scroll.addSubview(imageLogoProfile)
        imageLogoProfile.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 5, paddingLeft: 5,width: 80, height: 80)
        
        scroll.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: cardView.topAnchor, left: imageLogoProfile.rightAnchor,right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 20,paddingRight: 10)
        
        scroll.addSubview(segmentControll)
        segmentControll.anchor(top: welcomeLabel.bottomAnchor, left: cardView.leftAnchor, paddingTop: 5, paddingLeft: 20, height: 30)
        
        scroll.addSubview(firstLine)
        firstLine.anchor(top: segmentControll.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        scroll.addSubview(buttonProfile)
        buttonProfile.anchor(top: firstLine.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        buttonProfile.addSubview(imageProfile)
        imageProfile.anchor(top: buttonProfile.topAnchor, left: buttonProfile.leftAnchor,  bottom: buttonProfile.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, width: 20, height: 20)
        buttonProfile.addSubview(labelProfile)
        labelProfile.anchor(left: imageProfile.rightAnchor,paddingLeft: 5)
        labelProfile.centerY(inView: buttonProfile)
        
        scroll.addSubview(firstAndLine)
        firstAndLine.anchor(top: buttonProfile.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
 
        scroll.addSubview(buttonChanell)
        buttonChanell.anchor(top: firstAndLine.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        buttonChanell.addSubview(imageChanell)
        imageChanell.anchor(top: buttonChanell.topAnchor, left: buttonChanell.leftAnchor,  bottom: buttonChanell.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, width: 20, height: 20)
        buttonChanell.addSubview(labelChanell)
        labelChanell.anchor(left: imageChanell.rightAnchor,paddingLeft: 5)
        labelChanell.centerY(inView: buttonChanell)
        
        scroll.addSubview(firstAndLineChannel)
        firstAndLineChannel.anchor(top: buttonChanell.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        scroll.addSubview(buttonEditChanell)
        buttonEditChanell.anchor(top: firstAndLineChannel.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        buttonEditChanell.addSubview(imageEditChanell)
        imageEditChanell.anchor(top: buttonEditChanell.topAnchor, left: buttonEditChanell.leftAnchor,  bottom: buttonEditChanell.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, width: 20, height: 20)
        
        buttonEditChanell.addSubview(labelEditChanell)
        labelEditChanell.anchor(left: imageEditChanell.rightAnchor,paddingLeft: 5)
        labelEditChanell.centerY(inView: buttonEditChanell)
        
        scroll.addSubview(secondLine)
        secondLine.anchor(top: buttonEditChanell.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        scroll.addSubview(buttonWallet)
        buttonWallet.anchor(top: secondLine.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        buttonWallet.addSubview(imageWallet)
        imageWallet.anchor(top: buttonWallet.topAnchor, left: buttonWallet.leftAnchor,  bottom: buttonWallet.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, width: 20, height: 20)
        
        buttonWallet.addSubview(labelWallet)
        labelWallet.anchor(left: imageWallet.rightAnchor,paddingLeft: 5)
        labelWallet.centerY(inView: buttonWallet)
  
        
        scroll.addSubview(fourLine)
        fourLine.anchor(top: buttonWallet.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        scroll.addSubview(buttonSignOut)
        buttonSignOut.anchor(top: fourLine.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        buttonSignOut.addSubview(imageSignOut)
        imageSignOut.anchor(top: buttonSignOut.topAnchor, left: buttonSignOut.leftAnchor,  bottom: buttonSignOut.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, width: 20, height: 20)
        
        buttonSignOut.addSubview(labelSignOut)
        labelSignOut.anchor(left: imageSignOut.rightAnchor,paddingLeft: 5)
        labelSignOut.centerY(inView: buttonSignOut)
        
        scroll.addSubview(fourAndLine)
        fourAndLine.anchor(top: buttonSignOut.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        
        scroll.addSubview(buttonAbout)
        buttonAbout.anchor(top: fourAndLine.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        buttonAbout.addSubview(labelAbout)
        labelAbout.anchor(left: buttonAbout.leftAnchor,paddingLeft: 5)
        labelAbout.centerY(inView: buttonAbout)


        scroll.addSubview(buttonPartners)
        buttonPartners.anchor(top: buttonAbout.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 5, paddingLeft: 16, paddingRight: 16)
        buttonPartners.addSubview(labelPartners)
        labelPartners.anchor(left: buttonPartners.leftAnchor,paddingLeft: 5)
        labelPartners.centerY(inView: buttonPartners)
        
        
        scroll.addSubview(buttonCommunityGuidelines)
        buttonCommunityGuidelines.anchor(top:buttonPartners.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
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
        
        
        scroll.addSubview(buttonContact)
        buttonContact.anchor(top: buttonSecurity.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        buttonContact.addSubview(labelContact)
        labelContact.anchor(left: buttonContact.leftAnchor,paddingLeft: 5)
        labelContact.centerY(inView: buttonContact)
        
        scroll.addSubview(appVersionLabel)
        appVersionLabel.centerX(inView: cardView)
        appVersionLabel.anchor(top: buttonContact.bottomAnchor, paddingTop: 10)
        

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageLogo(image:String) {
        let url = URL(string: image)
        imageLogoProfile.kf.setImage(with: url,options: [.retryStrategy(DelayRetryStrategy(maxRetryCount: 5, retryInterval: .seconds(1)))])
       
    }
}

