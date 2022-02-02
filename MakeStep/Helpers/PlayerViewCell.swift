//
//  PlayerViewCell.swift
//  MakeStep
//
//  Created by Sergey on 14.10.2021.
//

import UIKit
import AVKit
import AVFoundation
import Kingfisher
import TagListView


final class PlayerViewCell: UITableViewCell {
    static let reuseID = "PlayerViewCell"

        var data:BroadcastResponce? {
            didSet {
                guard let Url = data?.previewPath, let urlVOD = data?.streams?.first?.vodUrl else { return }
                let url = URL(string: Url)
                self.backgroundImage.kf.setImage(with: url)
                
                       
            }
        }
    
    var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
        
    }()
    var logoUserImage: UIImageView = {
        let image = UIImageView()
       // image.layer.borderWidth = 1
        image.layer.masksToBounds = false
       // image.layer.borderColor = UIColor.red.cgColor
        image.clipsToBounds = true
        image.layer.cornerRadius = 18
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
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.isUserInteractionEnabled = true
        label.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        return label
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
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    var tagView: TagListView = {
        let tag = TagListView()
        tag.textFont = UIFont.systemFont(ofSize: 12)
        tag.tagBackgroundColor = .clear
        tag.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        tag.selectedTextColor = .black
        tag.paddingX = 0
        return tag
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
    let buttonLandscape: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "fullscreen"), for: .normal)
        button.tintColor = .opaqueSeparator
        return button
    }()
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
        selectionStyle = .none
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
        clipsToBounds = true
        contentView.addSubview(backgroundImage)
        backgroundImage.anchor(top: contentView.topAnchor,
                               left: contentView.leftAnchor,
                               right: contentView.rightAnchor,
                               paddingTop: 0, paddingLeft: 0, paddingRight: 0,
                               height: 200)

        contentView.addSubview(bottomView)
        bottomView.anchor(top: backgroundImage.bottomAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingTop: 0, paddingLeft: 0,paddingRight: 0,paddingBottom: 0,height: 134)
        
        
        bottomView.addSubview(logoUserImage)
        logoUserImage.anchor(top: bottomView.topAnchor, left: bottomView.leftAnchor,paddingTop: 8, paddingLeft: 16,width: 36,height: 36)
        
        bottomView.addSubview(logoUserOnline)
        logoUserOnline.anchor( right: logoUserImage.rightAnchor, bottom: logoUserImage.bottomAnchor, paddingRight: 0, paddingBottom: 0, width: 8, height: 8)
        
        bottomView.addSubview(titleLabel)
        titleLabel.anchor( left: logoUserImage.rightAnchor, paddingLeft: 8)
        titleLabel.centerY(inView: logoUserImage)
        
        bottomView.addSubview(buttonMore)
        buttonMore.anchor(top: bottomView.topAnchor, right: bottomView.rightAnchor ,paddingTop: 8,paddingRight: 0,width: 40,height: 24)
        
        contentView.addSubview(buttonLike)
        buttonLike.anchor(top:  bottomView.topAnchor, right: buttonMore.leftAnchor, paddingTop: 8, paddingRight: 0,width: 24,height: 24)
        
        bottomView.addSubview(labelDescription)
        labelDescription.anchor(top: logoUserImage.bottomAnchor, left: logoUserImage.rightAnchor,right: contentView.rightAnchor , paddingTop: 0, paddingLeft: 8,paddingRight: 16)

        contentView.addSubview(tagView)
        tagView.anchor(top: labelDescription.bottomAnchor, left: logoUserImage.rightAnchor,right: bottomView.rightAnchor,paddingTop: 0, paddingLeft: 8,paddingRight: 8)
        
        
        
        contentView.addSubview(overlay)
        overlay.anchor(top: contentView.topAnchor,
                       left: contentView.leftAnchor,
                       paddingTop: 8, paddingLeft: 16,  width: 90, height: 24)
        
       
              
        contentView.addSubview(imageLive)
        imageLive.anchor( left: overlay.leftAnchor, paddingLeft: 6, width: 12, height: 12)
        imageLive.centerY(inView: overlay)
        
        contentView.addSubview(labelLive)
        labelLive.anchor( left: imageLive.rightAnchor, paddingLeft: 6)
        labelLive.centerY(inView: overlay)
        
        contentView.addSubview(imageEye)
        imageEye.anchor( left: labelLive.rightAnchor, paddingLeft: 6, width: 12, height: 12)
        imageEye.centerY(inView: overlay)
        
        contentView.addSubview(labelEye)
        labelEye.anchor( left: imageEye.rightAnchor, paddingLeft: 6)
        labelEye.centerY(inView: overlay)
        
        contentView.addSubview(buttonstartStream)
        buttonstartStream.anchor( bottom: backgroundImage.bottomAnchor, paddingBottom: 10, width: 100, height: 26)
        buttonstartStream.centerX(inView: backgroundImage)
        
        contentView.addSubview(label)
        label.anchor( bottom: backgroundImage.bottomAnchor, paddingBottom: 40)
        label.centerX(inView: backgroundImage)
        
        
    }
    func setImage(image:String) {
        let url = URL(string: image)
        backgroundImage.kf.setImage(with: url)
    }
    func setImageLogo(image:String) {
        let url = URL(string: image)
        logoUserImage.kf.setImage(with: url)
       
    }
    override func prepareForReuse() {
           super.prepareForReuse()
        self.accessoryType = .none
        self.backgroundImage.image = nil
        self.logoUserImage.image = nil
       // self.backgroundImage
        data = nil
       } 
}
