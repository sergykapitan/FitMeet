//
//  HomeVC.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import Foundation
import Combine
import UIKit
import Loaf



class HomeVC: SheetableViewController, UITabBarControllerDelegate{
    
    let status: BroadcastStatus = .online
    var ids = [Int]()
    var complishionHandler: ((Bool) -> Void)?
    var watch = 0
    var itemCount: Int = 0
    var isLoadingList : Bool = false
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    var currentPage : Int = 0
    var pageCount: Int = 0
    private let panGestureRecognizer = UITapGestureRecognizer()
    
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    let homeView = HomeVCCode()

    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    private var takeCategory: AnyCancellable?
    private var takePlan: AnyCancellable?
    private var takeOff: AnyCancellable?
    
    @Inject var fitMeetChannel: FitMeetChannels
    private var takeChannel: AnyCancellable?
    
    
    
    @Inject var fitMeetApi: FitMeetApi
    private var channelMap: AnyCancellable?
    private var takeUser: AnyCancellable?
    private var followBroad: AnyCancellable?
    private var watcherMap: AnyCancellable?
    
    
    
    var listBroadcast: [BroadcastResponce] = []
    var listCategory: [Datum] = []
    private let refreshControl = UIRefreshControl()
   
    var user: User?
    var ar =  [User]()
    var listUsers : [User]?
    var arrayIdUser = [Int]()
    var index = 0
    var url:String?
    var usersd = [Int: User]()
    var channellsd = [Int: ChannelResponce]()
  
    //MARK - LifeCicle
    override func loadView() {
        view = homeView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        if Connectivity.isConnectedToInternet {
            return } else {
                let vc = NotInternetView()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationCapturesStatusBarAppearance = true
                vc .delegate = self
                self.present(vc, animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        self.navigationController?.navigationBar.isTranslucent = false
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
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
       
        getUsers()
        bindingCategory()
        makeTableView()
        
        homeView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        makeNavItem(title: "", hide: true)
    }
    override func makeNavItem(title: String, hide: Bool) {
        super.makeNavItem(title: title, hide: hide)
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
    }

    override func copyLink(id: Int) {
        super.copyLink(id: id)
        self.homeView.tableView.isUserInteractionEnabled = false
    }
    override func stopLoaf() {
        self.homeView.tableView.isUserInteractionEnabled = true
    }
    //MARK: - Selectors
    @objc  func refreshAlbumList() {
        self.listBroadcast.removeAll()
        getUsers()
     }
    func bindingUserMap(ids: [Int])  {
               if ids.isEmpty { return } else {
               takeUser = fitMeetApi.getUserIdMap(ids: ids)
                   .mapError({ (error) -> Error in return error })
                   .sink(receiveCompletion: { _ in }, receiveValue: { response in
                       if response.data.count != 0 {
                           self.usersd = response.data
                         //  let arrayUserId = self.usersd.compactMap{$0.value.channelIds?.last}
                         //  self.getMapChannel(ids: arrayUserId)
                           self.refreshControl.endRefreshing()
                           self.homeView.tableView.reloadData()
                       }
                  })
              }
          }
    func getMapChannel(ids: [Int])   {
        channelMap = fitMeetApi.getChannelMap(ids: ids)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { response in
                
                
                          self.channellsd = response.data
                          self.refreshControl.endRefreshing()
                          self.homeView.tableView.reloadData()
//                          guard let listUsers = self.listUsers else { return }
//                          let compUser = listUsers.compactMap { $0 }
//                          if !self.channellsd.isEmpty {
//                              self.listUsers = compUser.sorted(by: {self.channellsd[($0.channelIds?.last!)!]!.followersCount > self.channellsd[($1.channelIds?.last!)!]!.followersCount })
//                          self.searchView.tableView.reloadData()
//                          }
                     })
         }
    func bindingCategory() {
        takeCategory = fitMeetStream.getCategory()
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if response.data != nil  {
                        self.listCategory = response.data!
      
                    }
            })
        }
    func getUsers() {
        takeUser = fitMeetStream.getListAllUser()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if !response.data.isEmpty {
                    let result = response.data.filter({ $0.resizedAvatar != nil })
                    sleep(2)
                    self.listUsers = result
                    self.currentPage = 1
                    self.bindingNotAuht(page: self.currentPage)
  
                } else {
                    self.getUsers()
                }
          })
    }
    func getMapWather(ids: [Int])   {
          watcherMap = fitMeetApi.getWatcherMap(ids: ids)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { response in
                  if !response.data.isEmpty  {
                      self.watch = response.data["\(ids.first!)"]!
            }
        })
      }
    func loadMoreItemsForList(){
            currentPage += 1
            self.bindingNotAuht(page: self.currentPage)
       }
    func bindingNotAuht(page: Int) {
        self.isLoadingList = false
        takeOff = fitMeetStream.getBroadcastN(page: page)
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if response.data != nil  {


                        guard let responceUnrap = response.data else { return }
                        self.listBroadcast.append(contentsOf:responceUnrap)
                       
                        let arrayUserId =  self.listBroadcast.map{$0.userId!}
                        self.bindingUserMap(ids: arrayUserId)
                    }
                    if response.meta != nil {
                        guard let itemCount = response.meta?.itemCount else { return }
                        self.itemCount = itemCount
                }
            })
        }
    private func makeTableView() {
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self
        homeView.tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseID)
        homeView.tableView.register(HomeHorizontalListTableViewCell.self, forCellReuseIdentifier: "HomeHorizontalListTableViewCell")
        homeView.tableView.separatorStyle = .none
     
    }
    func connectUser (broadcastId:String?,channellId: String?) {
        
        guard let broadID = broadcastId,let id = channellId else { return }
     
        SocketWatcher.sharedInstance.getTokenChat()
        SocketWatcher.sharedInstance.establishConnection(broadcastId: "\(broadID)", chanelId: "\(id)")
    }
}

