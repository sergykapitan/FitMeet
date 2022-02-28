//
//  HomeHorizontalListTableViewCell.swift
//  MakeStep
//
//  Created by Sergey on 28.02.2022.
//

import UIKit

enum HomeHorizontalListType {
    case authors([User])
}

protocol HomeHorizontalListTableViewCellDelegate: AnyObject {
    func horizontalListItemTapped(index: Int, type: HomeHorizontalListType)
}

class HomeHorizontalListTableViewCell: UITableViewCell {
    
    private lazy var titleLabel:  UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "AvenirNext-Medium", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        cv.alwaysBounceHorizontal = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.register(HomeHorizontalListItemCollectionViewCell.self, forCellWithReuseIdentifier: "HomeHorizontalListItemCollectionViewCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private var type: HomeHorizontalListType? = nil {
        didSet{
            guard let type = type else { return }
            switch type {
            case .authors(_):
                titleLabel.text = "Famous Authors"
         
            }
            collectionView.reloadData()
        }
    }
    
    weak var delegate: HomeHorizontalListTableViewCellDelegate? = nil
    
    func setup(type: HomeHorizontalListType) {
        self.type = type
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        backgroundColor = .white
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        selectionStyle = .none
        
        addSubview(titleLabel)
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 84),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeHorizontalListTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = type else {return 0}
        switch type {
        case .authors(let authors): return authors.count
       
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHorizontalListItemCollectionViewCell", for: indexPath) as! HomeHorizontalListItemCollectionViewCell
        if let type = type {
            switch type {
            case .authors(let user): cell.setup(indexPath.row, item: user[indexPath.row])
            }
        }
        
        cell.delegate = self
        return cell
    }
    
}

extension HomeHorizontalListTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80 , height: 84)
    }
    
}

extension HomeHorizontalListTableViewCell: HomeHorizontalListItemCollectionViewCellDelegate {
    
    func itemTapped(index: Int) {
        guard let type = type else {return}
        delegate?.horizontalListItemTapped(index: index, type: type)
    }
    
    
}
