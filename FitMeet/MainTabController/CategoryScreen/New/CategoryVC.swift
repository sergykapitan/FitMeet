//
//  CategoryVC.swift
//  FitMeet
//
//  Created by novotorica on 08.06.2021.
//

import Foundation
import UIKit
import Foundation
import CoreData
import Combine



class CategoryVC: UIViewController, UISearchBarDelegate,CustomSegmentedFullControlDelegate{
    
    
    func change(to index: Int) {
        print("Index ==\(index)")
        if index == 0 {
            filtredBroadcast = listBroadcast
            self.searchView.collectionView.reloadData()
        }
        if index == 1 {
            filtredBroadcast = listBroadcast.filter { $0.isPopular }
            self.searchView.collectionView.reloadData()
        }
        if index == 2 {
            filtredBroadcast = listBroadcast.filter { $0.isNew }
            self.searchView.collectionView.reloadData()
        }
        if index == 3 {
            filtredBroadcast = listBroadcast.filter { ($0.isFollow ?? false) }
            self.searchView.collectionView.reloadData()
        }
        if index == 4 {
            filtredBroadcast = listBroadcast.filter{ $0.followersCount > 1}
        }
    }
    
    var isSearchBarEmpty: Bool {
        navigationItem.searchController = searchController
        return searchController.searchBar.text?.isEmpty ?? true
    }
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    var listBroadcast: [Datum] = []
    var filtredBroadcast: [Datum] = []
    let searchView = CategoryCode()
    var categories: [Int: String] = [:]
   // let viewModel = ViewModel()
    
    
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - LifiCicle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        makeNavItem()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }

    override func loadView() {
        super.loadView()
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        binding()
        searchView.segmentControll.setButtonTitles(buttonTitles: ["All","Popular","New","Likes","Viewers"])
        searchView.segmentControll.delegate = self
        title = "Category"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always


    }
    func makeNavItem() {
//        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
//        UINavigationBar.appearance().titleTextAttributes = attributes
//        let titleLabel = UILabel()
//                   titleLabel.text = "Category"
//                   titleLabel.textAlignment = .center
//                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
//                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
//
//                   let stackView = UIStackView(arrangedSubviews: [titleLabel])
//                   stackView.distribution = .equalSpacing
//                   stackView.alignment = .leading
//                   stackView.axis = .vertical
//
//                   let customTitles = UIBarButtonItem.init(customView: stackView)
//                   self.navigationItem.leftBarButtonItems = [customTitles]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "Note"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction)),
                                                   UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction))]
    }
    @objc
    func rightHandAction() {
        print("right bar button action")
    }

    private func setupMainView() {
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
        searchView.collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
    }
    func makeReguest(searchText: String) {
        searchView.showSpinner()
    }
    func stopSpiners() {
        refreshControl.endRefreshing()
    }
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    //MARK: - Selectors
    @objc private func refreshAlbumList() {
        print("refrech")
       // makeReguest(searchText:viewModel.lastRequestName)
       }
    
    func binding() {
        takeBroadcast = fitMeetStream.getBroadcastCategory()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.filtredBroadcast = response.data!
                    self.searchView.collectionView.reloadData()
                }
        })
    }
}
