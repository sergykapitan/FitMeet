//
//  SearchVC.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import UIKit
import Foundation
import CoreData
import Combine


class SearchVC: UIViewController, UISearchBarDelegate,CustomSegmentedControlDelegate {
    
    
    
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    private var takeUser: AnyCancellable?
    private var takeCategory: AnyCancellable?
    
    var listBroadcast: [BroadcastResponce] = []
    var filtredBroadcast: [BroadcastResponce] = []
    var listUsers:[Users] = []
    var filterListUser:[Users] = []
    var listCategory: [Datum] = []
    var filerlistCategory: [Datum] = []
    
    var index: Int = 0
    var searchActive : Bool = false

    var isSearchBarEmpty: Bool {
           navigationItem.searchController = searchController
           return searchController.searchBar.text?.isEmpty ?? true
       }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    func change(to index: Int) {
       
        if index == 0 {
            self.index = index
            self.searchView.tableView.reloadData()
        }
        if index == 1 {
            self.index = index
            self.searchView.tableView.reloadData()
        }
        if index == 2 {
            self.index = index
            self.searchView.tableView.reloadData()
        }
    }
   
   
    
    let searchView = SearchVCCode()
  //  let viewModel = ViewModel()
    
    
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - LifiCicle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.segmentControll.anchor(top: self.navigationItem.searchController?.searchBar.bottomAnchor, left: searchView.cardView.leftAnchor, paddingTop: 10, paddingLeft: 20, height: 30)
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layoutIfNeeded()
//        self.navigationController?.navigationBar.backgroundColor = .white
        
    }

    override func loadView() {
        super.loadView()
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        setupSearchBar()
        makeTableView()
        makeNavItem()
        binding(name: "a")
        getUsers(name: "a")
        getCategory()
        searchView.segmentControll.setButtonTitles(buttonTitles: ["Streams","Coaches","Categories"])
        searchView.segmentControll.delegate = self

    }
    
    // MARK: - Metods
    func binding(name: String) {
        takeBroadcast = fitMeetStream.getAllBroadcast(name: name)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.filtredBroadcast = self.listBroadcast
                    self.searchView.tableView.reloadData()
                 
                }
             })
    }
    func getUsers(name: String) {
        takeUser = fitMeetStream.getListUser(name: name)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listUsers = response.data
                    self.searchView.tableView.reloadData()
                   
                }
             })
    }
    func getCategory() {
        takeCategory = fitMeetStream.getBroadcastCategory()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listCategory = response.data!
                    self.searchView.tableView.reloadData()

                }
             })
    }
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Coaches, Streams or Categories"
        searchController.searchBar.delegate = self
    }
    private func setupMainView() {        
        searchView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
    }
    func makeReguest(searchText: String) {
      //  searchView.showSpinner()
     //   viewModel.get(search: searchText)

    }
    func stopSpiners() {
      //  searchView.hideSpinner(withDelay: 0.2)
        refreshControl.endRefreshing()
    }
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    private func reloadView() {
            searchView.tableView.reloadData()
        }
    func filterContentForSearchText(_ searchText: String,category: BroadcastResponce? = nil) {
        
        filtredBroadcast = listBroadcast.filter { (candy: BroadcastResponce) -> Bool in
            return (candy.name?.lowercased().contains(searchText.lowercased()) ?? true)
          }
          
        searchView.tableView.reloadData()
    }
    func filteringUser(_ searchText: String,category: Users? = nil) {
        
        filterListUser = listUsers.filter { (candy: Users) -> Bool in
            return (candy.fullName?.lowercased().contains(searchText.lowercased()) ?? true)
          }
          
        searchView.tableView.reloadData()
    }
    func filteringCategory(_ searchText: String,category: Datum? = nil) {
        filerlistCategory = listCategory.filter{ (list: Datum) -> Bool in
            return (list.title?.lowercased().contains(searchText.lowercased()) ?? true)
        }
        searchView.tableView.reloadData()
    }

    //MARK: - Selectors
    @objc private func refreshAlbumList() {
      //  binding()
       }
    private func makeTableView() {
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        searchView.tableView.register(SearchVCCell.self, forCellReuseIdentifier: SearchVCCell.reuseID)
        searchView.tableView.register(SearchVCUserCell.self, forCellReuseIdentifier: SearchVCUserCell.reuseID)
        searchView.tableView.register(SearchVCCategory.self, forCellReuseIdentifier: SearchVCCategory.reuseID)
    }
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Search"
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
    @objc func rightHandAction() {
        print("right bar button action")
    }
}

   //MARK: - UISearchBarDelegate

extension SearchVC: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        print(searchBar.text!)
//    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if index == 0 {
            let searchBar = searchController.searchBar
            binding(name: searchBar.text!)
            
        }
        if index == 1 {
            let searchBar = searchController.searchBar
            getUsers(name: searchBar.text!)
           // filteringUser(searchBar.text!)
           
        }
        if index == 2 {
            let searchBar = searchController.searchBar
            getCategory()
           // filteringCategory(searchBar.text!)
           
        }
//        let searchBar = searchController.searchBar
//        binding(name: searchBar.text!)
       // filterContentForSearchText(searchBar.text!)

    }
}

