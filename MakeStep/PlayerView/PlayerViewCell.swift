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
        image.isSkeletonable = true
        return image
        
    }()
    var logoUserImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = false
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
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.isSkeletonable = true
        var intS : Int = 0
        return button
    }()
    var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 0.6)
        label.isSkeletonable = true
        return label
    }()
    var labelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(hexString: "#252525")
        label.isSkeletonable = true
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
  
    let buttonLandscape: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "fullscreen"), for: .normal)
        button.tintColor = .opaqueSeparator
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
        selectionStyle = .none
        [backgroundImage,labelDescription].forEach{
            $0.showAnimatedGradientSkeleton()
        }
        buttonMore.alpha = 0
    }
    func hideAnimation() {
        [backgroundImage,labelDescription].forEach{
            $0.hideSkeleton()
        }
        buttonMore.alpha = 1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
        clipsToBounds = true
        contentView.addSubview(backgroundImage)
        backgroundImage.anchor(top: contentView.topAnchor,
                               left: contentView.leftAnchor,
                               bottom: contentView.bottomAnchor,
                               paddingTop: 5, paddingLeft: 18,paddingBottom: 5,width: contentView.bounds.width / 2,height: (contentView.bounds.width / 1.9) / 1.8)
        contentView.addSubview(buttonMore)
        buttonMore.anchor(right: contentView.rightAnchor ,
                          bottom: contentView.bottomAnchor,
                          paddingRight: 4,paddingBottom: 2,width: 40, height: 40)
        
        contentView.addSubview(labelDescription)
        labelDescription.anchor(top: contentView.topAnchor,
                                        left: backgroundImage.rightAnchor,
                                        right: contentView.rightAnchor,
                                        paddingTop: 8, paddingLeft: 8 ,paddingRight: 3,width: 400)
        contentView.addSubview(titleLabel)
        titleLabel.anchor(left: backgroundImage.rightAnchor,
                          right: buttonMore.leftAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingLeft: 8,paddingRight: 8, paddingBottom: 8,width: 300)
    }
    func setImage(image:String) {
        let url = URL(string: image)
        backgroundImage.kf.setImage(with: url)
    }
    func setImageLogo(image:String) {
        let url = URL(string: image)
        logoUserImage.kf.setImage(with: url)
       
    }
    func setupImage(urlString: String) {
        self.backgroundImage.image = nil
        
        if let imageUrl = URL(string: urlString) {
            backgroundImage.kf.setImage(with: imageUrl, options: [.retryStrategy(DelayRetryStrategy(maxRetryCount: 5, retryInterval: .seconds(1)))]) { result in
                switch result {
                case .success(_): print("TO DO:")
                case .failure(_): print("Fail")
                }
            }
        }
    }
    override func prepareForReuse() {
           super.prepareForReuse()
        self.accessoryType = .none
        self.backgroundImage.image = nil
     //   self.logoUserImage.image = nil
        data = nil
       } 
}
