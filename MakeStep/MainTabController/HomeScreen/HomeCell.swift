//
//  HomeCell.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import UIKit
import Kingfisher

class HomeCell: UITableViewCell {
    
    static let reuseID = "HomeCell"
    
    // the youtuber (Model), you can use your custom model class here
      var youtuber : String?
        
      // the delegate, remember to set to weak to prevent cycles
      weak var delegate : YoutuberTableViewCellDelegate?
    
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
            return view
        }()
   

    var backgroundImage: UIImageView = {
        let image = UIImageView()
       // image.contentMode = .scaleAspectFit
       // image.contentMode = .scaleAspectFill
       // image.contentMode = .scaleToFill
        
        return image
        
    }()
    let logoUserImage: UIImageView = {
        let image = UIImageView()
       // image.layer.borderWidth = 1
       // image.layer.masksToBounds = false
       // image.layer.borderColor = UIColor.red.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.image = UIImage(named: "avatar")
        image.clipsToBounds = true
        return image
        
    }()
    
    private let bottomView : UIView = {
        let view = UIView()
        
      //  view.isUserInteractionEnabled = false
      //  view.backgroundColor = UIColor(hexString: "#3B58A4")
        return view
    }()
    let buttonLike: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Like-1"), for: .normal)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)
        print("Selected")

       // Configure the view for the selected state
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
        // Add action to perform when the button is tapped
        self.buttonLike.addTarget(self, action: #selector(subscribeButtonTapped(_:)), for: .touchUpInside)
              
    }
    @objc func subscribeButtonTapped(_ sender: UIButton){
        // ask the delegate (in most case, its the view controller) to
        // call the function 'subscribeButtonTappedFor' on itself.
        print("Selected12e47236476238456")
        if let youtuber = youtuber,
           let delegate = delegate {
            self.delegate?.youtuberTableViewCell(self, subscribeButtonTappedFor: youtuber)
        }
      }
   
    func initialize() {
        addSubview(cardView)
       // cardView.fillSuperview()
        cardView.fillFull(for: self)
        cardView.addSubview(backgroundImage)
        backgroundImage.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor,paddingTop: 0, paddingLeft: 0, paddingRight: 0,height: 200)
        //
        //,height:150

        cardView.addSubview(bottomView)
        bottomView.anchor(top: backgroundImage.bottomAnchor,
                          left: cardView.leftAnchor,
                          right: cardView.rightAnchor,
                          bottom: cardView.bottomAnchor,
                          paddingTop: 0, paddingLeft: 0,paddingRight: 0,paddingBottom: 0)
        
        
        bottomView.addSubview(logoUserImage)
        logoUserImage.anchor(top: bottomView.topAnchor, left: bottomView.leftAnchor,paddingTop: 8, paddingLeft: 16,width: 24,height: 24)
        
        bottomView.addSubview(titleLabel)
        titleLabel.anchor(top: bottomView.topAnchor, left: logoUserImage.rightAnchor, paddingTop: 8, paddingLeft: 8)
        
        bottomView.addSubview(buttonMore)
        buttonMore.anchor(top: bottomView.topAnchor, right: bottomView.rightAnchor ,paddingTop: 8,paddingRight: 26)
        
        bottomView.addSubview(buttonLike)
        buttonLike.anchor(top:  bottomView.topAnchor, right: buttonMore.leftAnchor, paddingTop: 8, paddingRight: 20)
        
        bottomView.addSubview(labelDescription)
        labelDescription.anchor(top: titleLabel.bottomAnchor, left: logoUserImage.rightAnchor,right: cardView.rightAnchor , paddingTop: 8, paddingLeft: 8,paddingRight: 16)
        
        bottomView.addSubview(labelCategory)
        labelCategory.anchor(top: labelDescription.bottomAnchor, left: logoUserImage.rightAnchor,paddingTop: 8, paddingLeft: 8)
   
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
