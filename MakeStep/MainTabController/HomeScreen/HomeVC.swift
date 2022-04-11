//
//  HomeVC.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import Foundation
import Combine
import UIKit



class HomeVC: SheetableViewController, UITabBarControllerDelegate{
    

    var ids = [Int]()
    var complishionHandler: ((Bool) -> Void)?
    var watch = 0
    var itemCount: Int = 0
    var isLoadingList : Bool = false
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    var currentPage : Int = 0
    var pageCount: Int = 0
    
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

    
    //MARK - LifeCicle
    override func loadView() {
        view = homeView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        

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
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
        homeView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
       
    }
   
    //MARK: - Selectors
    @objc  func refreshAlbumList() {
        self.listBroadcast.removeAll()
        getUsers()
     }
    
    func binding() {
        takeBroadcast = fitMeetStream.getListBroadcast(status: "ONLINE")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.bindingOff(page: self.currentPage)
                  
                } else {
                    self.bindingOff(page: self.currentPage)
                }
        })
    }
    func bindingNotAuht() {
            takeBroadcast = fitMeetStream.getBroadcast(status: "ONLINE")
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if response.data != nil  {
                        self.listBroadcast = response.data!
                        self.bindingNotOff()
                    } else {
                        self.bindingNotOff()
                    }
            })
        }
    func bindingOff(page:Int) {
        takeOff = fitMeetStream.getOffBroadcast(page: page)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { response in
                  if response.data != nil  {
                      self.listBroadcast.append(contentsOf: response.data!)
                      let arrayUserId = self.listBroadcast.map{$0.userId!}
                      self.bindingUserMap(ids: arrayUserId)
                      self.isLoadingList = false
                      self.refreshControl.endRefreshing()
                      self.homeView.tableView.reloadData()

                  } 
                  if response.meta != nil {
                      guard let itemCount = response.meta?.itemCount , let pageCount = response.meta?.page else { return }
                      self.itemCount = itemCount
                      self.pageCount = pageCount
                  }
              })
      }
    func bindingNotOff() {
            takeOff = fitMeetStream.getNotOffBroadcast()
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if response.data != nil  {
                        self.listBroadcast.append(contentsOf: response.data!)
                        self.bindingNotPlanned()
                    } else {
                        self.bindingNotPlanned()
                    }
                })
        }
    func bindingPlanned() {
            takePlan = fitMeetStream.getListPlanBroadcast()
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if response.data != nil  {
                        self.listBroadcast.append(contentsOf: response.data!)
                        let arrayUserId = self.listBroadcast.map{$0.userId!}
                        self.bindingUserMap(ids: arrayUserId)
                        self.homeView.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                })
        }
    func bindingNotPlanned() {
           takePlan = fitMeetStream.getNotPlanBroadcast()
               .mapError({ (error) -> Error in return error })
               .sink(receiveCompletion: { _ in }, receiveValue: { response in
                   if response.data != nil  {
                       self.listBroadcast.append(contentsOf: response.data!)
                       let arrayUserId = self.listBroadcast.map{$0.userId!}
                       self.bindingUserMap(ids: arrayUserId)
                       self.homeView.tableView.reloadData()
                       self.refreshControl.endRefreshing()
                   }
               })
       }
    
    func bindingUserMap(ids: [Int])  {
           if ids.isEmpty { return } else {
           takeUser = fitMeetApi.getUserIdMap(ids: ids)
               .mapError({ (error) -> Error in return error })
               .sink(receiveCompletion: { _ in }, receiveValue: { response in
                   if response.data.count != 0 {
                       self.usersd = response.data
                       self.homeView.tableView.reloadData()
                   }
             })
          }
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
                    let result = response.data.filter({ $0.avatarPath != nil })
                    self.listUsers = result
                    self.currentPage = 1
                    if self.token != nil {
                        self.binding()
                    } else {
                        self.bindingNotAuht()
                    }
  
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
            bindingOff(page: currentPage)
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

