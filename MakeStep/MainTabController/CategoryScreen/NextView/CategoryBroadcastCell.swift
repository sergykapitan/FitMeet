//
//  CategoryBroadcastCell.swift
//  FitMeet
//
//  Created by novotorica on 10.06.2021.
//

import Foundation
import UIKit
import Kingfisher

class CategoryBroadcastCell: UITableViewCell {
    
    static let reuseID = "CategoryBroadcastCell"
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
            return view
        }()
    var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        return image
        
    }()
    let logoUserImage: UIImageView = {
        let image = UIImageView()
       // image.layer.borderWidth = 1
       // image.layer.masksToBounds = false
       // image.layer.borderColor = UIColor.red.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.image = UIImage(named: "avatar")
        image.clipsToBounds = true
        return image
        
    }()
    let buttonLike: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
        return button
    }()
    let buttonMore: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "More"), for: .normal)
        return button
    }()
    var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        return label
    }()
    var labelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(hexString: "#252525")
        return label
    }()
    var labelCategory : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }

    func initialize() {
        addSubview(cardView)
       // cardView.fillSuperview()
        cardView.fillFull(for: self)
        cardView.addSubview(backgroundImage)
        backgroundImage.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 0, paddingLeft: 0, paddingRight: 0,height:208)
        cardView.addSubview(logoUserImage)
        logoUserImage.anchor(top: backgroundImage.bottomAnchor, left: cardView.leftAnchor,paddingTop: 8, paddingLeft: 16,width: 24,height: 24)
        cardView.addSubview(titleLabel)
        titleLabel.anchor(top: backgroundImage.bottomAnchor, left: logoUserImage.rightAnchor, paddingTop: 8, paddingLeft: 8)
        cardView.addSubview(buttonMore)
        buttonMore.anchor(top: backgroundImage.bottomAnchor, right: cardView.rightAnchor ,paddingTop: 8,paddingRight: 26)
        cardView.addSubview(buttonLike)
        buttonLike.anchor(top:  backgroundImage.bottomAnchor, right: buttonMore.leftAnchor, paddingTop: 8, paddingRight: 20)
        cardView.addSubview(labelDescription)
        labelDescription.anchor(top: titleLabel.bottomAnchor, left: logoUserImage.rightAnchor,right: cardView.rightAnchor , paddingTop: 8, paddingLeft: 8,paddingRight: 16)
        cardView.addSubview(labelCategory)
        labelCategory.anchor(top: labelDescription.bottomAnchor, left: logoUserImage.rightAnchor,paddingTop: 8, paddingLeft: 8)
   
    }
    func setImage(image:String) {
        let url = URL(string: image)
        backgroundImage.kf.setImage(with: url)
    }
    override func prepareForReuse() {
           super.prepareForReuse()
        self.backgroundImage.image = nil
        self.titleLabel.text = nil
        
        
        
       }

}
