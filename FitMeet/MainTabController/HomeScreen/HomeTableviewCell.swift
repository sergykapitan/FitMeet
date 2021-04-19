//
//  HomeTableviewCell.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import UIKit

class HomeTableviewCell: UITableViewCell {
    
    static let reuseID = "HomeTabalviewCell"
   
    let titleLabel = UILabel()
    let previewImageView = UIImageView()
    let subtitleLabel = UILabel()

    var video: Video? = nil {
      didSet {
        updateViews()
      }
    }
    
    // Sizing
    override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(false, animated: false)
    }
    
    // MARK - Table Cell Height
    
    class func height(for viewModel: Video) -> CGFloat {
      let previewHeight: CGFloat = 200
      let padding: CGFloat = 16

      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 24.0)
      label.text = viewModel.title
      let titleHeight = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 32, height: .infinity)).height
      
      label.text = viewModel.subtitle
      label.font = UIFont.systemFont(ofSize: 14.0)
      let subtitleHeight = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 32, height: .infinity)).height
      
      return padding + titleHeight + padding + previewHeight + padding + subtitleHeight + padding
    }
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
       // self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      backgroundColor = .blue
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubviews()
       // self.initialize()
    }

//    func initialize() {
//        
//        let titleLabel = UILabel(frame: .zero)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(titleLabel)
//        self.titleLabel = titleLabel
//        
//        NSLayoutConstraint.activate([
//            
//            self.contentView.centerXAnchor.constraint(equalTo: self.titleLabel.centerXAnchor),
//            self.contentView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
//        ])
//        
//    }
    override func prepareForReuse() {
           super.prepareForReuse()
        
        self.textLabel?.text = nil
        self.detailTextLabel?.text = nil
        self.imageView?.image = nil
       }

}
