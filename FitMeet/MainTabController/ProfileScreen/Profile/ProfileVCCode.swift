//
//  ProfileVCCode.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import UIKit

final class ProfileVCCode: UIView {
    
    //MARK: - UI
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    let labelSignUp: UILabel = {
        let label = UILabel()
        label.text = "PROFILE USER"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    let imageUserProfile: UIImageView = {
        let image = UIImage(named: "avatar")
        let imageUserProfile = UIImageView()
        imageUserProfile.maskCircle(anyImage: image!)
        imageUserProfile.image = image
        imageUserProfile.layer.borderWidth = 1.0
        imageUserProfile.layer.masksToBounds = false
        imageUserProfile.layer.borderColor = UIColor.white.cgColor
     //   imageUserProfile.layer.cornerRadius = image.
        imageUserProfile.clipsToBounds = true
        return imageUserProfile
    }()
    let buttonLogOut: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle("Log out", for: .normal)
        return button
        
    }()
    let userName: UILabel = {
        let label = UILabel()
        label.text = "UserName"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    let userFullName: UILabel = {
        let label = UILabel()
        label.text = "FullName: "
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    let userId: UILabel = {
        let label = UILabel()
        label.text = "id"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    let chanellId: UILabel = {
        let label = UILabel()
        label.text = "Chanell Id: "
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
                           paddingTop: 46)
        labelSignUp.centerX(inView: cardView)
        
        cardView.addSubview(buttonLogOut)
        buttonLogOut.centerX(inView: cardView)
        buttonLogOut.anchor(bottom: cardView.bottomAnchor,
                           paddingBottom: 50, width: 300,height: 40)
        
        cardView.addSubview(imageUserProfile)
        imageUserProfile.centerX(inView: cardView)
        imageUserProfile.anchor(top: labelSignUp.bottomAnchor,
                                paddingTop: 20)
        
        cardView.addSubview(userName)
        userName.anchor(top: imageUserProfile.bottomAnchor,
                        paddingTop: 20)
        userName.centerX(inView: cardView)
        
        cardView.addSubview(chanellId)
        chanellId.anchor(top: userName.bottomAnchor,
                        paddingTop: 20)
        chanellId.centerX(inView: cardView)
        
    }
}
