//
//  HomeCell.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import UIKit
import Kingfisher
import TagListView


final class HomeCell: UITableViewCell {
    
    static let reuseID = "HomeCell"

    var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
        
    }()
    var logoUserImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        image.anchor(width: 24,height: 24)
        return image
        
    }()
    var logoUserOnline: UIView = {
        let image = UIView()
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.red.cgColor
        image.clipsToBounds = true
        image.layer.cornerRadius = 4
        image.backgroundColor = .red
        image.isHidden = true
        return image
        
    }()
    let bottomView : UIView = {
        let view = UIView()
        return view
    }()
    let buttonLike: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    let buttonMore: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Menu Kebab1"), for: .normal)
        return button
    }()
    var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        label.sizeToFit()
        return label
    }()
    var labelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(hexString: "#252525")
        label.numberOfLines = 2
        return label
    }()
    var labelCategory : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.isUserInteractionEnabled = true
        label.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        return label
    }()
    var overlay : OverlayLive = {
        let view = OverlayLive()
        return view
    }()
    var overlayPlan : OverlayPlanned = {
        let view = OverlayPlanned()
        return view
    }()
    var overlayOffline : OverlayOffline = {
        let view = OverlayOffline()
        return view
    }()
    
    var buttonLogo: UIButton = {
        let but = UIButton()
        return but
    }()
    var buttonstartStream: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#3B58A4")
        button.setTitle("StartStream", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        button.isHidden = true
        return button
    }()
    var stackButton: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    var tagView: TagListView = {
           let tag = TagListView()
           tag.textFont = UIFont.systemFont(ofSize: 12)
           tag.tagBackgroundColor = .clear
           tag.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
           tag.selectedTextColor = .black
           tag.paddingX = 2
           tag.marginUp = 4
           tag.tagLineBreakMode = .byWordWrapping
           tag.translatesAutoresizingMaskIntoConstraints = false
           return tag
       }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initUI()
        self.initialize()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        stackButton = UIStackView(arrangedSubviews: [logoUserImage,titleLabel])
        stackButton.spacing = 10
 
    }

    func initialize() {
        clipsToBounds = true
        contentView.addSubview(backgroundImage)
        backgroundImage.anchor(top: contentView.topAnchor,
                               left: contentView.leftAnchor,
                               right: contentView.rightAnchor,
                               paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        backgroundImage.widthEqualToMultiplier(inView: self, multiplier: 9.0 / 16.0)
        contentView.addSubview(bottomView)
        bottomView.anchor(top: backgroundImage.bottomAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingTop: 0, paddingLeft: 0,paddingRight: 0,paddingBottom: 0,height: 50)
        
        bottomView.addSubview(buttonMore)
        buttonMore.anchor(top: bottomView.topAnchor, right: bottomView.rightAnchor ,paddingTop: 8,paddingRight: 0,width: 40,height: 24)

        bottomView.addSubview(labelDescription)
        labelDescription.anchor(top: bottomView.topAnchor, left: bottomView.leftAnchor,right: buttonMore.leftAnchor , paddingTop: 8, paddingLeft: 16,paddingRight: 8)
       
        bottomView.addSubview(stackButton)
        stackButton.anchor(top: labelDescription.bottomAnchor, left: bottomView.leftAnchor, paddingTop: 5, paddingLeft: 16)
 
        bottomView.addSubview(tagView)
        tagView.anchor(top: labelDescription.bottomAnchor, left: stackButton.rightAnchor, right: bottomView.rightAnchor, bottom: bottomView.bottomAnchor, paddingTop: 5, paddingLeft: 5, paddingRight: 5, paddingBottom: 5)
        
        contentView.addSubview(overlay)
        overlay.anchor(top: contentView.topAnchor,
                       left: contentView.leftAnchor,
                       paddingTop: 8, paddingLeft: 16,  width: 90, height: 24)
        
        contentView.addSubview(overlayPlan)
        overlayPlan.anchor(top: contentView.topAnchor,
                       left: contentView.leftAnchor,
                       paddingTop: 8, paddingLeft: 16,  width: 90, height: 24)
        
        contentView.addSubview(overlayOffline)
        overlayOffline.anchor(top: contentView.topAnchor,
                       left: contentView.leftAnchor,
                       paddingTop: 8, paddingLeft: 16,  width: 50, height: 24)
 
        
        contentView.addSubview(buttonstartStream)
        buttonstartStream.anchor( bottom: backgroundImage.bottomAnchor, paddingBottom: 30, width: 100, height: 26)
        buttonstartStream.centerX(inView: backgroundImage)
    }
 
    func setImage(image:String) {
        let url = URL(string: image)
        backgroundImage.kf.setImage(with: url,options: [
                    .loadDiskFileSynchronously,
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage,
                    .transition(.fade(0.25))
            
        ])
    }

    func setImageLogo(image:String) {
        let url = URL(string: image)
        logoUserImage.kf.setImage(with: url)
       
    }
    override func prepareForReuse() {
        self.accessoryType = .none
        self.backgroundImage.image = nil
        self.logoUserImage.image = nil
        self.overlay.labelEye.text = nil
        self.titleLabel.text = nil
       }
}
