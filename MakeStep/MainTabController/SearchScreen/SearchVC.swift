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


class SearchVC: UIViewController, UISearchBarDelegate,SegmentControlSearchDelegate  {
    
  
    
    let videoVC = SearchVideoVC()
    let coachVC = SearchUserVC()
    let categoriesVC = CalculateVC()
    
    

    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    private var takeUser: AnyCancellable?
    private var takeCategory: AnyCancellable?
    
    @Inject var makeStepChannel: FitMeetChannels
    private var takeChannel: AnyCancellable?
    
   
    
    
    @Inject var makeApi: FitMeetApi
    private var channelMap: AnyCancellable?
    var ids = [Int]()
    var channellsd = [Int: ChannelResponce]()
    
    
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    
    var listBroadcast: [BroadcastResponce] = []
    var filtredBroadcast: [BroadcastResponce] = []
    var listUsers:[User] = []
    var filterListUser:[User] = []
    var listCategory: [Datum] = []
    var filerlistCategory: [Datum] = []
    
    var user: User?
    
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    
    var broadcast:BroadcastResponce?
    
    var channelUser: ChannelResponce?
    
    var index: Int = 0
    var searchActive : Bool = false

    var isSearchBarEmpty: Bool {
           navigationItem.searchController = searchController
           return searchController.searchBar.text?.isEmpty ?? true
       }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    func change(to index: Int) {
        if index == 0 {
           actionVideo()
//            let searchBar = searchController.searchBar
//            videoVC.searchVideo(text: searchBar.text!)
//            self.index = index
        }
        if index == 1 {
           actionCoach()
//            let searchBar = searchController.searchBar
//            coachVC.searchUser(text: searchBar.text!)
//           self.index = index
        }
        if index == 2 {
           actionCategory()
        }
    }
    let searchView = SearchVCCode()
    var sizeSearchBar: CGFloat?
    
    
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - LifiCicle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        actionVideo()
        setupSearchBar()
        searchView.segmentControll.setIndex(index: 0)
        self.index = 0

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        sizeSearchBar = self.navigationItem.searchController?.searchBar.frame.height
        searchView.segmentControll.anchor(top: self.navigationItem.searchController?.searchBar.bottomAnchor, left: searchView.cardView.leftAnchor, paddingTop: 10, paddingLeft: 20, height: 30)

    }
    override func loadView() {
        super.loadView()
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        makeTableView()
        makeNavItem()
        searchView.segmentControll.setButtonTitles(buttonTitles: ["Video","Coaches","Categories"])
        searchView.segmentControll.delegate = self
        searchView.labelNtResult.isHidden = true
        
    }
    
    // MARK: - Metods
  
  
    func getUser(id: Int ) {
        takeUser = makeApi.getUserId(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil  {                
                    self.user = response
                    let vc = ChannelCoach()
                    vc.modalPresentationStyle = .fullScreen
                    vc.user = self.user
                    self.user = nil
                    self.navigationController?.pushViewController(vc, animated: true)
                }
          })
    }
    func getMapChnnel(ids: [Int])   {
        channelMap = makeApi.getChannelMap(ids: ids)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { response in
                  if !response.data.isEmpty  {
                      if response.data.count != 0 {
                          self.channellsd = response.data
                          self.listUsers = self.listUsers.sorted(by: {(self.channellsd[$0.id!]?.followersCount)! > (self.channellsd[$1.id!]?.followersCount)! })
                          self.searchView.tableView.reloadData()
                      }
            }
        })
      }

 
    func getUsers(name: String) {
        takeUser = fitMeetStream.getListUser(name: name)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listUsers = response.data.sorted(by: {$0.channelFollowCount! > $1.channelFollowCount!})
                    self.filterListUser = self.listUsers
                    if self.listUsers.isEmpty {
                        self.searchView.tableView.isHidden = true
                        self.searchView.labelNtResult.isHidden = false
                    } else {
                        self.searchView.tableView.isHidden = false
                        self.searchView.labelNtResult.isHidden = true
                        let arrayUserId = self.listUsers.map{$0.id!}
                        self.getMapChnnel(ids: arrayUserId)
                    }
                }
          })
    }
    func getreversUsers(name: String) {
        takeUser = fitMeetStream.getListReversUser(name: name)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listUsers = response.data.reversed()
                    if self.listUsers.isEmpty {
                        self.searchView.tableView.isHidden = true
                        self.searchView.labelNtResult.isHidden = false
                    } else {
                        self.searchView.tableView.isHidden = false
                        self.searchView.labelNtResult.isHidden = true
                    }
                    self.searchView.tableView.reloadData()
                   
                }
          })
    }
    func getChanell(id: Int) {
        takeChannel = makeStepChannel.getChannelsId(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil  {
                    self.channelUser = response
                   
                }
             })
    }
    func getCategory(name: String) {
        takeCategory = fitMeetStream.getBroadcastCategory(name: name)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listCategory = response.data!
                    if self.listCategory.isEmpty {
                        self.searchView.tableView.isHidden = true
                        self.searchView.labelNtResult.isHidden = false
                    } else {
                        self.searchView.tableView.isHidden = false
                        self.searchView.labelNtResult.isHidden = true
                    }
                    self.searchView.tableView.reloadData()

                }
             })
    }
    func getBroadcast(userId: String) {
        takeBroadcast = fitMeetStream.getBroadcastPrivateID(userId: userId)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    let arrayBroadcast = response.data?.filter{ $0.status == "ONLINE"}
                    self.broadcast = response.data?.first
                }
         })
    }
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Coaches, Streams or Categories"
        searchController.searchBar.delegate = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.isActive = false
        self.searchController.searchBar.isTranslucent = false
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
  
