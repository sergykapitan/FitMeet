//
//  TarrifCell.swift
//  MakeStep
//
//  Created by Sergey on 29.10.2021.
//

import Foundation
import Foundation
import UIKit

class TarrifCell: UITableViewCell {

static let reuseID = "AllSaveWorkoutViewCell"

    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var nameMonetezationLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    var descriptionLabel: UILabel =  {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#868686")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        return label
    }()
    var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    var priceLabelright: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor(hexString: "#3B58A4")
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    var buttonDelete: UIButton = {
        let btn = UIButton()
        btn.setImage( UIImage(named: "x1"), for: .normal)
        btn.setImage(UIImage(named: "Vector1"), for: .selected) 
        btn.tintColor = .black
        return btn
    }()
    var imageEdit:UIImageView = {
        let image = UIImageView()
        image.image =  #imageLiteral(resourceName: "edit")
        image.setImageColor(color: UIColor.black)
        return image
        }()
    var labelEdit: UILabel = {
        let label = UILabel()
        label.text = "Edit"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    var buttonEdit: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "#DADADA")
        button.layer.cornerRadius = 14
        return button
    }()
    var buttonDisable: UIButton = {
        let button = UIButton()
        button.setTitle("Disable", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(hexString: "#EE0000")
        button.layer.cornerRadius = 14
        return button
    }()
//    var disableView :UIView = {
//        let view = UIView()
//        view.backgroundColor = .blue
//        view.alpha = 0.6
//       // view.isHidden = true
//        return view
//    }()
    

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
    initUI()
    
}
override func prepareForReuse() {
       super.prepareForReuse()
      self.nameMonetezationLabel.text = nil
      self.descriptionLabel.text = nil
      self.priceLabel.text = nil
   }
    private func initUI() {
//        contentView.addSubview(disableView)
//        disableView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, bottom: contentView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        
        contentView.addSubview(nameMonetezationLabel)
        nameMonetezationLabel.anchor(top:contentView.topAnchor,left: contentView.leftAnchor,
                                 paddingTop: 16,paddingLeft: 16, height: 20)
        
        contentView.addSubview(buttonDelete)
        buttonDelete.anchor(top: contentView.topAnchor,  right: contentView.rightAnchor,
                            paddingTop: 8,paddingRight: 8, width: 40, height: 40)
       
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top:nameMonetezationLabel.bottomAnchor,left: contentView.leftAnchor,right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 16,paddingRight: 16)
        
        contentView.addSubview(priceLabel)
        priceLabel.anchor( left: contentView.leftAnchor,
                            bottom: contentView.bottomAnchor,
                            paddingLeft: 16, paddingBottom: 59,height: 20)
        contentView.addSubview(priceLabelright)
        priceLabelright.anchor( right: contentView.rightAnchor, paddingRight: 16)
        priceLabelright.centerY(inView: priceLabel)
        
        contentView.addSubview(buttonEdit)
        buttonEdit.anchor(right: contentView.rightAnchor,bottom: contentView.bottomAnchor, paddingRight: 16,paddingBottom: 16,width: 79,height: 29)
        
        buttonEdit.addSubview(imageEdit)
        imageEdit.anchor( right: buttonEdit.rightAnchor, paddingRight: 15, width: 12, height: 12)
        imageEdit.centerY(inView: buttonEdit)
        
        buttonEdit.addSubview(labelEdit)
        labelEdit.anchor(right: imageEdit.leftAnchor,paddingRight: 5)
        labelEdit.centerY(inView: buttonEdit)
        
        contentView.addSubview(buttonDisable)
        buttonDisable.anchor(right: buttonEdit.leftAnchor, paddingRight: 10,paddingBottom: 16,width: 79,height: 29)
        buttonDisable.centerY(inView: buttonEdit)
    }
}
