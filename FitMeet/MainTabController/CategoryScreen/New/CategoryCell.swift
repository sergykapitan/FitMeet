//
//  CategoryCell.swift
//  FitMeet
//
//  Created by novotorica on 08.06.2021.
//

import Foundation
import UIKit
import Kingfisher


final class CategoryCell: UICollectionViewCell {

    //MARK: - Properties
    static let reuseID = "CategoryCell"
        
    //MARK: - UI
    private let photoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    private let bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#0099AE")
        return view
    }()
    private let buttonLike : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
        return button
    }()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImage.image = nil
    }
    
    private func initUI() {
        clipsToBounds = true
        backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        contentView.addSubview(photoImage)
        contentView.addSubview(bottomView)
        bottomView.addSubview(artistNameLabel)
        bottomView.addSubview(albumNameLabel)
        bottomView.addSubview(buttonLike)
        contentView.addSubview(spinner)
        
    }
    
    private func initLayout() {
        photoImage.anchor(top: contentView.topAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          paddingTop: 0,
                          paddingLeft: 0,
                          paddingRight: 0,height: 143)
        bottomView.anchor(top: photoImage.bottomAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        artistNameLabel.anchor(top: bottomView.topAnchor,
                               left: bottomView.leftAnchor,
                               right: bottomView.rightAnchor,
                               paddingTop: 8,paddingLeft: 5,paddingRight: 5 )
        buttonLike.anchor(top: bottomView.topAnchor,
                          right: bottomView.rightAnchor,
                          paddingTop: 8, paddingRight: 12)
        albumNameLabel.anchor(top: artistNameLabel.bottomAnchor,
                              left: bottomView.leftAnchor,
                              right: bottomView.rightAnchor,
                              paddingTop: 5,paddingLeft: 5,paddingRight: 5)
        
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    //MARK: - Methods
    func showSpinner() {
        spinner.startAnimating()
    }

    private func hideSpinner() {
        spinner.stopAnimating()
    }
    
    func hideSpinner(withDelay delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
            self.hideSpinner()
        }
    }
    
    func configureCell(albumName: Int, url: URL,artistName: String) {
        photoImage.kf.setImage(with: url)
        artistNameLabel.text = artistName
        albumNameLabel.text = "\(albumName)" + " Viewers"
    }
  
}

