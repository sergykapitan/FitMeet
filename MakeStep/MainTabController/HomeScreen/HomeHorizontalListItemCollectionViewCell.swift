//
//  HomeHorizontalListItemCollectionViewCell.swift
//  MakeStep
//
//  Created by Sergey on 28.02.2022.
//


import UIKit
import Kingfisher

protocol HomeHorizontalListItemCollectionViewCellDelegate: AnyObject {
    func itemTapped(index: Int)
}

class HomeHorizontalListItemCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView:  UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var placeholderImage:  UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var nameLabel:  UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont(name: "AvenirNext-Medium", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: HomeHorizontalListItemCollectionViewCellDelegate?
    private var index: Int = 0
    
    private var item: AnyObject? = nil {
        didSet{
            setupData(item: item)
        }
    }
    
    func setup(_ index: Int, item: AnyObject) {
        self.index = index
        self.item = item
    }
    
    private func setupData(item: AnyObject?) {
        guard let item = item else { return}
     
        if let item = item as? User {
            nameLabel.text = item.fullName
            setupImage(urlString: item.avatarPath ?? "")
        }
    }
    
    private func setupImage(urlString: String?) {
        guard let urlString = urlString else { return }
        self.imageView.image = nil
        self.placeholderImage.isHidden = false
        if let imageUrl = URL(string: urlString) {
            imageView.kf.setImage(with: imageUrl, options: [.retryStrategy(DelayRetryStrategy(maxRetryCount: 5, retryInterval: .seconds(1)))]) { result in
                switch result {
                case .success(_):  self.placeholderImage.isHidden = true
                case .failure(_): break
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(placeholderImage)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 48),
            imageView.widthAnchor.constraint(equalToConstant: 48),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            placeholderImage.heightAnchor.constraint(equalToConstant: 48),
            placeholderImage.widthAnchor.constraint(equalToConstant: 48),
            placeholderImage.topAnchor.constraint(equalTo: topAnchor),
            placeholderImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        //imageView.showAnimatedGradientSkeleton()
        setupTapGesture()
        
    }
    

    override func tapGestureSelector() {
        delegate?.itemTapped(index: index)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.height / 2
        placeholderImage.layer.cornerRadius = imageView.frame.height / 2
      
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

