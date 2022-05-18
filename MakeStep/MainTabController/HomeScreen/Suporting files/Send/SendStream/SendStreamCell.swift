//
//  SendStreamCell.swift
//  MakeStep
//
//  Created by Sergey on 04.02.2022.
//

import Foundation
import UIKit
import Kingfisher


final class SendStreamCell: UITableViewCell {
    
    static let reuseID = "SendStreamCell"
    var imageCell: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.layer.borderWidth = 0
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.contentMode = .center
        return image
        }()
   
    var labelCategory : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()  
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
        clipsToBounds = true
        contentView.addSubview(imageCell)
        imageCell.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 5, paddingLeft: 8,width: 40,height: 40)
        contentView.addSubview(labelCategory)
        labelCategory.anchor( left: imageCell.rightAnchor, paddingLeft: 19)
        labelCategory.centerY(inView: imageCell)
    }
}
