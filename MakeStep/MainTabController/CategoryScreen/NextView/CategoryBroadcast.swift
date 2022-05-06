//
//  CategoryBroadcast.swift
//  FitMeet
//
//  Created by novotorica on 10.06.2021.
//

import Foundation
import Combine
import UIKit
import Loaf

class CategoryBroadcast: SheetableViewController  {
    

    let categoryView = CategoryBroadcastCode()
    
    
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
   
    var sortListCategory: [BroadcastResponce] = []
    var categoryid: Int?
    var categoryTitle: String?
    var arrayIdUser = [Int]()
    var ids = [Int]()
    var watch = 0
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeUser: AnyCancellable?
    private var followBroad: AnyCancellable?
    private var watcherMap: AnyCancellable?
    
    
    
    var listBroadcast: [BroadcastResponce] = []
    private let refreshControl = UIRefreshControl()
   
    var user: User?
    var ar =  [User]()
    var index = 0
    var url:String?
    var usersd = [Int: User]()

    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - LifeCicle
    override func loadView() {
        view = categoryView
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
        guard let categoryid = categoryid else { return}
        token != nil ? binding(categoryId: categoryid) : bindingNotAuth(categoryId: categoryid)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        makeTableView()
        makeNavItem()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

    }
    override func copyLink(id: Int) {
        super.copyLink(id: id)
        self.categoryView.tableView.isUserInteractionEnabled = false
    }
    override func stopLoaf() {
        self.categoryView.tableView.isUserInteractionEnabled = true
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
         if let swipeGesture = gesture as? UISwipeGestureRecognizer {

             switch swipeGesture.direction {
             case UISwipeGestureRecognizer.Direction.right:
                 self.navigationController?.popViewController(animated: true)
             default:
                 break
             }
         }
     }
    func makeNavItem() {
        guard let categoryTitle = categoryTitle else {  return  }

        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
                    let titleLabel = UILabel()
                    titleLabel.text = "  " + categoryTitle
                    titleLabel.textAlignment = .center
                    titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                    titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
                    let backButton = UIButton()
                    backButton.setBackgroundImage(#imageLiteral(resourceName: "backButton"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)
  
                   let stackView = UIStackView(arrangedSubviews: [backButton ,titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .horizontal

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "notifications1"), style: .plain, target: self, action:  #selector(rightHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(rightHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
       // self.navigationItem.rightBarButtonItems = [startItem,timeTable]
    }
    @objc  func rightHandAction() {
        print("right bar button action")
    }
    @objc  func leftHandAction() {
        print("left bar button action")
    }
//    @objc func rightBack() {
//        self.navigationController?.popViewController(animated: true)
//    }

    func binding(categoryId: Int) {
        takeBroadcast = fitMeetStream.getBroadcastCategoryId(categoryId: categoryId, page: 1)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in           
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.sortListCategory = response.data!
                    let arrayUserId = self.sortListCategory.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                }
          })
    }
    func bindingNotAuth(categoryId: Int) {
        takeBroadcast = fitMeetStream.getBroadcastCategoryIdNotAuth(categoryId: categoryId)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.sortListCategory = response.data!
                    let arrayUserId = self.sortListCategory.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                }
         })
    }
    func bindingUserMap(ids: [Int])  {
        takeUser = fitMeetApi.getUserIdMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.usersd = response.data
                    self.categoryView.tableView.reloadData()
                }
          })
    }

    private func makeTableView() {
        categoryView.tableView.dataSource = self
        categoryView.tableView.delegate = self
        categoryView.tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseID)
        categoryView.tableView.separatorStyle = .none
    }
    func connectUser (broadcastId:String?,channellId: String?) {
        guard let broadID = broadcastId,let id = channellId else { return }
        SocketWatcher.sharedInstance.getTokenChat()
        SocketWatcher.sharedInstance.establishConnection(broadcastId: "\(broadID)", chanelId: "\(id)")
    }

}

