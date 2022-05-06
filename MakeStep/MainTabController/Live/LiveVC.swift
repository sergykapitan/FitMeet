//
//  LiveVC.swift
//  MakeStep
//
//  Created by Sergey on 06.05.2022.
//

import Combine
import UIKit
import Loaf


class LiveVC: SheetableViewController {
    
    let liveView = LiveVCCode()
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeUser: AnyCancellable?
    
    var listBroadcast: [BroadcastResponce] = []
    var itemCount: Int = 0

    private let refreshControl = UIRefreshControl()
    var isLoadingList : Bool = false
    var userMap = [Int: User]()
    let titleSection = ["Live Now","Recent Live Streams","Upcoming Live Streams"]
   
    
  // MARK: - LifeCicle
    override func loadView() {
        view = liveView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
  // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
        actionButton ()
        bindingNotAuht(page: 1)
        makeNavItem(title: " Live", hide: true)
    }
   
    override func copyLink(id: Int) {
        super.copyLink(id: id)
        self.liveView.tableView.isUserInteractionEnabled = false
    }
    override func stopLoaf() {
        self.liveView.tableView.isUserInteractionEnabled = true
    }
    deinit {
     print("deinit LiveVC")
    }
   
    func actionButton () {
      
    }
  
    private func makeTableView() {
        liveView.tableView.dataSource = self
        liveView.tableView.delegate = self
        liveView.tableView.register(PlayerViewCell.self, forCellReuseIdentifier: PlayerViewCell.reuseID)
        liveView.tableView.separatorStyle = .none
        liveView.tableView.showsVerticalScrollIndicator = false
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
 
 // MARK: - NetworkMetod
    func bindingNotAuht(page: Int) {
           self.isLoadingList = false
           takeBroadcast = fitMeetStream.getBroadcastN(page: page)
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
       func bindingUserMap(ids: [Int])  {
                  if ids.isEmpty { return } else {
                  takeUser = fitMeetApi.getUserIdMap(ids: ids)
                      .mapError({ (error) -> Error in return error })
                      .sink(receiveCompletion: { _ in }, receiveValue: { response in
                          if response.data.count != 0 {
                              self.userMap = response.data
                              self.refreshControl.endRefreshing()
                              self.liveView.tableView.reloadData()
                          }
                     })
                 }
             }
 }
