//
//  PresentCode.swift
//  MakeStep
//
//  Created by novotorica on 10.08.2021.
//

import Foundation

import Foundation
import UIKit
import HHCustomCorner
import Kingfisher
import TagListView

final class PresentCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F6F6F6")
        return view
        }()
    //HHCustomCornerView
    var viewTop: HHCustomCornerView = {
        var view = HHCustomCornerView()
        view.radiusLowerLeftCorner = 20
        view.radiusLowerRightCorner = 20
        view.radiusUpperLeftCorner = 0
        view.radiusUpperRightCorner = 0
        view.fillColor = .white
        view.backgroundColor = .clear
        return view
    }()

    var buttonHelp: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8"), for: .normal)
        return button
    }()
    var buttonHelpCoach: UIButton = {
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
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    var labelFollow : UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    var segmentControll: SegmentCustomFull = {
        let segment = SegmentCustomFull()
        segment.backgroundColor = UIColor(hexString: "#F6F6F6")
        return segment
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
    var imagePromo: UIView = {
        var image = UIView()
        return image
    }()
    var imagePromoN: UIView = {
        var image = UIView()
        return image
    }()
    var imageBack: UIImageView = {
        var image = UIImageView()
        return image
    }()
    var buttonLandScape: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "enlarge"), for: .normal)
        return button
    }()
    var buttonSetting: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Settings"), for: .normal)
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
        return label
    }()
    var labelStreamDescription: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hexString: "#000000")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    var viewChat: UIView = {
        var view = UIView()
        return view
    }()
    var buttonChat: UIButton = {
        var button = UIButton()
        return button
    }()
    var imageChat: UIImageView = {
        let image = UIImageView()
        image.image =  #imageLiteral(resourceName: "icons8-expand-arrow-100")
        image.tintColor = .black
        return image
        }()
    var labelChat: UILabel = {
        let label = UILabel()
        label.text = "Comments"
        label.textColor = .black
        return label
    }()
    var buttonChatUser: UIButton = {
        var button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "Open Chat1"), for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    var labelNameBroadcast: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        return label
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
        return label
    }()
    var buttonSubscribe: UIButton = {
        var button = UIButton()
      //  button.setTitle("Subscribers", for: .normal)
      //  button.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
       // button.backgroundColor = .white //UIColor(hexString: "#DADADA")
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)       
        button.layer.borderWidth = 1
        button.layer.masksToBounds = false
        button.layer.borderColor = UIColor(hexString: "#3B58A4").cgColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()
    var buttonFollow: UIButton = {
        var button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .white//UIColor(hexString: "#DADADA")
        button.layer.borderWidth = 1
        button.layer.masksToBounds = false
        button.layer.borderColor = UIColor(hexString: "#3B58A4").cgColor
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
    var buttonLike: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
        return button
    }()
    var buttonMore: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Menu Kebab1"), for: .normal)
        return button
    }()
    let selfView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
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
 
        cardView.addSubview(segmentControll)
        segmentControll.anchor(top: cardView.topAnchor,
                               left: cardView.leftAnchor,
                               paddingTop: 115, paddingLeft: 20, height: 30)

        cardView.addSubview(buttonOnline)
        buttonOnline.anchor(top: segmentControll.bottomAnchor,
                            left: cardView.leftAnchor,
                            paddingTop: 15, paddingLeft: 20, width: 74, height: 26)
        
        

        cardView.addSubview(buttonOffline)
        buttonOffline.anchor(top: segmentControll.bottomAnchor,
                             left: buttonOnline.rightAnchor,
                             paddingTop: 15, paddingLeft: 10, width: 74, height: 26)
        
        cardView.addSubview(buttonComing)
        buttonComing.anchor(top: segmentControll.bottomAnchor,
                            left: buttonOffline.rightAnchor,
                            paddingTop: 15, paddingLeft: 10, width: 74, height: 26)
        
        cardView.addSubview(tableView)
               tableView.anchor(top: segmentControll.bottomAnchor,
                                left: cardView.leftAnchor,
                                right: cardView.rightAnchor,
                                bottom: cardView.bottomAnchor,
                                paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)

        cardView.addSubview(imagePromo)
        imagePromo.anchor(top: buttonComing.bottomAnchor,
                          left: cardView.leftAnchor,
                          right: cardView.rightAnchor,
                          paddingTop: 15, paddingLeft: 0, paddingRight: 0,height: 208 )//
        
        cardView.addSubview(buttonMore)
                buttonMore.anchor(top: imagePromo.bottomAnchor,right: cardView.rightAnchor, paddingTop: 11, paddingRight: 0, width: 40, height: 24)

        cardView.addSubview(buttonLike)
                buttonLike.anchor(top: imagePromo.bottomAnchor,right: buttonMore.leftAnchor, paddingTop: 11, paddingRight: 0, width: 24, height: 24)
        
        cardView.addSubview(labelNameBroadcast)
        labelNameBroadcast.anchor(top: imagePromo.bottomAnchor,
                             left: cardView.leftAnchor,
                             right: buttonLike.rightAnchor,
                             paddingTop: 11, paddingLeft: 16,paddingRight: 10)
        cardView.addSubview(labelCategory)
        labelCategory.anchor(top: labelNameBroadcast.bottomAnchor,
                             left: cardView.leftAnchor,
                             right: buttonLike.rightAnchor,
                             paddingTop: 0, paddingLeft: 16,paddingRight: 10)
        
        cardView.addSubview(labelStreamInfo)
        labelStreamInfo.anchor(top: labelCategory.bottomAnchor,
                               left: cardView.leftAnchor,
                               paddingTop: 9, paddingLeft: 16)
        
        cardView.addSubview(labelStreamDescription)
        labelStreamDescription.anchor(top: labelStreamInfo.bottomAnchor,
                                      left: cardView.leftAnchor,
                                      right: cardView.rightAnchor,
                                      paddingTop: 4, paddingLeft: 16, paddingRight: 16)
        
        cardView.addSubview(buttonChat)
        buttonChat.anchor(left:cardView.leftAnchor,paddingLeft: 15,width: 80, height: 30)
        
        buttonChat.addSubview(imageChat)
        imageChat.anchor(left: buttonChat.leftAnchor,  paddingLeft: 10,width: 15,height: 15)
        imageChat.centerY(inView: buttonChat)
        
        buttonChat.addSubview(labelChat)
        labelChat.anchor( left: imageChat.rightAnchor, paddingLeft: 10)
        labelChat.centerY(inView: buttonChat)
        
        cardView.addSubview(viewChat)
        viewChat.anchor(top: labelStreamDescription.bottomAnchor,
                        left: cardView.leftAnchor,
                        right: cardView.rightAnchor,
                        bottom: cardView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        
        cardView.addSubview(selfView)
        selfView.anchor(top: buttonOnline.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 16, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        
        cardView.addSubview(labelNotToken)
        labelNotToken.anchor( left: cardView.leftAnchor, right: cardView.rightAnchor,  paddingLeft: 16, paddingRight: 16)
        labelNotToken.centerY(inView: cardView)
        labelNotToken.centerX(inView: cardView)
        
       
        
        
        
        
        
        
        
    

    }
    func setImage(image:String) {
        let url = URL(string: image)       
        imageLogoProfile.kf.setImage(with: url)
    }
    func setLabel(description: String,category: String) {
       // labelCategory.text = category
        labelStreamDescription.text = description
    }
    
    
    required init?(coder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    

}

