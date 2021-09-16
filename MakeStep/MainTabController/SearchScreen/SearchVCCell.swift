//
//  SearchVCCell.swift
//  FitMeet
//
//  Created by novotorica on 11.06.2021.
//

import UIKit
import Kingfisher

class SearchVCCell: UITableViewCell {
    
    static let reuseID = "SearchVCCell"
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
            return view
        }()
    var backgroundImage: UIImageView = {
        let image = UIImageView()
        return image
        
    }()
    let logoUserImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = image.frame.height/2
        image.image = UIImage(named: "avatar")
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
        cardView.addSubview(backgroundImage)
        backgroundImage.anchor(top: cardView.topAnchor,
                               left: cardView.leftAnchor,
                               bottom: cardView.bottomAnchor,
                               paddingTop: 5, paddingLeft: 18,paddingBottom: 5 ,width: contentView.bounds.width / 2)
        

        cardView.addSubview(titleLabel)
        titleLabel.anchor(left: backgroundImage.rightAnchor,
                          bottom: cardView.bottomAnchor,
                          paddingLeft: 8, paddingBottom: 8 )
        
        cardView.addSubview(labelDescription)
        labelDescription.anchor(top: cardView.topAnchor,
                                left: backgroundImage.rightAnchor,
                                right: cardView.rightAnchor,
                                paddingTop: 8, paddingLeft: 8 ,paddingRight: 8)
        
        cardView.addSubview(buttonMore)
        buttonMore.anchor(right: cardView.rightAnchor ,
                          bottom: cardView.bottomAnchor,
                          paddingRight: 30,paddingBottom: 10)

   
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
