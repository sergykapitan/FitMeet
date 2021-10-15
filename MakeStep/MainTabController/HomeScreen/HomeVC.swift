//
//  HomeVC.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import Foundation
import Combine
import UIKit



class HomeVC: UIViewController,CustomSegmentedControlDelegate,UITabBarControllerDelegate{
    
    func change(to index: Int) {
        if index == 0 {
            self.index = index
           // guard let token =  self.token else { return }
            if token != nil {
                binding()
               // bindingCategory()
            } else {
                bindingNotAuht()
            }
        }
        if index == 1 {
            self.index = index
            bindingRecomandate()
           // bindingCategory()
        }
        if index == 2 {
            self.index = index
            onlyFollowBroadcast(follow: true)
        }
    }

    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var ids = [Int]()
    var complishionHandler: ((Bool) -> Void)?
    var watch = 0

    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    let homeView = HomeVCCode()
   // var fullStack = Dictionary<String, Int>().self
   // var FULL = [[String :Int]].self
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    
    
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
//        if token != nil {
//            binding()
//        } else {
//            bindingNotAuht()
//        }
//        self.index == 0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    
    
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        makeTableView()
        homeView.segmentControll.setButtonTitles(buttonTitles: ["Trending","For you","Subscriptions"])
        homeView.segmentControll.delegate = self
        navigationItem.largeTitleDisplayMode = .always
        makeNavItem()
       // guard let token =  self.token else { return }
       // bindingCategory()
        if token != nil {
            binding()
        } else {
            bindingNotAuht()
        }
        
        homeView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        
    }
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Home"
                   titleLabel.textAlignment = .center
                  // titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
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
        tvc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(tvc, animated: true)
        
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
 
    //MARK: - Selectors
    @objc private func refreshAlbumList() {
        print("refrech")
        if index == 0 {
           // guard let token =  self.token else { return }
            
            if token != nil {
                binding()
            } else {
                bindingNotAuht()
            }
        } else if index == 1 {
            bindingRecomandate()
        } else if index == 2 {
            onlyFollowBroadcast(follow: true)
        }
        
       }
    func binding() {
        takeBroadcast = fitMeetStream.getListBroadcast(status: "ONLINE")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    let filtred = response.data?.filter{$0.type == "STANDART_VOD"}
                    print("Broad === \(filtred)")
                    let arrayUserId = self.listBroadcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.homeView.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.bindingCategory()
                }
        })
    }
    //20//6 cha
    func bindingNotAuht() {
        takeBroadcast = fitMeetStream.getBroadcast(status: "ONLINE")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    let arrayUserId = self.listBroadcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.homeView.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
        })
    }

    func getMapWather(ids: [Int])   {
        watcherMap = fitMeetApi.getWatcherMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.watch = response.data["\(ids.first!)"]!
             
                }
          })
    }
    func bindingRecomandate() {
        takeBroadcast = fitMeetStream.getRecomandateBroadcast()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    let arrayUserId = self.listBroadcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.homeView.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
          })
    }
    func bindingUser(id: Int)  {
        takeUser = fitMeetApi.getUserId(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                    self.user = response
                    self.ar.append(self.user!)
                }
          })
    }
    func bindingUserMap(ids: [Int])  {
        
        takeUser = fitMeetApi.getUserIdMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.usersd = response.data
                    print("ResponceData ===== \(self.usersd)")
                    self.homeView.tableView.reloadData()
                }
          })
    }

    func followBroadcast(id: Int) {
        followBroad = fitMeetStream.followBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil {
                }
          })
    }
    func unFollowBroadcast(id: Int) {
        followBroad = fitMeetStream.unFollowBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil {
                }
         })
    }
    
    func onlyFollowBroadcast(follow: Bool) {
        followBroad = fitMeetStream.getListFollowBroadcast(status: "ONLINE", follow: true)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil {
                    self.listBroadcast = response.data!
                    let arrayUserId = self.listBroadcast.map{$0.id!}
                    print("ARRAY ==== \(self.listBroadcast)")
                    self.bindingUserMap(ids: arrayUserId)
                    self.homeView.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
         })
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
        
    private func makeTableView() {
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self
        homeView.tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseID)
        homeView.tableView.separatorStyle = .none
    }
    func connectUser (broadcastId:String?,channellId: String?) {
        
        guard let broadID = broadcastId,let id = channellId else { return }
     
        SocketWatcher.sharedInstance.getTokenChat()
        SocketWatcher.sharedInstance.establishConnection(broadcastId: "\(broadID)", chanelId: "\(id)")
    }
}

