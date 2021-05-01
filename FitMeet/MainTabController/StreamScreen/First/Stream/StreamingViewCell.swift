//
//  StreamingViewCell.swift
//  FitMeet
//
//  Created by novotorica on 01.05.2021.
//

import Foundation
import UIKit

class StreamingViewCell: UITableViewCell {
    
    static let reuseID = "StreamingViewCell"
    
    var titleLabel: UILabel =  {
        let label = UILabel()
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

    func initialize() {
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        NSLayoutConstraint.activate([
            
            self.contentView.centerXAnchor.constraint(equalTo: self.titleLabel.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
        ])
        
    }
    override func prepareForReuse() {
           super.prepareForReuse()
        
        self.textLabel?.text = nil
        self.detailTextLabel?.text = nil
        self.imageView?.image = nil
       }

}
