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
    
    //MARK: -Create a delegate property here.
    weak var delegate: ClassBVCDelegate?
    var navBar: CGFloat?
    
    var broadcastId: String?
    var chanellId: String?
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    var listBroadcast: [BroadcastResponce] = []
    
    var broadcast: BroadcastResponce?
    
    private let refreshControl = UIRefreshControl()
   
    //MARK - LifeCicle
    override func loadView() {
        view = chatView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       // chatView.imageComm.tintColor = .black
       

        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
            DispatchQueue.main.async { () -> Void in
                self.chatMessages.append(messageInfo)
                self.chatView.tableView.reloadData()
               // self.scrollToBottom()
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // makeNavItem()
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
       // chatView.imageComm.image = #imageLiteral(resourceName: "icons8-expand-arrow-100-2")
        //chatView.view.backgroundColor = color
       // chatView.tableView.
        
        
        

        guard let broad = broadcast else { return }
        guard let id = broad.channelIds?.first,let broadID = broad.id else { return }

        SocketIOManager.sharedInstance.getTokenChat()
        SocketIOManager.sharedInstance.establishConnection(broadcastId: "\(broadID)", chanelId: "\(id)")
        makeTableView()
      
    }
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.changeBackgroundColor()
        super.viewDidDisappear(animated)
        print("viewDidDisappear = \(nickname)")
        guard let nic = nickname else { return }
        print("viewDidDisappearGuard = \(nic)")
       // SocketIOManager.sharedInstance.sendStopTypingMessage(nickname: nic)
        
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
    }
    
    @objc func sendMessage() {
        
        let name = UserDefaults.standard.string(forKey: Constants.userFullName)
        
        print("CHAT ==== \(chatView.textView.text.count)")
        
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
            
          //  self.chatView.tableView.reloadData()
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
        guard let nic = nickname else { return }
        print("buttonJoin = \(nic)")
       // SocketIOManager.sharedInstance.sendStopTypingMessage(nickname: nic)
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
    
  
    
    private func makeTableView() {
        chatView.tableView.dataSource = self
        chatView.tableView.delegate = self
        chatView.tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.reuseID)
        chatView.tableView.register(ChatCell.self, forCellReuseIdentifier: CellIds.receiverCellId)
        chatView.tableView.register(ChatCell.self, forCellReuseIdentifier: CellIds.senderCellId)
        chatView.tableView.isHidden = false
        chatView.tableView.estimatedRowHeight = 90.0
        chatView.tableView.rowHeight = UITableView.automaticDimension
        chatView.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func registerForKeyboardNotifications() {
        
    NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShown(_:)),name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector:
    #selector(keyboardWillBeHidden(_:)),name: UIResponder.keyboardWillHideNotification, object: nil)
  }
    
    @objc func keyboardWillShown(_ notificiation: NSNotification) {
       
      // write source code handle when keyboard will show
        let info = notificiation.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        UIView.animate(withDuration: 0.1, animations: { () -> Void in
        if self.chatView.cardView.frame.origin.y == 0 {
            self.chatView.cardView.frame.origin.y -= keyboardFrame.size.height  - CGFloat(30)
            self.view.layoutIfNeeded()
            }
        })
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
       // write source code handle when keyboard will be hidden
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.chatView.cardView.frame.origin.y = 0.0
            self.view.layoutIfNeeded()
            })
      
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)

        }
    
    func scrollToBottom() {
       // let delay = 0.1 * Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { () -> Void in
            if self.chatMessages.count > 0 {
                let lastRowIndexPath = NSIndexPath(row: self.chatMessages.count - 1, section: 0)
                self.chatView.tableView.scrollToRow(at: lastRowIndexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }
    }
    func dismissKeyboard() {
        if chatView.textView.isFirstResponder {
            chatView.textView.resignFirstResponder()
            
//            SocketIOManager.sharedInstance.sendStopTypingMessage(nickname: nickname ?? "")
        }
    }
    func handleConnectedUserUpdateNotification(notification: NSNotification) {
        let connectedUserInfo = notification.object as! [String: AnyObject]
        let connectedUserNickname = connectedUserInfo["message"] as? String
       // lblNewsBanner.text = "User \(connectedUserNickname!.uppercased()) was just connected."
       // showBannerLabelAnimated()
        print("connectedUserNickname =======\(connectedUserInfo)")
    }
    
    
    func handleDisconnectedUserUpdateNotification(notification: NSNotification) {
        let disconnectedUserNickname = notification.object as! String
       // lblNewsBanner.text = "User \(disconnectedUserNickname.uppercased()) has left."
       // showBannerLabelAnimated()
    }
    
    
    func handleUserTypingNotification(notification: NSNotification) {
        if let typingUsersDictionary = notification.object as? [String: AnyObject] {
            var names = ""
            var totalTypingUsers = 0
            for (typingUser, _) in typingUsersDictionary {
                if typingUser != nickname {
                    names = (names == "") ? typingUser : "\(names), \(typingUser)"
                    totalTypingUsers += 1
                }
            }
            
            if totalTypingUsers > 0 {
                let verb = (totalTypingUsers == 1) ? "is" : "are"
                
               // lblOtherUserActivityStatus.text = "\(names) \(verb) now typing a message..."
               // lblOtherUserActivityStatus.isHidden = false
            }
            else {
               // lblOtherUserActivityStatus.isHidden = true
            }
        }
        
    }
    func showBannerLabelAnimated() {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
           // self.lblNewsBanner.alpha = 1.0
            
            }) { (finished) -> Void in
            self.bannerLabelTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: Selector(("hideBannerLabel")), userInfo: nil, repeats: false)
        }
    }
    func hideBannerLabel() {
        if bannerLabelTimer != nil {
            bannerLabelTimer.invalidate()
            bannerLabelTimer = nil
        }
        
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
           // self.lblNewsBanner.alpha = 0.0
            
            }) { (finished) -> Void in
        }
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
    

    func numberOfSections(in tableView: UITableView) -> Int {
            return self.chatMessages.count
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentChatMessage = chatMessages[indexPath.section]
        
        guard let senderNickname = currentChatMessage["username"],
              let message = currentChatMessage["message"],
              let messageDate = currentChatMessage["timestamp"],
              let nic = nickname else { return UITableViewCell()}
        
if senderNickname == nic {
          if let cell = tableView.dequeueReusableCell(withIdentifier: "senderCellId", for: indexPath) as? ChatCell {
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
               let headerView = UIView()
               headerView.backgroundColor = .clear
               return headerView
           }


    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        }

        // Set the spacing between sections
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 10
        }

}

