//
//  SearchVCCategory.swift
//  FitMeet
//
//  Created by novotorica on 15.06.2021.
//

import Foundation
import UIKit
import Kingfisher

class SearchVCCategory: UITableViewCell {
    
    static let reuseID = "SearchVCCategory"
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
            return view
        }()
    var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        return image
        
    }()
    let logoUserImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "avatar")
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        return image
        
    }()
    let buttonLike: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
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
        cardView.addSubview(logoUserImage)

        cardView.addSubview(labelDescription)
        labelDescription.anchor(top: cardView.topAnchor,
                                left: cardView.leftAnchor,
                                paddingTop: 8, paddingLeft: 18 )

    }
    func setImage(image:String) {
        let url = URL(string: image)
        backgroundImage.kf.setImage(with: url)
    }
    override func prepareForReuse() {
           super.prepareForReuse()
        self.backgroundImage.image = nil
        self.titleLabel.text = nil
        
        
        
       }

}
