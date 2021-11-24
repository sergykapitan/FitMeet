//
//  ButtonComming.swift
//  MakeStep
//
//  Created by Sergey on 23.11.2021.
//

import Foundation
import UIKit
import Combine
import AudioToolbox

class ButtonCommingg: UIViewController {

   
    let commingView = ButtonCommingCode()
    var userId = 0
    var brodcast: [BroadcastResponce] = []

    private var take: AnyCancellable?
    private var followBroad: AnyCancellable?
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetStream: FitMeetStream
    
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    var url: String?
    var user: User?
    
    var usersd = [Int: User]()
 
    override func loadView() {
        super.loadView()
        view = commingView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bindingBroadcast(status: "PLANNED", userId: "\(userId)")
     
    }
 
      
    private func createTableView() {
        commingView.tableView.dataSource = self
        commingView.tableView.delegate = self
        commingView.tableView.register(PlayerViewCell.self, forCellReuseIdentifier: PlayerViewCell.reuseID)
        commingView.tableView.separatorStyle = .none
        commingView.tableView.showsVerticalScrollIndicator = false
    }

    //MARK: - Selectors

    func bindingBroadcast(status: String,userId: String) {
        take = fitMeetStream.getBroadcastPrivate(status: status, userId: userId)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                   
                    self.brodcast = response.data!
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.commingView.tableView.reloadData()
                }
           })
       }
    func bindingUserMap(ids: [Int])  {
        take = fitMeetApi.getUserIdMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.usersd = response.data
                    self.commingView.tableView.reloadData()
                }
          })
    }
    func followBroadcast(id: Int) {
        followBroad = fitMeetStream.followBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.categories != nil {
                }
          })
    }
    func unFollowBroadcast(id: Int) {
        followBroad = fitMeetStream.unFollowBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
             
         })
    }
    private func vibrate() {
        if #available(iOS 10.0, *) {
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

