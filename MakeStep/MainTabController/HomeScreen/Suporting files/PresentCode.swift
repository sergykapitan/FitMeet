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

final class PresentCode: UIView {

    //MARK: - First layer in TopView
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F6F6F6")
       // view.clipsToBounds = true
            return view
        }()
    var viewTop: HHCustomCornerView = {
        var view = HHCustomCornerView()
        view.radiusLowerLeftCorner = 20
        view.radiusLowerRightCorner = 20
        view.radiusUpperLeftCorner = 0
        view.radiusUpperRightCorner = 0
       // view.stroke = 2
      //  view.strokeColor = .black
        view.fillColor = .white
        view.backgroundColor = UIColor(hexString: "#F6F6F6")
        return view
    }()
    var imageLogoProfile: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Group 17091")
        return image
    }()
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
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
    var buttonOnline: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("Online", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.cornerRadius = 13
        return button
    }()
    var buttonOffline: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("Offline", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.cornerRadius = 13
        return button
    }()
    var buttonComing: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("Coming", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.cornerRadius = 13
        return button
    }()
    var imagePromo: UIView = {
        var image = UIView()
        image.backgroundColor = .red
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
    
    var labelCategory: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hexString: "#727272")
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Yoga" + " \u{2665} " + "Meditation"
        return label
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
        return label
    }()
    var viewChat: UIView = {
        var view = UIView()
       // view.backgroundColor = .gray
        return view
    }()
    var buttonChat: UIButton = {
        var button = UIButton()
        button.setTitle("Comments", for: .normal)
        button.setTitleColor(.black, for: .normal)
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
        label.text = "123"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
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
        
       // addSubview(cardView)
       // cardView.fillFull(for: self)
        cardView.fillSuperview()
       
        
       
        cardView.addSubview(viewTop)
        viewTop.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0,  height: 100)
        
        viewTop.addSubview(imageLogoProfile)
        imageLogoProfile.anchor( left: viewTop.leftAnchor, paddingLeft: 15,width: 70, height: 70)
        imageLogoProfile.centerY(inView: viewTop)
        
        viewTop.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: imageLogoProfile.centerYAnchor, left: imageLogoProfile.rightAnchor, paddingTop: -20, paddingLeft: 20)
        
        viewTop.addSubview(labelFollow)
        labelFollow.anchor(top: welcomeLabel.bottomAnchor, left: imageLogoProfile.rightAnchor, paddingTop: 5, paddingLeft: 20)
 
        cardView.addSubview(segmentControll)
        segmentControll.anchor(top: viewTop.bottomAnchor, left: cardView.leftAnchor, paddingTop: 15, paddingLeft: 20, height: 30)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: segmentControll.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
               

        cardView.addSubview(buttonOnline)
        buttonOnline.anchor(top: segmentControll.bottomAnchor, left: cardView.leftAnchor, paddingTop: 15, paddingLeft: 20, width: 74, height: 26)
        
        cardView.addSubview(buttonOffline)
        buttonOffline.anchor(top: segmentControll.bottomAnchor, left: buttonOnline.rightAnchor, paddingTop: 15, paddingLeft: 10, width: 74, height: 26)
        
        cardView.addSubview(buttonComing)
        buttonComing.anchor(top: segmentControll.bottomAnchor, left: buttonOffline.rightAnchor, paddingTop: 15, paddingLeft: 10, width: 74, height: 26)
        
        cardView.addSubview(imagePromo)
        imagePromo.anchor(top: buttonComing.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,  paddingTop: 15, paddingLeft: 0, paddingRight: 0, height: 208)
        
//        imagePromo.addSubview(buttonLandScape)
//        buttonLandScape.anchor(  right: imagePromo.rightAnchor, bottom: imagePromo.bottomAnchor, paddingRight: 30, paddingBottom: 30,width: 30,height: 30)
        
        cardView.addSubview(labelCategory)
        labelCategory.anchor(top: imagePromo.bottomAnchor, left: cardView.leftAnchor, paddingTop: 11, paddingLeft: 16)
        
        cardView.addSubview(labelStreamInfo)
        labelStreamInfo.anchor(top: labelCategory.bottomAnchor, left: cardView.leftAnchor,paddingTop: 9, paddingLeft: 16)
        
        cardView.addSubview(labelStreamDescription)
        labelStreamDescription.anchor(top: labelStreamInfo.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16)
        
        cardView.addSubview(buttonChat)
        buttonChat.anchor(bottom: cardView.bottomAnchor,paddingBottom: 5)
        buttonChat.centerX(inView: cardView)
        
        cardView.addSubview(viewChat)
        viewChat.anchor(top: labelStreamDescription.bottomAnchor,
                        left: cardView.leftAnchor,
                        right: cardView.rightAnchor,
                        bottom: cardView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        
    

    }
    func setImage(image:String) {
        let url = URL(string: image)       
        imageLogoProfile.kf.setImage(with: url)
    }
    func setLabel(description: String,category: String) {
        labelCategory.text = category
        labelStreamDescription.text = description
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

