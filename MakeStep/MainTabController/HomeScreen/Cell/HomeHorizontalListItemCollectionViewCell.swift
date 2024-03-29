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
        iv.isSkeletonable = true
        return iv
    }()
    
    private lazy var placeholderImage:  UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isSkeletonable = true
        iv.showAnimatedGradientSkeleton()
        return iv
    }()
    
    private lazy var nameLabel:  UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: "AvenirNext-Medium", size: 9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: HomeHorizontalListItemCollectionViewCellDelegate?
    private var index: Int = 0
    private var name: String?
    
    
    private var item: User? = nil {
        didSet{
            setupData(item: item, name: name)
        }
    }
    
    func setup(_ index: Int, item: User,name: String) {
        
        self.name = name
        self.index = index
        self.item = item
       
    }
    
    private func setupData(item: User?,name: String?) {
        guard let item = item,let name = name  else { return}
     
        if let item = item as? User {
            self.nameLabel.text = name
            setupImage(urlString: item.resizedAvatar?["avatar_120"]?.png ?? "")
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
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            placeholderImage.heightAnchor.constraint(equalToConstant: 50),
            placeholderImage.widthAnchor.constraint(equalToConstant: 50),
            placeholderImage.topAnchor.constraint(equalTo: topAnchor),
            placeholderImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor,constant: -2),
            nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor,constant: 2),
        ])
        
        [imageView,placeholderImage].forEach{
            $0.showAnimatedGradientSkeleton()
        }
        
        setupTapGesture()
        
    }
    func hideAnimation() {
        [imageView,placeholderImage].forEach{
            $0.hideSkeleton()
        }
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

