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
        
        cardView.addSubview(buttonOnline)
               buttonOnline.anchor(top: segmentControll.bottomAnchor, left: cardView.leftAnchor, paddingTop: 15, paddingLeft: 20, width: 74, height: 26)
               
        cardView.addSubview(tableView)
        tableView.anchor(top: buttonOnline.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, bottom: cardView.bottomAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
               

       
        cardView.addSubview(buttonOffline)
        buttonOffline.anchor(top: segmentControll.bottomAnchor, left: buttonOnline.rightAnchor, paddingTop: 15, paddingLeft: 10, width: 74, height: 26)
        
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

