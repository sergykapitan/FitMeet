//
//  ChanellCode.swift
//  FitMeet
//
//  Created by novotorica on 29.06.2021.
//


import Foundation
import UIKit
import HHCustomCorner
import Kingfisher

final class ChanellCode: UIView {

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
        view.fillColor = .white
        view.backgroundColor = .clear// UIColor(hexString: "#F6F6F6")
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
        button.setTitle("Offline", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        return button
    }()
    var buttonComing: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("Coming", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        return button
    }()
    var imagePromo: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
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
    var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(hexString: "#F6F6F6")
        return table
    }()
 
    var buttonHelpCoach: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8"), for: .normal)
        return button
    }()
    var buttonSubscribe: UIButton = {
        var button = UIButton()
        button.setTitle("Edit Channel", for: .normal)
        button.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .white //UIColor(hexString: "#DADADA")
        button.layer.borderWidth = 1
        button.layer.masksToBounds = false
        button.layer.borderColor = UIColor(hexString: "#3B58A4").cgColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 14
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
//    var buttonstartStream: UIButton = {
//        var button = UIButton()
//        button.backgroundColor = UIColor(hexString: "#BBBCBC")
//        button.setTitle("StartStream", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        button.layer.cornerRadius = 13
//        return button
//    }()
    
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
        cardView.fillFull(for: self)

 
        cardView.addSubview(segmentControll)
        segmentControll.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 120, paddingLeft: 20, height: 30)
        
    //    cardView.addSubview(buttonOnline)
     //          buttonOnline.anchor(top: segmentControll.bottomAnchor, left: cardView.leftAnchor, paddingTop: 15, paddingLeft: 20, width: 74, height: 26)
               
        cardView.addSubview(buttonOffline)
        buttonOffline.anchor(top: segmentControll.bottomAnchor, left: cardView.leftAnchor, paddingTop: 15, paddingLeft: 10, width: 74, height: 26)
        
        cardView.addSubview(tableView)
        tableView.anchor(top: buttonOffline.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
               

       
        
        
        cardView.addSubview(buttonComing)
        buttonComing.anchor(top: segmentControll.bottomAnchor, left: buttonOffline.rightAnchor, paddingTop: 15, paddingLeft: 10, width: 74, height: 26)
        
        cardView.addSubview(imagePromo)
        imagePromo.anchor(top: buttonComing.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,  paddingTop: 15, paddingLeft: 0, paddingRight: 0, height: 208)
        
        cardView.addSubview(labelCategory)
        labelCategory.anchor(top: imagePromo.bottomAnchor, left: cardView.leftAnchor, paddingTop: 11, paddingLeft: 16)
        
        cardView.addSubview(labelStreamInfo)
        labelStreamInfo.anchor(top: labelCategory.bottomAnchor, left: cardView.leftAnchor,paddingTop: 9, paddingLeft: 16)
        
        cardView.addSubview(labelStreamDescription)
        labelStreamDescription.anchor(top: labelStreamInfo.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16)
        
//        cardView.addSubview(buttonstartStream)
//        buttonstartStream.anchor( bottom: imagePromo.bottomAnchor, paddingBottom: 30, width: 74, height: 26)
//        buttonstartStream.centerX(inView: imagePromo)
        
    

    }
    //,imagepromo: String
    func setImage(image:String) {
        let url = URL(string: image)
    //    let urlPromo = URL(string: imagepromo)
        imageLogoProfile.kf.setImage(with: url)
     //   imagePromo.kf.setImage(with: urlPromo)
    }
    func setLabel(description: String,category: String) {
        labelCategory.text = category
        labelStreamDescription.text = description
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

