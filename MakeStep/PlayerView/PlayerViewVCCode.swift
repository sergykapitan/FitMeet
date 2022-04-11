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
        image.image = #imageLiteral(resourceName: "Group 17091")
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
    var labelCategory: TagListView = {
        var tag = TagListView()
        tag.textFont = UIFont.systemFont(ofSize: 12)
        tag.tagBackgroundColor = .clear
        tag.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        tag.selectedTextColor = .black
        tag.paddingX = 0
        return tag
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
    var labelEye: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.text = "2"
        return label
    }()
    var buttonSubscribe: UIButton = {
        var button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.masksToBounds = false
        button.layer.borderColor = UIColor(hexString: "#3B58A4").cgColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
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
    var buttonMore: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "More"), for: .normal)
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

        cardView.addSubview(imagePromo)
        imagePromo.anchor(top: cardView.topAnchor,
                          left: cardView.leftAnchor,
                          right: cardView.rightAnchor,
                          paddingTop: 45, paddingLeft: 0, paddingRight: 0)
        
        imagePromo.widthEqualToMultiplier(inView: self, multiplier: 9.0 / 16.0)
        
        cardView.addSubview(imageLogo)
        imageLogo.anchor(top: imagePromo.topAnchor, left: imagePromo.leftAnchor, right: imagePromo.rightAnchor, bottom: imagePromo.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        
        cardView.addSubview(buttonMore)
        buttonMore.anchor(top: imagePromo.bottomAnchor,right: cardView.rightAnchor, paddingTop: 5,paddingRight: 10,width: 24,height: 24)
        
        cardView.addSubview(labelStreamInfo)
        labelStreamInfo.anchor(top: imagePromo.bottomAnchor,  left: cardView.leftAnchor,right: buttonMore.leftAnchor,paddingTop: 11, paddingLeft: 16, paddingRight: 2)
        
        cardView.addSubview(labelLike)
        labelLike.anchor(top: imagePromo.bottomAnchor,right: cardView.rightAnchor, paddingTop: 30, paddingRight: 10, width: 24, height: 24)

        cardView.addSubview(buttonLike)
        buttonLike.anchor(top: imagePromo.bottomAnchor,right: labelLike.leftAnchor, paddingTop: 30, paddingRight: 0, width: 24, height: 24)

        cardView.addSubview(buttonChat)
        buttonChat.anchor(right: buttonLike.leftAnchor,paddingRight: 5,width: 24, height: 24)
        buttonChat.centerY(inView: buttonLike)

        cardView.addSubview(imageLogoProfile)
        imageLogoProfile.anchor(top: labelStreamInfo.bottomAnchor, left: cardView.leftAnchor,  paddingTop: 5, paddingLeft: 16, width: 24, height: 24)
        
        cardView.addSubview(labelStreamDescription)
        labelStreamDescription.anchor(left: imageLogoProfile.rightAnchor,paddingLeft: 5,width: 100)
        labelStreamDescription.centerY(inView: imageLogoProfile)

        cardView.addSubview(labelCategory)
        labelCategory.anchor( left: labelStreamDescription.rightAnchor, right: buttonChat.leftAnchor, paddingLeft: 0,paddingRight: 5)
        labelCategory.centerY(inView: labelStreamDescription)
      
        cardView.addSubview(tableView)
        tableView.anchor(top: labelStreamDescription.bottomAnchor,left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)


       

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
    }
    func setLabel(description: String,category: String) {
        labelStreamDescription.text = description
    }
    func setImagePromo(image:String) {
        let url = URL(string: image)
        imageLogo.kf.setImage(with: url)
    }
    
    required init?(coder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    

}

