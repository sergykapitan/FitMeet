//
//  ChatCell.swift
//  MakeStep
//
//  Created by novotorica on 04.07.2021.
//

import UIKit
import Kingfisher

enum MessageSender:String, Codable {
  case ourself
  case someoneElse
}

class ChatCell: BaseCell {
    
    static let reuseID = "ChatCell"
    
    var messageSender: MessageSender = .ourself
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
      //  view.backgroundColor = .clear
            return view
        }()
    var logoUserImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.backgroundColor = .red
        return image
        
    }()
    var bgView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var topLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var bottomLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var timeLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var statusLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var textView: UITextView = {
        let v = UITextView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
 
    var labelChatMessage: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    var labelMessageDetail : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()

    
    let extraSpacing: CGFloat = 80
    
    let innerSpacing: CGFloat = 4
    
    let padding: CGFloat = 16
    
    let secondaryPadding: CGFloat = 8
    
    var textviewTopConstraintToBg: NSLayoutConstraint!
    
    var textviewTopConstraintToTopLabel: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if let id = reuseIdentifier {
            if id == "senderCellId" {
                self.setupSendersCell()
            }else {
                self.setupReceiversCell()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImageLogo(image:String) {
        let url = URL(string: image)
        logoUserImage.kf.setImage(with: url)
       
    }
    func setupSendersCell() {
        print("setupSendersCell")
        let offset = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: -5)
       
        self.contentView.addSubview(bgView)
    
        bgView.edges([.right, .top, .bottom], to: self.contentView, offset: offset)
        
        bgView.layer.cornerRadius = 10
        bgView.backgroundColor = .gray
        
        self.bgView.addSubview(logoUserImage)
        logoUserImage.anchor(top: self.bgView.topAnchor, left: self.bgView.leftAnchor, paddingTop: 0, paddingLeft: 0, width: 20, height: 20)
        
        
        
        self.bgView.addSubview(topLabel)
        topLabel.edges([.left, .top], to: self.bgView, offset: UIEdgeInsets(top: secondaryPadding + 10, left: secondaryPadding, bottom: 0, right: 0))
        topLabel.font = UIFont.boldSystemFont(ofSize: 14)
        topLabel.textColor = .black
     
 
        self.bgView.addSubview(textView)
        textView.edges([.left,.right,.top ], to: self.bgView, offset: .init(top: padding + 10 , left: secondaryPadding - 5, bottom: -innerSpacing, right: -innerSpacing))
        topLabel.trailingAnchor.constraint(lessThanOrEqualTo: textView.trailingAnchor, constant: 0).isActive = true
        bgView.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.backgroundColor = UIColor.clear
       
        self.bgView.addSubview(bottomLabel)
        bottomLabel.edges([.left, .bottom], to: self.bgView, offset: UIEdgeInsets(top: innerSpacing, left: secondaryPadding, bottom: -secondaryPadding, right: 0))
        bottomLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -secondaryPadding).isActive = true
        bottomLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: -2).isActive = true
        bottomLabel.font = UIFont.systemFont(ofSize: 10)
        bottomLabel.textColor = .black
        bottomLabel.textAlignment = .right
    }
    
    func setupReceiversCell() {
        let offset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        self.contentView.addSubview(bgView)
        bgView.edges([.left,.right, .top, .bottom], to: self.contentView, offset: offset)

        bgView.layer.cornerRadius = 0
        bgView.backgroundColor = .white
        
        self.bgView.addSubview(logoUserImage)
        logoUserImage.anchor(top: self.bgView.topAnchor, left: self.bgView.leftAnchor, paddingTop: 2, paddingLeft: 2, width: 20, height: 20)
        
        self.bgView.addSubview(timeLabel)
        timeLabel.anchor( left: logoUserImage.rightAnchor, paddingLeft: 5)
        timeLabel.centerY(inView: logoUserImage)
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textColor = UIColor.lightGray
        
        self.bgView.addSubview(topLabel)
        topLabel.anchor( left: timeLabel.rightAnchor, paddingLeft: 5)
        topLabel.centerY(inView: logoUserImage)
        topLabel.font = UIFont.boldSystemFont(ofSize: 11)
        topLabel.textColor = .black
        
        
        self.bgView.addSubview(textView)
        textviewTopConstraintToTopLabel = textView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 0)
        textviewTopConstraintToTopLabel.isActive = true
        textviewTopConstraintToBg = textView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: innerSpacing)
        textviewTopConstraintToBg.isActive = false
        textView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 24).isActive = true
        textView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -innerSpacing).isActive = true
        topLabel.trailingAnchor.constraint(lessThanOrEqualTo: textView.trailingAnchor, constant: 0).isActive = true
        bgView.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -extraSpacing).isActive = true
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.font = UIFont.systemFont(ofSize: 11)
        textView.backgroundColor = UIColor.clear
        
        self.bgView.addSubview(bottomLabel)
        bottomLabel.edges([.left, .bottom], to: self.bgView, offset: UIEdgeInsets(top: innerSpacing, left: secondaryPadding, bottom: -secondaryPadding, right: 0))
        bottomLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -secondaryPadding).isActive = true
        bottomLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: -2).isActive = true
        bottomLabel.font = UIFont.systemFont(ofSize: 10)
        bottomLabel.textColor = UIColor.lightGray
        bottomLabel.textAlignment = .right
    }
    
}
