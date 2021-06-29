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
    
    var cardView: UIView = {
        let view = UIView()
        return view
    }()
    
    var titleLabel: UILabel =  {
        let label = UILabel()
        return label
    }()
    var descriptionLabel: UILabel =  {
        let label = UILabel()
        return label
    }()
    var nameLabel: UILabel =  {
        let label = UILabel()
        return label
    }()
    var imageChanell: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        return image
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
        addSubview(cardView)
        cardView.fillFull(for: self)
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(nameLabel)
        cardView.addSubview(imageChanell)
        
        titleLabel.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 4, paddingLeft: 15)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: cardView.leftAnchor, paddingTop: 4, paddingLeft: 15)
        nameLabel.anchor(top: descriptionLabel.bottomAnchor, left: cardView.leftAnchor, paddingTop: 4, paddingLeft: 15)
        imageChanell.anchor(top: cardView.topAnchor,right: cardView.leftAnchor, bottom: cardView.bottomAnchor, paddingTop: 4,  paddingRight: 4, paddingBottom: 4, width: 80, height: 80)
        
    }
    override func prepareForReuse() {
           super.prepareForReuse()
        
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
        self.nameLabel.text = nil
       }
    
}
