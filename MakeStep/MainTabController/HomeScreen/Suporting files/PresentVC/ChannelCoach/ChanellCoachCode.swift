//
//  ChanellCoachCode.swift
//  MakeStep
//
//  Created by Sergey on 24.02.2022.
//

import Foundation
import UIKit
import HHCustomCorner
import Kingfisher
import MMPlayerView
import AVFoundation
import TagListView

final class ChanellCoachCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F6F6F6")
        return view
        }()
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

    var imageLogo: UIImageView = {
        let image = UIImageView()
        image.isHidden =  true
        return image
    }()
    var imagePromo: UIView = {
        var image = UIView()
        image.isHidden =  true
        return image
    }()

    var imageLogoProfile: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Group 17091")
        return image
    }()
    var labelStreamInfo: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hexString: "#000000")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Stream information"
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()
  
    var buttonMore: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Menu Kebab1"), for: .normal)
        button.isHidden = true
        return button
    }()
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    var labelFollow : UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hexString: "#7C7C7C")
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    var segmentControll: CustomSegmentedControl = {
        let segment = CustomSegmentedControl()
        segment.backgroundColor = UIColor(hexString: "#F6F6F6")
        return segment
        
    }()
    var buttonHelpCoach: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8"), for: .normal)
        return button
    }()
    var buttonSubscribe: UIButton = {
        var button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
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
    var buttonLandScape: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "enlarge"), for: .normal)
        return button
    }()
  
    var buttonSetting: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "settings1-1"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    var buttonVolum: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "volume-11"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(hexString: "#F9FAFC")
        return table
    }()
    var buttonChat: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "ChatPlayer"), for: .normal)
        return button
    }()
    var overlay : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        view.layer.borderWidth = 0.5
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.gray.cgColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.isHidden = true
        return view
    }()
    var labelLive: UILabel = {
        let label = UILabel()
        label.text = "Live"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    var imageLive: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "slider")
        image.isHidden = true
        return image
        
    }()
    var imageEye: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "eye")
        image.isHidden = true
        return image
        
    }()
    var labelEye: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
  
    var imageLogoProfileBottom: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Group 17091")
        return image
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
 
    var labelNameCoach: UILabel = {
        var label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
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
                          paddingTop: 110, paddingLeft: 0, paddingRight: 0)
        
        imagePromo.widthEqualToMultiplier(inView: self, multiplier: 9.0 / 16.0)
        
        cardView.addSubview(imageLogo)
        imageLogo.anchor(top: imagePromo.topAnchor, left: imagePromo.leftAnchor, right: imagePromo.rightAnchor, bottom: imagePromo.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        

        cardView.addSubview(buttonMore)
        buttonMore.anchor(top: imagePromo.bottomAnchor,right: cardView.rightAnchor, paddingTop: 5, paddingRight: 10, width: 24, height: 24)
        
        cardView.addSubview(labelStreamInfo)
               labelStreamInfo.anchor(top: imagePromo.bottomAnchor,
                                      left: cardView.leftAnchor, right: buttonMore.leftAnchor,
                                      paddingTop: 11, paddingLeft: 16, paddingRight: 5)
        
        cardView.addSubview(imageLogoProfileBottom)
        imageLogoProfileBottom.anchor(top: labelStreamInfo.bottomAnchor, left: cardView.leftAnchor,  paddingTop: 5, paddingLeft: 16, width: 24, height: 24)
        
        cardView.addSubview(labelNameCoach)
        labelNameCoach.anchor(left: imageLogoProfileBottom.rightAnchor,paddingLeft: 5,width: 120)
        labelNameCoach.centerY(inView: imageLogoProfileBottom)

        cardView.addSubview(labelCategory)
        labelCategory.anchor( left: labelNameCoach.rightAnchor, right: cardView.rightAnchor, paddingLeft: 0,paddingRight: 10)
        labelCategory.centerY(inView: labelNameCoach)
        
        cardView.addSubview(overlay)
        overlay.anchor(top: imagePromo.topAnchor,
                       left: imagePromo.leftAnchor,
                       paddingTop: 8, paddingLeft: 16,  width: 90, height: 24)
        
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
        labelEye.centerY(inView: overlay)
   

    }
    func setImage(image:String) {
        let url = URL(string: image)
        imageLogoProfile.kf.setImage(with: url)
        imageLogoProfileBottom.kf.setImage(with: url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

