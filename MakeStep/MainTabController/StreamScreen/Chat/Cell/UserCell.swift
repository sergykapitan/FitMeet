//
//  UserCell.swift
//  MakeStep
//
//  Created by novotorica on 04.07.2021.
//

import UIKit
import Kingfisher

class UserCell: BaseCell {
    
    static let reuseID = "UserCell"
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
        }()
    
    let imageProfile: UIImageView = {
        let image = UIImageView()
        return image
    }()
 
    var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(hexString: "#FFFFFF")        
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        imageProfile.round()
    }
    override func setNeedsLayout() {
        imageProfile.round()
    }
    override func layoutIfNeeded() {
        imageProfile.round()
    }

    func initialize() {
        addSubview(cardView)
        cardView.fillFull(for: self)
    
        
        cardView.addSubview(imageProfile)
        imageProfile.anchor(left: cardView.leftAnchor, paddingLeft: 10,width: 40,height: 40)
        imageProfile.centerY(inView: cardView)
       
        cardView.addSubview(titleLabel)
        titleLabel.anchor(left: imageProfile.rightAnchor, paddingLeft: 10)
        titleLabel.centerY(inView: cardView)
        
        cardView.addSubview(labelCategory)
        labelCategory.anchor(right: cardView.rightAnchor,paddingRight: 10)
        labelCategory.centerY(inView: cardView)
   
    }
    func setImage(image: String) {
        let url = URL(string: image)
        imageProfile.kf.setImage(with: url)
    }
   

}
