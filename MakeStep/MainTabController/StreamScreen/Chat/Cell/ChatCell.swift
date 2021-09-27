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
    
    var bgView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
      //  v.backgroundColor = .clear
        return v
    }()
    var topLabel: UILabel = {
        let v = UILabel()
       // v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var bottomLabel: UILabel = {
        let v = UILabel()
       // v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var statusLabel: UILabel = {
        let v = UILabel()
       // v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var textView: UITextView = {
        let v = UITextView()
       // v.backgroundColor = .clear
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
       // label.backgroundColor = .lightGray
        return label
    }()
    
//    var showTopLabel = true {
//        didSet {
//            textviewTopConstraintToBg.isActive = !showTopLabel
//            textviewTopConstraintToTopLabel.isActive = showTopLabel
//            topLabel.isHidden = !showTopLabel
//        }
//    }
    
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

//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//       // self.initialize()
//    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    func initialize() {
       
    
//        contentView.addSubview(labelChatMessage)
//        labelChatMessage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor,paddingTop: 5, paddingLeft: 5, paddingRight: 5)
//
//        contentView.addSubview(labelMessageDetail)
//        labelMessageDetail.anchor(top: labelChatMessage.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor,bottom: contentView.bottomAnchor,paddingTop: 5, paddingLeft: 5, paddingRight: 5,paddingBottom: 5)
   
    }
    
    func setupSendersCell() {
        print("setupSendersCell")
        let offset = UIEdgeInsets(top: 2, left: padding, bottom: 2, right: -padding)
       
        self.contentView.addSubview(bgView)        
        bgView.edges([.right, .top, .bottom], to: self.contentView, offset: offset)
        
        bgView.layer.cornerRadius = 10
       // bgView.backgroundColor = UIColor(red: 0.231, green: 0.345, blue: 0.643, alpha: 0.3)
        bgView.backgroundColor = UIColor(hexString: "#3B58A4")
        
        
        self.bgView.addSubview(topLabel)
        topLabel.edges([.left, .top], to: self.bgView, offset: UIEdgeInsets(top: secondaryPadding, left: secondaryPadding, bottom: 0, right: 0))
        topLabel.font = UIFont.boldSystemFont(ofSize: 14)
        topLabel.textColor = .white
     
 
        self.bgView.addSubview(textView)
        textView.edges([.left,.right,.top ], to: self.bgView, offset: .init(top: padding + 10 , left: secondaryPadding - 5, bottom: -innerSpacing, right: -innerSpacing))
        topLabel.trailingAnchor.constraint(lessThanOrEqualTo: textView.trailingAnchor, constant: 0).isActive = true
        bgView.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.clear
       
        self.bgView.addSubview(bottomLabel)
        bottomLabel.edges([.left, .bottom], to: self.bgView, offset: UIEdgeInsets(top: innerSpacing, left: secondaryPadding, bottom: -secondaryPadding, right: 0))
        bottomLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -secondaryPadding).isActive = true
        bottomLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: -2).isActive = true
        bottomLabel.font = UIFont.systemFont(ofSize: 10)
        bottomLabel.textColor = UIColor.white
        bottomLabel.textAlignment = .right
    }
    
    func setupReceiversCell() {
        print("setupReceiversCell")
        let offset = UIEdgeInsets(top: 5, left: padding, bottom: 0, right: -padding)
        self.contentView.addSubview(bgView)
       // self.contentView.backgroundColor = .red
        bgView.edges([.left, .top, .bottom], to: self.contentView, offset: offset)

        bgView.layer.cornerRadius = 8
        bgView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        self.bgView.addSubview(topLabel)
        topLabel.edges([.left, .top], to: self.bgView, offset: UIEdgeInsets(top: secondaryPadding, left: secondaryPadding, bottom: 0, right: 0))
        topLabel.font = UIFont.boldSystemFont(ofSize: 14)
        topLabel.textColor = .blue
        
        
        self.bgView.addSubview(textView)
        textviewTopConstraintToTopLabel = textView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 0)
        textviewTopConstraintToTopLabel.isActive = true
        textviewTopConstraintToBg = textView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: innerSpacing)
        textviewTopConstraintToBg.isActive = false
        textView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: innerSpacing).isActive = true
        textView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -innerSpacing).isActive = true
        topLabel.trailingAnchor.constraint(lessThanOrEqualTo: textView.trailingAnchor, constant: 0).isActive = true
        bgView.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -extraSpacing).isActive = true
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.font = UIFont.systemFont(ofSize: 14)
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
