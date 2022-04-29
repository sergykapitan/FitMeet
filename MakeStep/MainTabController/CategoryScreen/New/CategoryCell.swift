//
//  CategoryCell.swift
//  FitMeet
//
//  Created by novotorica on 08.06.2021.
//

import Foundation
import UIKit
import Kingfisher
import HHCustomCorner


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
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    private let bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = .blueColor
        return view
    }()
   let buttonLike : UIButton = {
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
    var viewOverlay: HHCustomCornerView = {
        var view = HHCustomCornerView()
        view.radiusLowerLeftCorner = 0
        view.radiusLowerRightCorner = 20
        view.radiusUpperLeftCorner = 0
        view.radiusUpperRightCorner = 20
        view.fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        view.backgroundColor = .clear
        return view
    }()
    var textOverlay: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 9)
        return label
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
        photoImage.addSubview(viewOverlay)
        viewOverlay.addSubview(textOverlay)
        bottomView.addSubview(nameLabel)
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
        
        viewOverlay.anchor(top: photoImage.topAnchor,
                           left: photoImage.leftAnchor,
                           paddingTop: 12, paddingLeft: 0,
                           width: 54, height: 23)
        textOverlay.anchor( left: viewOverlay.leftAnchor,
                            right: viewOverlay.rightAnchor,
                             height: 12)
        textOverlay.centerY(inView: viewOverlay)
        
        bottomView.anchor(top: photoImage.bottomAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          bottom: contentView.bottomAnchor,
                          paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
        
        nameLabel.anchor(top: bottomView.topAnchor,
                               left: bottomView.leftAnchor,
                               right: buttonLike.leftAnchor,
                               paddingTop: 8,paddingLeft: 12,paddingRight: 5 )
        buttonLike.anchor(top: bottomView.topAnchor,
                          right: bottomView.rightAnchor,
                          paddingTop: 8, paddingRight: 12,width: 30,height: 30)

    }

    func configureCell(albumName: Int, url: URL,artistName: String) {
        photoImage.kf.setImage(with: url)
        nameLabel.text = artistName
    }
}

