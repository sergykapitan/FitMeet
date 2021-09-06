//
//  ChatVCPlayer.swift
//  MakeStep
//
//  Created by novotorica on 26.07.2021.
//

import Foundation
import Combine
import UIKit




class ChatVCPlayer: UIViewController, UITabBarControllerDelegate, UITableViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate {
      
    let chatView = ChatVCPlayerCode()
    var nickname: String?
    
    var chatMessages = [[String: String]]()
    var bannerLabelTimer: Timer!
    
    var color: UIColor?
    var tint: UIColor?
    let sectionHeaderTitleArray = ["test1","test2","test3"]
    
    //MARK: -Create a delegate property here.
    weak var delegate: ClassBVCDelegate?
    var navBar: CGFloat?
    
    var broadcastId: String?
    var chanellId: String?
    var messHistory: [Datums]?
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    @Inject var fitMeetChat: MakeStepChat
    private var takeMessage: AnyCancellable?
    
    
    
    
    var listBroadcast: [BroadcastResponce] = []
    
    var broadcast: BroadcastResponce?
    
    private let refreshControl = UIRefreshControl()
    
   
    //MARK - LifeCicle
    override func loadView() {
        view = chatView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)        
        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
            DispatchQueue.main.async { () -> Void in
                self.chatMessages.append(messageInfo)
                self.chatView.tableView.reloadData()
                self.chatView.tableView.scrollToBottom()
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        chatView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        chatView.textView.delegate = self
        registerForKeyboardNotifications()
        
        NotificationCenter.default.addObserver(self,selector: Selector(("handleConnectedUserUpdateNotification")), name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: "handleDisconnectedUserUpdateNotification:", name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: "handleUserTypingNotification:", name: NSNotification.Name(rawValue: "userTypingNotification"), object: nil)


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatView.backgroundColor = color
        chatView.sendMessage.tintColor = tint
        chatView.textView.backgroundColor = tint
        chatView.cardView.backgroundColor = color
        chatView.tableView.backgroundColor = color
        if color == .clear {
            chatView.imageComm.image  = UIImage(named: "arrow")
            chatView.labelComm.textColor = .white
        }
        self.chatView.tableView.reloadData()

        guard let broad = broadcast else { return }
        guard let id = broad.channelIds?.first,let broadID = broad.id,let name = UserDefaults.standard.string(forKey: Constants.userFullName) else { return }
        self.nickname = name
        
        bindingMessage(broad: broadID)

        SocketIOManager.sharedInstance.getTokenChat()
        SocketIOManager.sharedInstance.establishConnection(broadcastId: "\(broadID)", chanelId: "\(id)")
        makeTableView()
      
    }
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.changeBackgroundColor()
        super.viewDidDisappear(animated)
        guard let nic = nickname else { return }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }

    func actionButton() {
        chatView.sendMessage.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        chatView.buttonChat.addTarget(self, action: #selector(buttonJoin), for: .touchUpInside)
        chatView.buttonCloseChat.addTarget(self, action: #selector(buttonJoin), for: .touchUpInside)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
       if UIDevice.current.orientation.isLandscape {
              print("Landscape8888")
            dismiss(animated: true)
           } else {
              print("Portrait8888")
            dismiss(animated: true)
            }
    }
    @objc func sendMessage() {
        
        let name = UserDefaults.standard.string(forKey: Constants.userFullName)
        
        
        if chatView.textView.text.count > 0 {
            
            SocketIOManager.sharedInstance.getChatMessage { (old) in
                            print("OLD ==== \(old)")
                            
                        }
            
            SocketIOManager.sharedInstance.sendMessage(message: ["text" : chatView.textView.text!], withNickname: "\(name)")
           self.nickname = name
          // self.chatMessages.append(["username":"\(name!)","message": chatView.textView.text,"date":"5 sec"])
           self.chatView.tableView.reloadData()
            chatView.textView.text = ""
            chatView.textView.resignFirstResponder()

        }
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
        
        delegate?.changeBackgroundColor()
        let tr = CATransition()
        tr.duration = 0.25
        tr.type = CATransitionType.moveIn // use "Reveal" here
        tr.subtype = CATransitionSubtype.fromRight
        view.window!.layer.add(tr, forKey: kCATransition)
        dismiss(animated: true)

    }
    func binding() {
        takeBroadcast = fitMeetStream.getBroadcast(status: "ONLINE")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.chatView.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
        })
    }
    
    func bindingMessage(broad: Int) {
        takeMessage = fitMeetChat.getHistoryMessage(broadId: broad)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
            
                    self.messHistory = response.data
                    guard  let  mess = response.data else { return }
                    var messageDictionary = [String: String]()
                    
                    for i in mess {
                        
                        if i.payload?.message?.text == nil {
                         
                        } else {
                        messageDictionary["username"] = i.user?.fullName
                        messageDictionary["message"] = i.payload?.message?.text
                        messageDictionary["timestamp"] = i.timestamp
                        self.chatMessages.append(messageDictionary)
                        self.chatView.tableView.reloadData()
                        self.chatView.tableView.scrollToBottom()
                        }

                    }
   
                   
                    self.refreshControl.endRefreshing()
                }
            })
        }
    
    
    
  
    
    private func makeTableView() {
        chatView.tableView.dataSource = self
        chatView.tableView.delegate = self
        
        chatView.tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.reuseID)
        chatView.tableView.register(ChatCell.self, forCellReuseIdentifier: CellIds.receiverCellId)
        chatView.tableView.register(ChatCell.self, forCellReuseIdentifier: CellIds.senderCellId)
        
   
    }
    
    func registerForKeyboardNotifications() {
        
    NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShown(_:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillBeHidden(_:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
    
    @objc func keyboardWillShown(_ notificiation: NSNotification) {
       
      // write source code handle when keyboard will show
        let info = notificiation.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        UIView.animate(withDuration: 0.1, animations: { () -> Void in
        if self.chatView.cardView.frame.origin.y == 0 {
            self.chatView.cardView.frame.origin.y -= keyboardFrame.size.height
            self.view.layoutIfNeeded()
            }
        })
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
       // write source code handle when keyboard will be hidden
        let info = notification.userInfo!
   
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.chatView.cardView.frame.origin.y = 0.0
            self.view.layoutIfNeeded()
            })
      
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)

        }
    


}

