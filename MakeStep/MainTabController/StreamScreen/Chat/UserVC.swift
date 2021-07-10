//
//  ChatVC.swift
//  MakeStep
//
//  Created by novotorica on 02.07.2021.
//

import Foundation
import Combine
import UIKit

class UserVC: UIViewController, UITabBarControllerDelegate, UITableViewDelegate {
    

  
    let homeView = UserVCCode()
   // var users = [[String: Any]]()
    
    var users = [["nickname": "Claira Pomme", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected": true],
                 ["nickname": "Anastasia Krasnova", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Julia Amonova", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Maria Frolova", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Steven Carpenter", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Jane", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Claira Pomme", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Anastasia Krasnova", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Jane", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Jane", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Jane", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Jane", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Jane", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Jane", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Jane", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Jane", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Jane", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true],["nickname": "Jane", "image": "http://getdrawings.com/free-icon/male-avatar-icon-52.png", "isConnected":  true]]
    
    var nickname: String!
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
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()

    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
       // makeTableView()
        makeNavItem()
        homeView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        homeView.buttonChat.addTarget(self, action: #selector(buttonJoin), for: .touchUpInside)
       // setupGestureRecognizers()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !configurationOK {
            makeNavItem()
            makeTableView()
            configurationOK = true
        }
        
    }
    func askForNickname() {
        let alertController = UIAlertController(title: "SocketChat", message: "Please enter a nickname:", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField(configurationHandler: nil)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) -> Void in
            let textfield = alertController.textFields![0]
            if textfield.text?.count == 0 {
                self.askForNickname()
            }
            else {
                self.nickname = textfield.text
                
                SocketIOManager.sharedInstance.connectToServerWithNickname(nickname: self.nickname, completionHandler: { (userList) -> Void in
                    DispatchQueue.main.async { () -> Void in
                        if userList != nil {
                            guard let usr = userList else { return }
                           // self.users = usr
                            self.homeView.tableView.reloadData()
                            self.homeView.tableView.isHidden = false
                        }
                    }
                })
            }
        }
        
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Chat"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

                   let stackView = UIStackView(arrangedSubviews: [titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .vertical

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "Note"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction)),
                                                   UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction))]
    }
    @objc
    func rightHandAction() {
        print("right bar button action")
    }

    @objc
    func leftHandAction() {
        print("left bar button action")
    }
    //MARK: - Selectors
    @objc private func refreshAlbumList() {
        print("refrech")
        binding()
      
       }
    @objc  func buttonJoin() {
        dismiss(animated: true)
        
//        SocketIOManager.sharedInstance.getTokenChat()
//        guard let token =  UserDefaults.standard.value(forKey: "tokenChat") else { return }
//        print( token )
//
//        SocketIOManager.sharedInstance.connectToServerWithNickname(nickname: token as! String, completionHandler: { (userList) -> Void in
//            DispatchQueue.main.async { () -> Void in
//                print("USERLIST ======= \(userList)")
//                if userList != nil {
//                    guard let usr = userList else { return }
//                  //  self.users = usr
//                    self.homeView.tableView.reloadData()
//                    self.homeView.tableView.isHidden = false
//                }
//            }
//        })
    }
    func binding() {
        takeBroadcast = fitMeetStream.getBroadcast(status: "ONLINE")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
               // print("RESPONCE ====== \(response)")
                if response.data != nil  {
                    print("Responce ====== \(response)")
                    self.listBroadcast = response.data!
                    self.homeView.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
        })
    }
    
  
    
    private func makeTableView() {
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self
        homeView.tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseID)
        homeView.tableView.isHidden = false
    }

}
extension UserVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.setImage(image: (users[indexPath.row]["image"] as? String)!)
        cell.titleLabel.text = users[indexPath.row]["nickname"] as? String
        cell.labelCategory.text =  (users[indexPath.row]["isConnected"] as! Bool) ? "Online" : "Offline"
        cell.labelCategory.textColor = (users[indexPath.row]["isConnected"] as! Bool) ? UIColor.green : UIColor.red
        cell.backgroundColor = .clear
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
}
// MARK: - Private
private extension UserVC {
//  func setupGestureRecognizers() {
//    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
//    view.addGestureRecognizer(tapRecognizer)
//  }
}

// MARK: - GestureRecognizerSelectors
private extension UserVC {
//  @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
//    dismiss(animated: true)
//  }
}
