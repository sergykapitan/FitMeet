//
//  DropDownCell.swift
//  FitMeet
//
//  Created by novotorica on 18.06.2021.
//

import Foundation
import UIKit

class DropDownCell: UITableViewCell {
    
    var lightColor = UIColor.lightGray
    var cellFont: UIFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(with title: String) {
        self.selectionStyle = .none
        self.textLabel?.font = cellFont
        self.textLabel?.textColor = self.lightColor
        self.backgroundColor = UIColor.clear
        self.textLabel?.text = title
    }
}
