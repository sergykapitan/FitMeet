
//
//  SearchVideoVC.swift
//  MakeStep
//
//  Created by Sergey on 13.04.2022.
//

import UIKit
import Combine
import Loaf

class SearchVideoVC: SheetableViewController  {

    let searchView = SearchVideoCode()
    
    var listBroadcast: [BroadcastResponce] = []
    var filtredBroadcast: [BroadcastResponce] = []
    
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
 
// MARK: - LifiCicle
  
    override func loadView() {
        super.loadView()
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
        token != nil ?  bindingRec() :  self.bindingNotAuth(name: "a")
    }
    override func copyLink(id: Int) {
        self.searchView.tableView.isUserInteractionEnabled = false
    #if QA
        let urlShare = "https://dev.makestep.com/broadcastQA/\(id)"
    #elseif DEBUG
        let urlShare = "https://makestep.com/broadcast/\(id)"
    #endif
       Loaf("Copy Link :" + urlShare, state: Loaf.State.success, location: .bottom, sender:  self).show(.short){ disType in
           switch disType {
           case .tapped:  self.searchView.tableView.isUserInteractionEnabled = true
           case .timedOut:  self.searchView.tableView.isUserInteractionEnabled = true
           }
         }
    UIPasteboard.general.string = urlShare
    }
//MARK: - Metods
    func bindingRec() {
        takeBroadcast = fitMeetStream.getRecomandateBroadcast()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.filtredBroadcast = self.listBroadcast
                    if self.listBroadcast.isEmpty {
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
    func bindingNotAuth(name: String) {
        takeBroadcast = fitMeetStream.getAllBroadcastNotAuth(name: name)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.filtredBroadcast = self.listBroadcast
                    if self.listBroadcast.isEmpty {
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
    func binding(name: String) {
        takeBroadcast = fitMeetStream.getAllBroadcastPrivate(name: name)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.filtredBroadcast = self.listBroadcast
                    if self.listBroadcast.isEmpty {
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
    
    override func closeView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
//            if let i = self.parent as? SearchVC {
//                i.  .searchView.segmentControll.removeFromSuperview()
//            }
      }
   }
    open func searchVideo(text: String) {
        token != nil ? self.binding(name: text) : self.bindingNotAuth(name: text)                    
    }
//MARK: - Selectors
  
    private func makeTableView() {
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        searchView.tableView.register(SearchVCCell.self, forCellReuseIdentifier: SearchVCCell.reuseID)
        searchView.tableView.separatorStyle = .none
    }

}


