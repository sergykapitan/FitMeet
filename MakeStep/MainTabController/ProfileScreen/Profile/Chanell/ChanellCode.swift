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
import MMPlayerView
import AVFoundation

final class ChanellCode: UIView {

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
        button.setTitle("Edit Channel", for: .normal)
        button.setTitleColor(.blueColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .white //UIColor(hexString: "#DADADA")
        button.layer.borderWidth = 1
        button.layer.masksToBounds = false
        button.layer.borderColor =  UIColor(hexString: "#0066FF").cgColor
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
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(hexString: "#F9FAFC")
        return table
    }()
//    let selfView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor(hexString: "#F6F6F6")
//        return view
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

        cardView.fillFull(for: self)
        cardView.addSubview(tableView)
        tableView.anchor(top: cardView.topAnchor,
                         left: cardView.leftAnchor,
                         right: cardView.rightAnchor,
                         bottom: cardView.bottomAnchor, paddingTop: 110, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
  
    

    }
    func setImage(image:String) {
        let url = URL(string: image)
        imageLogoProfile.kf.setImage(with: url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

