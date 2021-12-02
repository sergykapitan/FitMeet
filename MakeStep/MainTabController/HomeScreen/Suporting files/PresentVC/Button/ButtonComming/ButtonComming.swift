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
    private var taskStream: AnyCancellable?
    private var startStream: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetStream: FitMeetStream
    
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    var url: String?
    var user: User?
    var broadcast:  BroadcastResponce?

    var myuri: String?
    var myPublish: String?
    
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    let selfId = UserDefaults.standard.string(forKey: Constants.userID)
    
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
        if token != nil {
            self.bindingBroadcast(status: "PLANNED", userId: "\(userId)")
        } else {
            self.bindingBroadcastNotAuth(status: "PLANNED", userId: "\(userId)")
        }
       
     
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
    func bindingBroadcastNotAuth(status: String,userId: String) {
        take = fitMeetStream.getBroadcastNotAuth(status: status, userId: userId)
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
    func nextView(broadcastId: Int )  {
         startStream = fitMeetStream.startBroadcastId(id: broadcastId)
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if let id = response.id  {
                        self.broadcast = response
                        UserDefaults.standard.set(self.broadcast?.id, forKey: Constants.broadcastID)
                        self.fetchStream(id: self.broadcast?.id, name: response.name)
                    }
            })
    }
    func fetchStream(id:Int?,name: String?) {
            let UserId = UserDefaults.standard.string(forKey: Constants.userID)
            guard let id = id , let name = name , let userId = UserId  else{ return }
            let usId = Int(userId)
            guard let usID = usId else { return }
            taskStream = fitMeetStream.startStream(stream: StartStream(name: name, userId: usID , broadcastId: id))
                .mapError({ (error) -> Error in
                      print(error)
                       return error })
                     .sink(receiveCompletion: { _ in }, receiveValue: { response in
                        guard let url = response.url else { return }
                        UserDefaults.standard.set(url, forKey: Constants.urlStream)
                        let twoString = self.removeUrl(url: url)
                        self.myuri = twoString.0
                        self.myPublish = twoString.1
                        self.url = url
   
                            let navVC = LiveStreamViewController()
                            navVC.modalPresentationStyle = .fullScreen
                            navVC.idBroad = id
                            guard let myuris = self.myuri,let myPublishh = self.myPublish else { return }
                            navVC.myuri = myuris
                            navVC.myPublish = myPublishh
                            self.present(navVC, animated: true, completion: nil)
                         
                        })
                    }
    
    
    func removeUrl(url: String) -> (url:String,publish: String) {
            let fullUrlArr = url.components(separatedBy: "/")
            let myuri = fullUrlArr[0] + "//" + fullUrlArr[2] + "/" + fullUrlArr[3]
            let myPublish = fullUrlArr[4]
            return (myuri,myPublish)
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

