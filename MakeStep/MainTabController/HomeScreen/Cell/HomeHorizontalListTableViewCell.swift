//
//  HomeHorizontalListTableViewCell.swift
//  MakeStep
//
//  Created by Sergey on 28.02.2022.
//

import UIKit
import Combine

enum HomeHorizontalListType {
    case authors([User])
}

protocol HomeHorizontalListTableViewCellDelegate: AnyObject {
    func horizontalListItemTapped(index: Int, type: [User])
}

class HomeHorizontalListTableViewCell: UITableViewCell {
    
   
    @Inject var fitMeetApi: FitMeetApi
    private var channelMap: AnyCancellable?
    
    private lazy var collectionView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
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
    
    private var type: [User]? = nil {
        didSet{
            guard let type = type else { return }
            let ids =  type.compactMap{$0.channelIds?.last}
            self.getMapChannel(ids: ids)
        }
    }
    private var channellsd: [Int: ChannelResponce] = [Int: ChannelResponce]() {
        didSet{
            collectionView.reloadData()
        }
    }
    func getMapChannel(ids: [Int])   {
        channelMap = fitMeetApi.getChannelMap(ids: ids)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { response in
               self.channellsd = response.data
                         
            })
         }
    weak var delegate: HomeHorizontalListTableViewCellDelegate? = nil
    
    func setup(type: [User]) {
        self.type = type
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        backgroundColor = .white
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        selectionStyle = .none
  
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
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
        guard let type = type else {return 10}
        
         return type.count
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHorizontalListItemCollectionViewCell", for: indexPath) as! HomeHorizontalListItemCollectionViewCell
        if let type = type {
            cell.hideAnimation()
            if let channalId = type[indexPath.row].channelIds?.last {
                cell.setup(indexPath.row, item: type[indexPath.row], name: channellsd[channalId]?.name ?? "@@")
            }
        }
        
        cell.delegate = self
        return cell
    }
    
}

extension HomeHorizontalListTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60 , height: 84)
    }
    
}

extension HomeHorizontalListTableViewCell: HomeHorizontalListItemCollectionViewCellDelegate {
    
    func itemTapped(index: Int) {
        guard let type = type else {return}
        delegate?.horizontalListItemTapped(index: index, type: type)
    }
    
    
}
