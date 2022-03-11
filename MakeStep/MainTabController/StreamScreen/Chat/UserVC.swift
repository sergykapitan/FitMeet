//
//  ChatVC.swift
//  MakeStep
//
//  Created by novotorica on 02.07.2021.
//

import Foundation
import Combine
import UIKit

protocol ClassUserDelegate: class {
    func changeButton()
}

class UserVC: UIViewController, UITabBarControllerDelegate, UITableViewDelegate {
    

  
    let homeView = UserVCCode()
    
    var broadcastId: String?
    var chanellId: String?
    var nickname: String?
    var isLand:Bool = false
    
    weak var delegate: ClassUserDelegate?
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeUser: AnyCancellable?
    
    var usersd = [Int: User]()
    var configurationOK = false
    
    
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    var listBroadcast: [BroadcastResponce] = []
    private let refreshControl = UIRefreshControl()
   

    
    
    //MARK - LifeCicle
    override func loadView() {
        view = homeView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

       
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if isLand {
            homeView.cardView.backgroundColor = .white
        } else {
            homeView.cardView.backgroundColor = .clear
            homeView.cardView.layer.cornerRadius = 8
            homeView.cardView.layer.borderWidth = 0.8
            homeView.cardView.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        }
        
        
        homeView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        homeView.buttonChat.addTarget(self, action: #selector(buttonJoin), for: .touchUpInside)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        guard let broadId = broadcastId,let channelId = chanellId else { return }
      
            SocketIOManager.sharedInstance.getTokenChat()
            SocketIOManager.sharedInstance.establishConnection(broadcastId: broadId, chanelId: "\(chanellId)")
            SocketIOManager.sharedInstance.connectToServerWithNickname(nicname: "OLD") { arrayId in
                  
                guard let array = arrayId else { return }
                self.bindingUserMap(ids: array)
               }

            makeTableView()
            homeView.tableView.reloadData()
      
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.changeButton()
    }

    //MARK: - Selectors
    @objc private func refreshAlbumList() {
      
      
       }
    @objc  func buttonJoin() {

        guard let name = UserDefaults.standard.string(forKey: Constants.userFullName) else { return }
        self.nickname = name
  
        SocketIOManager.sharedInstance.connectToServerWithNickname( nicname: "Old", completionHandler: { (userList) -> Void in
            DispatchQueue.main.async { () -> Void in

            }
        })
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
       if UIDevice.current.orientation.isLandscape {
            dismiss(animated: true)
           } else {
            dismiss(animated: true)
            }
    }

    private func makeTableView() {
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self
        homeView.tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseID)
        homeView.tableView.isHidden = false
        homeView.tableView.separatorStyle  = .none
    }
    
    func bindingUserMap(ids: [Int])  {
        takeUser = fitMeetApi.getUserIdMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    let dict = response.data
                    self.usersd = dict
                    self.homeView.tableView.reloadData()
   
                }
          })
    }

}
extension UserVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell

        let us = usersd.map { key,user in
            return user
        }
        cell.setImage(image: us[indexPath.row].avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
        cell.layoutIfNeeded()
        cell.titleLabel.text = us[indexPath.row].fullName
        cell.labelCategory.text =  "Online"
        cell.labelCategory.textColor = UIColor.lightGray
        cell.backgroundColor = .clear
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
}
