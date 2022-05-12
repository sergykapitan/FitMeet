//
//  PlayerViewVCCode.swift
//  MakeStep
//
//  Created by Sergey on 18.02.2022.
//

import Foundation
import UIKit
import HHCustomCorner
import Kingfisher
import TagListView

final class PlayerViewVCCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F6F6F6")
        return view
        }()
    var imageLogoProfile: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        image.image = #imageLiteral(resourceName: "Group 17091")
        image.anchor(width: 24,height: 24)
        image.makeRounded()
        return image
    }()
    var imageLogo: UIImageView = {
        let image = UIImageView()
        image.isHidden =  true
        return image
    }()
    var imagePromo: UIView = {
        var image = UIView()
        return image
    }()
    var buttonLandScape: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "maximize"), for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()
    var playerSlider: UISlider = {
        var slider = UISlider()
        slider.setThumbImage(UIImage(named: "FrameSlider"), for: .normal)
        return slider
    }()
    var buttonSetting: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "settings1-1"), for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .right
        return button
    }()
    var buttonPlayPause: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "PausePlayer"), for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()
    var buttonSkipPrevious: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Skip Previous"), for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()
    var buttonSkipNext: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Skip Next"), for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()
    var labelTimer: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hexString: "#727272")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
   
    var labelStreamInfo: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hexString: "#000000")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Stream information"
        label.numberOfLines = 1
        return label
    }()
    var labelStreamDescription: UILabel = {
        var label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    var labelLike: UILabel = {
        var label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    var labelEyeView: UILabel = {
        var label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.text = "123"
        label.textAlignment = .center
        return label
    }()
    var labelTimeStart: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "00:00"
        return label
    }()
    var labelTimeEnd: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    var buttonChat: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "ChatPlayer"), for: .normal)
        return button
    }()
    var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    var overlay : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        view.layer.borderWidth = 0.5
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.gray.cgColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    var settingView : SettingView = {
        let view = SettingView()
        view.backgroundColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        view.layer.borderWidth = 0.5
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.gray.cgColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    var labelLive: UILabel = {
        let label = UILabel()
        label.text = "Live"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    var imageLive: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "slider")
        return image
    }()    
    var imageEye: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "eye")
        return image
    }()
    var imageEyeТ: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "eye")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        return image
    }()
    var labelEye: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.text = "2"
        return label
    }()

    var labelDescription : UILabel  = {
        let label  = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    var buttonLike: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
        return button
    }()
    var buttonOpen: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Back11")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    var buttonMore: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Menu Kebab1"), for: .normal)
        return button
    }()
    let labelNotToken: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.696, green: 0.696, blue: 0.696, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    var stackButton: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.anchor(height: 30)
        return stack
    }()
    var labelCategory: TagListView = {
       var tag = TagListView()
       tag.textFont = UIFont.systemFont(ofSize: 12)
       tag.tagBackgroundColor = .clear
       tag.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
       tag.selectedTextColor = .black
       tag.paddingX = 2
       tag.paddingY = 5
       tag.tagLineBreakMode = .byTruncatingHead
       tag.translatesAutoresizingMaskIntoConstraints = false
       tag.anchor( width: 200)
       return tag
       }()
    var buttonSubscribe: UIButton = {
        var button = UIButton()
        button.setTitle("Subscribe", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .blueColor
        button.layer.borderWidth = 1
        button.layer.masksToBounds = false
        button.layer.borderColor = UIColor(hexString: "#0066FF").cgColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()
    var buttonFollow: UIButton = {
        var button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .blueColor
        button.layer.borderWidth = 1
        button.layer.masksToBounds = false
        button.layer.borderColor = UIColor(hexString: "#0066FF").cgColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
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
        stackButton = UIStackView(arrangedSubviews: [imageLogoProfile,labelStreamDescription])
        stackButton.spacing = 10
    }
    func createCardViewLayer() {

        cardView.fillFull(for: self)

        cardView.addSubview(imagePromo)
        imagePromo.anchor(top: cardView.topAnchor,
                          left: cardView.leftAnchor,
                          right: cardView.rightAnchor,
                          paddingTop: 45, paddingLeft: 0, paddingRight: 0)
        
        imagePromo.widthEqualToMultiplier(inView: self, multiplier: 9.0 / 16.0)
        
        cardView.addSubview(imageLogo)
        imageLogo.anchor(top: imagePromo.topAnchor, left: imagePromo.leftAnchor, right: imagePromo.rightAnchor, bottom: imagePromo.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        
        cardView.addSubview(buttonMore)
        buttonMore.anchor(top: imagePromo.bottomAnchor,right: cardView.rightAnchor, paddingTop: 0,paddingRight: 10,width: 24,height: 35)
        
        cardView.addSubview(labelStreamInfo)
        labelStreamInfo.anchor(top: imagePromo.bottomAnchor,  left: cardView.leftAnchor,right: buttonMore.leftAnchor,paddingTop: 11, paddingLeft: 16, paddingRight: 2)
        
        cardView.addSubview(labelLike)
        labelLike.anchor(top: labelStreamInfo.bottomAnchor,right: cardView.rightAnchor, paddingTop: 5, paddingRight: 10, width: 24, height: 24)

        cardView.addSubview(buttonLike)
        buttonLike.anchor(top: labelStreamInfo.bottomAnchor,right: labelLike.leftAnchor, paddingTop: 5, paddingRight: 0, width: 24, height: 24)
        
        cardView.addSubview(labelEyeView)
        labelEyeView.anchor(top: labelStreamInfo.bottomAnchor,right: buttonLike.leftAnchor, paddingTop: 5, paddingRight: 10, width: 24, height: 24)

        cardView.addSubview(imageEyeТ)
        imageEyeТ.anchor(top: labelStreamInfo.bottomAnchor, right: labelEyeView.leftAnchor, paddingTop: 5, paddingRight: 4, width: 24, height: 24)

        cardView.addSubview(buttonChat)
        buttonChat.anchor(right: buttonLike.leftAnchor,paddingRight: 5,width: 24, height: 24)
        buttonChat.centerY(inView: buttonLike)

        cardView.addSubview(stackButton)
        stackButton.anchor(top: labelStreamInfo.bottomAnchor, left: cardView.leftAnchor, paddingTop: 5, paddingLeft: 16)
        
        
        cardView.addSubview(buttonSubscribe)
        buttonSubscribe.anchor(top: stackButton.bottomAnchor, left: cardView.leftAnchor,paddingTop: 5, paddingLeft: 16, width: 90, height: 28)
        
        cardView.addSubview(buttonFollow)
        buttonFollow.anchor(top: stackButton.bottomAnchor, left: buttonSubscribe.rightAnchor ,paddingTop: 5, paddingLeft: 16, width: 90, height: 28)
        
        cardView.addSubview(buttonOpen)
        buttonOpen.anchor(top: stackButton.bottomAnchor,right: cardView.rightAnchor, paddingTop: 5,paddingRight: -10, width: 60, height: 30)
        buttonOpen.centerY(inView: buttonFollow)
        
        cardView.addSubview(labelCategory)
        labelCategory.anchor(top: buttonFollow.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingRight: 15)
        cardView.addSubview(labelDescription)
        labelDescription.anchor(top: labelCategory.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingRight: 15)
        
  
        cardView.addSubview(tableView)
        tableView.anchor(left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)

        cardView.addSubview(labelNotToken)
        labelNotToken.anchor( left: cardView.leftAnchor, right: cardView.rightAnchor,  paddingLeft: 16, paddingRight: 16)
        labelNotToken.centerY(inView: cardView)
        labelNotToken.centerX(inView: cardView)
        
        cardView.addSubview(overlay)
        overlay.anchor(top: imagePromo.topAnchor,
                       left: imagePromo.leftAnchor,
                       paddingTop: 10,
                       paddingLeft: 16,  width: 90, height: 24)
    
        cardView.addSubview(imageLive)
        imageLive.anchor( left: overlay.leftAnchor, paddingLeft: 6, width: 12, height: 12)
        imageLive.centerY(inView: overlay)
        
        cardView.addSubview(labelLive)
        labelLive.anchor( left: imageLive.rightAnchor, paddingLeft: 6)
        labelLive.centerY(inView: overlay)
        
        cardView.addSubview(imageEye)
        imageEye.anchor( left: labelLive.rightAnchor, paddingLeft: 6, width: 12, height: 12)
        imageEye.centerY(inView: overlay)
        
        cardView.addSubview(labelEye)
        labelEye.anchor( left: imageEye.rightAnchor, paddingLeft: 6)
        labelEye.centerY(inView:overlay)
       
    }
    func setImage(image:String) {
        let url = URL(string: image)
        imageLogoProfile.kf.setImage(with: url)
        imageLogoProfile.makeRounded()
    }
    func setLabel(description: String,category: String) {
        labelStreamDescription.text = description
    }
    func setImagePromo(image:String) {
        let url = URL(string: image)
        imageLogo.kf.setImage(with: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

