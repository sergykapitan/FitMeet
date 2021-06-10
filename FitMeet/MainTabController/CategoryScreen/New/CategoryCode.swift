//
//  CategoryCode.swift
//  FitMeet
//
//  Created by novotorica on 08.06.2021.
//

import Foundation
import UIKit

final class CategoryCode: UIView {
    
//    var viewModel = ViewModel() {
//        didSet {
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//    }

    //MARK: - UI
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
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
        
        initUI()
        initLayout()
      //  setupGrid()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        backgroundColor = .white
        addSubview(collectionView)
        addSubview(spinner)
    }
    
    private func initLayout() {
        collectionView.fillSuperview()
        
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
//    private func setupGrid() {
//        NotificationCenter.default.addObserver(forName: Notification.Name.AlbumNotification, object: nil, queue: .main) { note in
//            guard let userInfo = note.userInfo as? [String:ViewModel] else { return }
//            self.viewModel = userInfo["ViewModel"]!
//        }
//    }
}