//MARK: - Selectors
    @objc private func refreshAlbumList() {
      
       }
    private func makeTableView() {
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        searchView.tableView.register(SearchVCCell.self, forCellReuseIdentifier: SearchVCCell.reuseID)
        searchView.tableView.register(SearchVCUserCell.self, forCellReuseIdentifier: SearchVCUserCell.reuseID)
        searchView.tableView.register(SearchVCCategory.self, forCellReuseIdentifier: SearchVCCategory.reuseID)
        searchView.tableView.separatorStyle = .none
    }
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Search"
                   titleLabel.textAlignment = .center
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

                   let stackView = UIStackView(arrangedSubviews: [titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .vertical

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "notifications1"), style: .plain, target: self, action:  #selector(notificationHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(timeHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
       // self.navigationItem.rightBarButtonItems = [startItem,timeTable]
    }
    @objc func timeHandAction() {
        print("timeHandAction")
        let tvc = Timetable()
        navigationController?.present(tvc, animated: true, completion: nil)
        
        
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
    @objc func actionVideo() {
        removeAllChildViewController(coachVC)
        removeAllChildViewController(categoriesVC)
        configureChildViewController(videoVC, onView: searchView.selfView )

    }
    @objc func actionCoach() {
        removeAllChildViewController(videoVC)
        removeAllChildViewController(categoriesVC)
        configureChildViewController(coachVC, onView: searchView.selfView )
    }
    @objc func actionCategory() {
        removeAllChildViewController(videoVC)
        removeAllChildViewController(coachVC)
        configureChildViewController(categoriesVC, onView: searchView.selfView )
    }
}

//MARK: - UISearchBarDelegate
extension SearchVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        if index == 0 {
            let searchBar = searchController.searchBar
            videoVC.searchVideo(text: searchBar.text!)
        }
        if index == 1 {           
            let searchBar = searchController.searchBar
            coachVC.searchUser(text: searchBar.text!)
        }
        if index == 2 {
            let searchBar = searchController.searchBar
          //  getCategory(name: searchBar.text!)
           
        }
        func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//token != nil ?  videoVC.bindingRec() :  videoVC.bindingNotAuth(name: "a")
            
  //          coachVC.getUsers(name: "a")
        }

    }
    func connectUser (broadcastId:String?,channellId: String?) {
        
        guard let broadID = broadcastId,let id = channellId else { return }
        SocketWatcher.sharedInstance.getTokenChat()
        SocketWatcher.sharedInstance.establishConnection(broadcastId: "\(broadID)", chanelId: "\(id)")
    }
}

