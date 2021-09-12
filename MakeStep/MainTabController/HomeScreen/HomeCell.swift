//
//  HomeCell.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import UIKit
import Kingfisher

//protocol NewsfeedCodeCellDelegate: AnyObject {
//    func reavalPost(for cell: HomeCell)
//}

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
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.red.cgColor
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        return image
        
    }()
    let bottomView : UIView = {
        let view = UIView()
        return view
    }()
    let buttonLike: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Like-1"), for: .normal)
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
        logoUserImage.anchor(top: bottomView.topAnchor, left: bottomView.leftAnchor,paddingTop: 8, paddingLeft: 16,width: 24,height: 24)
        
        bottomView.addSubview(titleLabel)
        titleLabel.anchor(top: bottomView.topAnchor, left: logoUserImage.rightAnchor, paddingTop: 8, paddingLeft: 8)
        
        bottomView.addSubview(buttonMore)
        buttonMore.anchor(top: bottomView.topAnchor, right: bottomView.rightAnchor ,paddingTop: 8,paddingRight: 26,width: 40)
        
        bottomView.addSubview(buttonLike)
        buttonLike.anchor(top:  bottomView.topAnchor, right: buttonMore.leftAnchor, paddingTop: 8, paddingRight: 2)
        
        bottomView.addSubview(labelDescription)
        labelDescription.anchor(top: titleLabel.bottomAnchor, left: logoUserImage.rightAnchor,right: contentView.rightAnchor , paddingTop: 8, paddingLeft: 8,paddingRight: 16)
        
        bottomView.addSubview(labelCategory)
        labelCategory.anchor(top: labelDescription.bottomAnchor, left: logoUserImage.rightAnchor,paddingTop: 8, paddingLeft: 8)
        
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
        self.backgroundImage.image = nil
        self.titleLabel.text = nil
        
        
        
       }

}
