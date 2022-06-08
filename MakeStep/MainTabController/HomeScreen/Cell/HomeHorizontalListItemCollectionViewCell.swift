//
//  HomeHorizontalListItemCollectionViewCell.swift
//  MakeStep
//
//  Created by Sergey on 28.02.2022.
//


import UIKit
import Kingfisher
import Combine

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
    @Inject var fitMeetChannel: FitMeetChannels
    private var takeChannel: AnyCancellable?
    
    
    private var item: User? = nil {
        didSet{
            setupData(item: item)
        }
    }
    
    func setup(_ index: Int, item: User) {
        self.index = index
        self.item = item
    }
    func getChannelForId(id:Int) {
        takeChannel = fitMeetChannel.getChannelsId(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let name = response.name {
                    self.nameLabel.text = name
                }
          })
    }
    
    private func setupData(item: User?) {
        guard let item = item else { return}
     
        if let item = item as? User {
            if let id = item.channelIds?.last {
                self.getChannelForId(id: id)
            }
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

