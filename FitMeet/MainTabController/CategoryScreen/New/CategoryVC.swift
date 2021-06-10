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
    }
    
    var isSearchBarEmpty: Bool {
        navigationItem.searchController = searchController
        return searchController.searchBar.text?.isEmpty ?? true
    }
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    var listBroadcast: [Datum] = []
    let searchView = CategoryCode()
    var categories: [Int: String] = [:]
   // let viewModel = ViewModel()
    
    
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - LifiCicle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
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
       
       
        makeNavItem()
        searchView.segmentControll.setButtonTitles(buttonTitles: ["All","Popular","New","Likes","Viewers"])
        searchView.segmentControll.delegate = self

    }
    func makeNavItem() {
        let titleLabel = UILabel()
                   titleLabel.text = "Category"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

                   let stackView = UIStackView(arrangedSubviews: [titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .vertical

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
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

    // MARK: - Metods
//    private func setupSearchBar() {
//        navigationItem.searchController = searchController
//        searchController.searchBar.placeholder = "Enter Albom name here"
//        searchController.searchBar.delegate = self
//    }
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
       // searchView.hideSpinner(withDelay: 0.2)
        refreshControl.endRefreshing()
    }
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
//    private func reloadView() {
//            searchView.collectionView.reloadData()
//        }

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
                    self.searchView.collectionView.reloadData()
                }
        })
    }
}

   //MARK: - UISearchBarDelegate
//extension CategoryVC {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//    guard let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
//        navigationItem.searchController?.isActive = false
//
//    }
//}
