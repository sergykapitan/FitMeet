//
//  ChatCell.swift
//  MakeStep
//
//  Created by novotorica on 04.07.2021.
//

import UIKit
import Kingfisher

class ChatCell: BaseCell {
    
    static let reuseID = "ChatCell"
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
            return view
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initialize() {
        addSubview(cardView)
        cardView.fillSuperviewforCell()

        cardView.addSubview(labelChatMessage)
        labelChatMessage.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 5, paddingLeft: 5, paddingRight: 5)
              
        cardView.addSubview(labelMessageDetail)
        labelMessageDetail.anchor(top: labelChatMessage.bottomAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,bottom: cardView.bottomAnchor,paddingTop: 5, paddingLeft: 5, paddingRight: 5,paddingBottom: 5)       
   
    }
}
