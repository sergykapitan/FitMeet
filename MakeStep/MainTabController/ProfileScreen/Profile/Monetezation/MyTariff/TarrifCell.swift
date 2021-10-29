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
        label.textColor = .black//UIColor(hexString: "367BF8")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    var descriptionLabel: UILabel =  {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#868686")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black// UIColor(hexString: "2E3A48")
        label.font = UIFont.boldSystemFont(ofSize: 16)
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
    initUI()
    
}
override func prepareForReuse() {
       super.prepareForReuse()
      self.nameMonetezationLabel.text = nil
      self.descriptionLabel.text = nil
      self.priceLabel.text = nil
   }
    private func initUI() {
        addSubview(cardView)
        cardView.fillSuperview()
       
        cardView.addSubview(nameMonetezationLabel)
        nameMonetezationLabel.anchor(top:cardView.topAnchor,left: cardView.leftAnchor,
                                 paddingTop: 16,paddingLeft: 16, height: 20)
       
        
        cardView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top:nameMonetezationLabel.bottomAnchor,left: cardView.leftAnchor,
                       paddingTop: 10, paddingLeft: 16, height: 20)
        
        cardView.addSubview(priceLabel)
        priceLabel.anchor( left: cardView.leftAnchor,
                            bottom: cardView.bottomAnchor,
                            paddingLeft: 16, paddingBottom: 59,height: 20)
    }
}
