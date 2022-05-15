//
//  LiveVC.swift
//  MakeStep
//
//  Created by Sergey on 06.05.2022.
//

import Combine
import UIKit
import Loaf
import SwiftUI


class LiveVC: SheetableViewController {
    
    let liveView = LiveVCCode()
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeLiveBroadcast: AnyCancellable?
    private var takeBroadcast: AnyCancellable?
    private var takePlannedBroadcast: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeUser: AnyCancellable?
    
    var listBroadcast: [BroadcastResponce] = []
    var liveBroadcast: [BroadcastResponce] = []
    var recentBroadcast: [BroadcastResponce] = []
    var plannedBroadcast: [BroadcastResponce] = []
    
    
    var itemCount: Int = 0

    private let refreshControl = UIRefreshControl()
    var isLoadingList : Bool = false
    var userMap = [Int: User]()
    var titleSection = ["Live Now","Recent Live Streams","Upcoming Live Streams"]
   
    
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
        bindingLive()
        bindingRecent()
        bindingPlanned()
        makeNavItem(title: "Live", hide: true)
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
    func bindingLive() {
        takeLiveBroadcast = fitMeetStream.getBroadcastinLive(status: .online)
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if response.data != nil  {
                        guard let responceUnrap = response.data else { return }
                        self.liveBroadcast = responceUnrap

                        let arrayUserId =  self.liveBroadcast.map{$0.userId!}
                        self.bindingUserMap(ids: arrayUserId)
                    }
            })
    }
    func bindingRecent() {
        takeBroadcast = fitMeetStream.getBroadcastinLive(status: .offline)
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if response.data != nil  {
                        guard let responceUnrap = response.data else { return }
                        self.recentBroadcast = responceUnrap.filter{$0.resizedPreview != nil}

                        let arrayUserId =  self.recentBroadcast.map{$0.userId!}
                        self.bindingUserMap(ids: arrayUserId)
                    }
            })
    }
    func bindingPlanned() {
        takePlannedBroadcast = fitMeetStream.getBroadcastinLive(status: .planned)
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if response.data != nil  {
                        guard let responceUnrap = response.data else { return }
                        self.plannedBroadcast = responceUnrap

                        let arrayUserId =  self.plannedBroadcast.map{$0.userId!}
                        self.bindingUserMap(ids: arrayUserId)
                    } else {
                        self.titleSection.removeLast()
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
    func connectUser (broadcastId:String?,channellId: String?) {
        guard let broadID = broadcastId,let id = channellId else { return }     
        SocketWatcher.sharedInstance.getTokenChat()
        SocketWatcher.sharedInstance.establishConnection(broadcastId: "\(broadID)", chanelId: "\(id)")
    }
 }
