//
//  SearchUserVC.swift
//  MakeStep
//
//  Created by Sergey on 13.04.2022.
//

import UIKit
import Combine

class SearchUserVC: UIViewController  {
    
   
    let searchView = SearchVideoCode()
    
    var listUsers:[User]?
    var filterListUser:[User]?
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    @Inject var makeApi: FitMeetApi
    private var takeUser: AnyCancellable?
    private var channelMap: AnyCancellable?

    
    var channellsd = [Int: ChannelResponce]()
    var broadcast:BroadcastResponce?
 
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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    override func loadView() {
        super.loadView()
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
        getUsers(name: "a")
    }
    func getBroadcast(userId: String) {
        takeBroadcast = fitMeetStream.getBroadcastPrivateID(userId: userId)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    let arrayBroadcast = response.data?.filter{ $0.status == .online}
                    self.broadcast = response.data?.first
                }
         })
    }
    func getUsers(name: String) {
        takeUser = fitMeetStream.getListUser(name: name)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listUsers = response.data
                    guard let listUsers = self.listUsers else { return  }

                    if listUsers.isEmpty {
                        self.searchView.tableView.isHidden = true
                        self.searchView.labelNtResult.isHidden = false
                    } else {
                        self.searchView.tableView.isHidden = false
                        self.searchView.labelNtResult.isHidden = true
                        let arrayUserId = listUsers.compactMap{$0.channelIds?.last}
                        self.getMapChannel(ids: arrayUserId)
                        self.searchView.tableView.reloadData()
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
                    guard let listUsers = self.listUsers else { return }

                    if listUsers.isEmpty {
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
    func getMapChannel(ids: [Int])   {
       
        channelMap = makeApi.getChannelMap(ids: ids)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { response in
                
                
                          self.channellsd = response.data
                          guard let listUsers = self.listUsers else { return }
                          let compUser = listUsers.compactMap { $0 }
                          if !self.channellsd.isEmpty {
                              self.listUsers = compUser.sorted(by: {self.channellsd[($0.channelIds?.last!)!]!.followersCount > self.channellsd[($1.channelIds?.last!)!]!.followersCount })
                          self.searchView.tableView.reloadData()
                          }
                     })
         }
    open func searchUser(text: String) {
        getreversUsers(name: text)
    }

//MARK: - Selectors
  
    private func makeTableView() {
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        searchView.tableView.register(SearchVCUserCell.self, forCellReuseIdentifier: SearchVCUserCell.reuseID)
        searchView.tableView.separatorStyle = .none
    }

}