extension ChatVCPlayer: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == chatView.textView {
                self.chatView.textView.resignFirstResponder()
            }
            return true
        }


}
extension ChatVCPlayer: UITableViewDataSource {
    // number of rows in table view
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return self.chatMessages.count
//        }
//

    func numberOfSections(in tableView: UITableView) -> Int {
        print("SECTION INT === \(self.chatMessages.count)")
            return self.chatMessages.count
        }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentChatMessage = chatMessages[indexPath.section] //section
        
        print("CHATMESS = \(chatMessages)")
        
        guard let senderNickname = currentChatMessage["username"],
              let message = currentChatMessage["message"],
              let messageDate = currentChatMessage["timestamp"],
              let nic = nickname else { return UITableViewCell()}
        
if senderNickname == nic {
          if let cell = tableView.dequeueReusableCell(withIdentifier: "senderCellId", for: indexPath) as? ChatCell {
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
             
               // cell.layer.backgroundColor = UIColor.clear.cgColor
                cell.topLabel.text = senderNickname
                cell.textView.text = message
                cell.bottomLabel.text = messageDate.getFormattedDate(format: "HH:mm:ss")
            
                return cell
            }
} else {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "receiverCellId", for: indexPath) as? ChatCell
       {
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.topLabel.text = senderNickname
                cell.textView.text = message
                cell.bottomLabel.text = messageDate.getFormattedDate(format: "HH:mm:ss")
                return cell
            }
        }
        return UITableViewCell()
    
    }
    
    // MARK: UITextViewDelegate Methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        SocketIOManager.sharedInstance.sendStartTypingMessage(nickname: nickname ?? "")
        
        return true
    }


    
    // MARK: UIGestureRecognizerDelegate Methods
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.sectionHeaderTitleArray[section]
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0))
        returnedView.backgroundColor = .clear
        returnedView.layer.masksToBounds = true
        returnedView.layer.backgroundColor = UIColor.clear.cgColor
           return returnedView
           }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        }

        // Set the spacing between sections
//        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//            return 10
//        }

}
