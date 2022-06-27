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
    private var channelMap: AnyCancellable?
    private var channelMap1: AnyCancellable?
    private var channelMap2: AnyCancellable?
    
    var listBroadcast: [BroadcastResponce] = []
    var liveBroadcast: [BroadcastResponce] = []
    var recentBroadcast: [BroadcastResponce] = []
    var plannedBroadcast: [BroadcastResponce] = []
    
    
    var itemCount: Int = 0

    private let refreshControl = UIRefreshControl()
    var isLoadingList : Bool = false
    var userMap = [Int: User]()
    var channellsd = [Int: ChannelResponce]()
    var channellsd1 = [Int: ChannelResponce]()
    var channellsd2 = [Int: ChannelResponce]()
    var titleSection = ["Live Now","Recent Live Streams","Upcoming Live Streams"]
    var widthScreen = UIScreen.main.bounds.width
    
  // MARK: - LifeCicle
    override func loadView() {
        view = liveView
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
  // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
        bindingLive()
        bindingRecent()
        bindingPlanned()
        widthScreen <= 400 ? makeNavItem(title: " Live", hide: true) : makeNavItem(title: "Live", hide: true)
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
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

                       // let arrayUserId =  self.liveBroadcast.map{$0.userId!}
                       // self.bindingUserMap(ids: arrayUserId)
                        let arrayUserId =  self.liveBroadcast.compactMap{$0.channelIds?.last!}
                       // self.bindingUserMap(ids: arrayUserId)
                        self.getMapChannel(ids: arrayUserId)
                      //  self.bindingRecent()
                    }
            })
    }
    func bindingRecent() {
        takeBroadcast = fitMeetStream.getBroadcastinRecent(status: .offline)
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if response.data != nil  {
                        guard let responceUnrap = response.data else { return }
                        sleep(1)
                        self.recentBroadcast = responceUnrap

                        let arrayUserId =  self.recentBroadcast.compactMap{$0.channelIds?.last}
                        self.getMapChannel1(ids: arrayUserId)
                    }
            })
    }
    func bindingPlanned() {
        takePlannedBroadcast = fitMeetStream.getBroadcastinLive(status: .planned)
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if response.data != nil  {
                        guard let responceUnrap = response.data else { return }
                        sleep(1)
                        self.plannedBroadcast = responceUnrap

                       // let arrayUserId =  self.plannedBroadcast.map{$0.userId!}
                        //self.bindingUserMap(ids: arrayUserId)
                        let arrayUserId =  self.plannedBroadcast.compactMap{$0.channelIds?.last!}
                       // self.bindingUserMap(ids: arrayUserId)
                        self.getMapChannel2(ids: arrayUserId)
                    } else {
                        self.titleSection.removeLast()
                        self.liveView.tableView.reloadData()
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
                          let idsChannel = self.userMap.values.compactMap{ $0.channelIds?.last}
                          self.getMapChannel(ids: idsChannel)
                         // self.refreshControl.endRefreshing()
                         // self.liveView.tableView.reloadData()
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
                            self.liveView.tableView.reloadData()
                     })
         }
    func getMapChannel1(ids: [Int])   {
        channelMap1 = fitMeetApi.getChannelMap(ids: ids)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { response in
                            self.channellsd1 = response.data
                            self.refreshControl.endRefreshing()
                            self.liveView.tableView.reloadData()
                     })
         }
    func getMapChannel2(ids: [Int])   {
        channelMap2 = fitMeetApi.getChannelMap(ids: ids)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { response in
                            self.channellsd2 = response.data
                            self.refreshControl.endRefreshing()
                            self.liveView.tableView.reloadData()
                     })
         }
    func connectUser (broadcastId:String?,channellId: String?) {
        guard let broadID = broadcastId,let id = channellId else { return }     
        SocketWatcher.sharedInstance.getTokenChat()
        SocketWatcher.sharedInstance.establishConnection(broadcastId: "\(broadID)", chanelId: "\(id)")
    }
 }
