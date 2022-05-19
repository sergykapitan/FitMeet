//
//  SendVCCell.swift
//  MakeStep
//
//  Created by novotorica on 23.08.2021.
//

import Foundation
import UIKit
import Kingfisher



final class SendVCCell: UITableViewCell {
    
    static let reuseID = "SendVCCell"


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
  
        contentView.addSubview(labelCategory)
        labelCategory.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 0, paddingLeft: 8)
        
    }

}
