//
//  HomeVC.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import Foundation
import Combine
import UIKit



class HomeVC: UIViewController, UITabBarControllerDelegate{
    

    var ids = [Int]()
    var complishionHandler: ((Bool) -> Void)?
    var watch = 0

    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    let homeView = HomeVCCode()

    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
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
   // var  playerContainerView: PlayerContainerView?
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
        getUsers()

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
        makeTableView()
        if token != nil {
            binding()
        } else {
            bindingNotAuht()
        }
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
        homeView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
  
    }
   
    //MARK: - Selectors
    @objc private func refreshAlbumList() {
        if token != nil {
                binding()
         } else {
                bindingNotAuht()
            }
        }
    
    func binding() {
        takeBroadcast = fitMeetStream.getListBroadcast(status: "ONLINE")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.homeView.tableView.isHidden = false
                    self.listBroadcast.removeAll()
                    self.listBroadcast = response.data!
                    self.bindingOff()
                  
                } else {
                    self.listBroadcast.removeAll()
                    self.bindingOff()
                }
        })
    }
    func bindingNotAuht() {
            takeBroadcast = fitMeetStream.getBroadcast(status: "ONLINE")
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if response.data != nil  {
                        self.homeView.tableView.isHidden = false
                       
                        self.listBroadcast.removeAll()
                        self.listBroadcast = response.data!
                        self.bindingNotOff()
                    } else {
                        self.listBroadcast.removeAll()
                        self.bindingNotOff()
                    }
            })
        }
    
    func bindingOff() {
          takeOff = fitMeetStream.getOffBroadcast()
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { response in
                  if response.data != nil  {
                      self.listBroadcast.append(contentsOf: response.data!)
                      self.bindingPlanned()
                  } else {
                      self.bindingPlanned()
                     
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
                        self.bindingCategory()
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
                       self.bindingCategory()
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
            takeBroadcast = fitMeetStream.getCategory()
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
                if !response.data.isEmpty  {
                    let list = response.data
                    let result = list.filter({ $0.avatarPath != nil })
                    self.listUsers = result
                    self.homeView.tableView.reloadData()
                   
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

