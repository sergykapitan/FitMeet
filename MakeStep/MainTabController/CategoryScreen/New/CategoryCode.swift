//
//  CategoryCode.swift
//  FitMeet
//
//  Created by novotorica on 08.06.2021.
//

import Foundation
import UIKit


final class CategoryCode: UIView {

    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    let scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.contentSize.height = 26
        scroll.contentSize.width = 400
        return scroll
        }()
        
    var stackHFirst: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
        }()

    var buttonAll: UIButton = {
        var button = UIButton()
        button.backgroundColor = .blueColor
        button.setTitle("All", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        button.anchor(width: 64,height: 26)
        
        return button
    }()
    var buttonPopular: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("Popular", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        button.anchor(width: 64,height: 26)
        return button
    }()
    var buttonNew: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("New", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        button.anchor(width: 64,height: 26)
        return button
    }()
    var buttonLikes: UIButton = {
        var button = UIButton()
        button.backgroundColor = .blueColor
        button.setTitle("Likes", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        button.anchor(width: 64,height: 26)
        return button
    }()
    var buttonViewers: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#BBBCBC")
        button.setTitle("Viewers", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 13
        button.anchor(width: 64,height: 26)
        return button
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseID)
        return collectionView
    }()
    let table: UIView = {
       let table = UIView()
       return table
   }()
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        backgroundColor = .white
        
        
    }
    
    private func initLayout() {
        addSubview(cardView)
        cardView.fillSuperview()
        
        stackHFirst = UIStackView(arrangedSubviews: [buttonAll,buttonPopular,buttonNew,buttonLikes,buttonViewers])
        stackHFirst.axis = .horizontal
        stackHFirst.distribution = .equalSpacing
        stackHFirst.spacing = 8

          
        cardView.addSubview(buttonAll)
        buttonAll.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 15, paddingLeft: 16, width: 74, height: 26)

     //   cardView.addSubview(buttonPopular)
     //   buttonPopular.anchor(top: cardView.topAnchor, left: buttonAll.rightAnchor, paddingTop: 15, paddingLeft: 5, width: 74, height: 26)

     //   cardView.addSubview(buttonNew)
     //   buttonNew.anchor(top: cardView.topAnchor, left: buttonPopular.rightAnchor, paddingTop: 15, paddingLeft: 5, width: 74, height: 26)

        cardView.addSubview(buttonLikes)
        buttonLikes.anchor(top: cardView.topAnchor, left: buttonAll.rightAnchor, paddingTop: 15, paddingLeft: 5, width: 74, height: 26)

     //   cardView.addSubview(buttonViewers)
     //   buttonViewers.anchor(top: cardView.topAnchor, left: buttonLikes.rightAnchor, paddingTop: 15, paddingLeft: 5, width: 74, height: 26)

                
        cardView.addSubview(collectionView)

        collectionView.anchor(top: buttonAll.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              bottom: cardView.bottomAnchor,
                              paddingTop: 15, paddingLeft: 15, paddingRight: 15, paddingBottom: 0)

    }

    
}
