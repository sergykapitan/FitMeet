//
//  CategoryCode.swift
//  FitMeet
//
//  Created by novotorica on 08.06.2021.
//

import Foundation
import UIKit


final class CategoryCode: UIView {

   // MARK: - UI
//    private let spinner: UIActivityIndicatorView = {
//        let spinner = UIActivityIndicatorView(style: .large)
//        spinner.color = UIColor.black
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        spinner.hidesWhenStopped = true
//        return spinner
//    }()
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
            return view
        }()
    
    var segmentControll: SegmentCustomFull = {
            let segment = SegmentCustomFull()
            return segment
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
    
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        
      //  initUI()
        initLayout()
      //  setupGrid()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        backgroundColor = .white
        
      //  addSubview(spinner)
        
        
        
    }
    
    private func initLayout() {
        //collectionView.fillSuperview()
        addSubview(cardView)
      //  cardView.fillFull(for: self)
        cardView.fillSuperview()
        cardView.addSubview(segmentControll)
        
        segmentControll.anchor(top: cardView.topAnchor,
                               left: cardView.leftAnchor,
                               paddingTop: 5, paddingLeft: 5, height: 30)
        
        cardView.addSubview(collectionView)

        collectionView.anchor(top: segmentControll.bottomAnchor,
                              left: cardView.leftAnchor,
                              right: cardView.rightAnchor,
                              bottom: cardView.bottomAnchor,
                              paddingTop: 15, paddingLeft: 15, paddingRight: 15, paddingBottom: 0)
        
        
//        NSLayoutConstraint.activate([
//            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
//            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
    }
    
    //MARK: - Methods
    func showSpinner() {
      //  spinner.startAnimating()
    }

    private func hideSpinner() {
       // spinner.stopAnimating()
    }
    
//    func hideSpinner(withDelay delay: TimeInterval) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
//            self.hideSpinner()
//        }
//    }
//    private func setupGrid() {
//        NotificationCenter.default.addObserver(forName: Notification.Name.AlbumNotification, object: nil, queue: .main) { note in
//            guard let userInfo = note.userInfo as? [String:ViewModel] else { return }
//            self.viewModel = userInfo["ViewModel"]!
//        }
//    }
}
