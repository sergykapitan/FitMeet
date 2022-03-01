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
            if token != nil {
                self.homeView.tableView.reloadData()
                binding()
            } else {
                bindingNotAuht()
                self.homeView.tableView.reloadData()
            }
        }
        if index == 1 {
            self.index = index
            if token != nil {
                self.listBroadcast.removeAll()
                bindingRecomandate()
                self.homeView.tableView.reloadData()
            } else {
                self.listBroadcast.removeAll()
                bindingRecomandate()
                self.homeView.tableView.reloadData()
            }
        }
        if index == 2 {
            self.index = index
            self.listBroadcast.removeAll()
            onlyFollowBroadcast(follow: true)
            self.homeView.tableView.reloadData()
        }
    }

//    override  var shouldAutorotate: Bool {
//        return false
//    }
//    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
    
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
        homeView.segmentControll.setButtonTitles(buttonTitles: ["Trending","For you","Subscriptions"])
        homeView.segmentControll.delegate = self
        navigationItem.largeTitleDisplayMode = .always
        makeNavItem()
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
        let tvc = Timetable()
        tvc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(tvc, animated: true)
        
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
 
    //MARK: - Selectors
    @objc private func refreshAlbumList() {
        if index == 0 {
            if token != nil {
                binding()
               
            } else {
                bindingNotAuht()
            }
        } else if index == 1 {
            self.listBroadcast.removeAll()
            bindingRecomandate()
        } else if index == 2 {
            self.listBroadcast.removeAll()
            onlyFollowBroadcast(follow: true)
        }
        
       }
    func binding() {
        takeBroadcast = fitMeetStream.getListBroadcast(status: "ONLINE")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.homeView.tableView.isHidden = false
                    self.homeView.label.isHidden = true
                    self.listBroadcast.removeAll()
                    self.listBroadcast = response.data!
                    self.bindingPlanned()
                  
                } else {
                    self.listBroadcast.removeAll()
                    self.bindingPlanned()
                }
        })
    }
    func getUsers() {
        takeUser = fitMeetStream.getListAllUser()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listUsers = response.data
                    self.homeView.tableView.reloadData()
                   
                }
          })
    }
    func bindingPlanned() {
        takePlan = fitMeetStream.getListPlanBroadcast()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast.append(contentsOf: response.data!)
                    self.bindingOff()
                } else {
                    self.bindingOff()
                }
            })
    }
    func bindingOff() {
        takeOff = fitMeetStream.getOffBroadcast()
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
    func bindingNotAuht() {
        takeBroadcast = fitMeetStream.getBroadcast(status: "ONLINE")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.homeView.tableView.isHidden = false
                    self.homeView.label.isHidden = true
                    self.listBroadcast.removeAll()
                    self.listBroadcast = response.data!
                    self.bindingNotPlanned()
                } else {
                    self.listBroadcast.removeAll()
                    self.bindingNotPlanned()
                }
        })
    }
    func bindingNotPlanned() {
        takePlan = fitMeetStream.getNotPlanBroadcast()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast.append(contentsOf: response.data!)
                    self.bindingNotOff()
                } else {
                    self.bindingNotOff()
                }
            })
    }
    func bindingNotOff() {
        takeOff = fitMeetStream.getNotOffBroadcast()
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
                if response.data?.first?.id != nil  {
                    self.homeView.tableView.isHidden = false
                    self.homeView.label.isHidden = true
                    self.listBroadcast.removeAll()
                    self.listBroadcast = response.data!
                    let arrayUserId = self.listBroadcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.homeView.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                } else {
                    self.homeView.tableView.isHidden = true
                    self.homeView.label.isHidden = false
                    self.homeView.label.text = "there are no suitable broadcasts"
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

    func followBroadcast(id: Int) {
        followBroad = fitMeetStream.followBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
          
          })
    }
    func unFollowBroadcast(id: Int) {
        followBroad = fitMeetStream.unFollowBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
            
         })
    }
    
    func onlyFollowBroadcast(follow: Bool) {
        followBroad = fitMeetStream.getBroadcastSubscription()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                self.listBroadcast.removeAll()
                self.homeView.tableView.reloadData()
                if response.data?.first?.id != nil {
                   
                    self.listBroadcast = response.data!
                    let arrayUserId = self.listBroadcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.homeView.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                } else {
                    self.homeView.tableView.isHidden = true
                    self.homeView.label.isHidden = false
                    self.homeView.label.text = "no subscriptions"
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
    enum Section {
        case authors(authors: [User])
        case post(items: [BroadcastResponce])
        
        var cellIdentifer: String {
            switch self {
            case .authors(_): return CellIdentifier.horizontalList
            case .post(_): return CellIdentifier.post
            }
        }
    }
      
    struct CellIdentifier {
        static var horizontalList = "HomeHorizontalListTableViewCell"
        static var post = HomeCell.reuseID
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

