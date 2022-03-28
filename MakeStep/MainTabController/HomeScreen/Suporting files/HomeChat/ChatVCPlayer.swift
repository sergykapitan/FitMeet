//
//  ChatVCPlayer.swift
//  MakeStep
//
//  Created by novotorica on 26.07.2021.
//

import Foundation
import Combine
import UIKit
import EasyPeasy





class ChatVCPlayer: UIViewController, UITabBarControllerDelegate, UITableViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate {
      
    let chatView = ChatVCPlayerCode()
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    var nickname: String?
    var isLand:Bool = false
    
    var chatMessages = [[String: Any]]()
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
    var user: User?
    var usersd = [Int: User]()
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    @Inject var fitMeetChat: MakeStepChat
    private var takeMessage: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeUser: AnyCancellable?
    
    private var aspectRatioTextViewConstraint: NSLayoutConstraint?
    private var tvHeightConstraint: NSLayoutConstraint?
    
    
    var listBroadcast: [BroadcastResponce] = []
    
    var broadcast: BroadcastResponce?
    
    private let refreshControl = UIRefreshControl()
    
   
    //MARK - LifeCicle
    override func loadView() {
        view = chatView
        self.view.backgroundColor = UIColor.white
        self.textView.delegate = self
               
        self.textView.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
        
        self.textView.layer.borderWidth = 1.5
        self.textView.layer.cornerRadius = 20
      //  self.textView.clipsToBounds = true
        self.textView.font =  UIFont.systemFont(ofSize: 18)
       
       
        self.view.addSubview(self.textView)
        self.textView.clipsToBounds = true
        self.textView.isScrollEnabled = false
        
      
        
        self.textView.easy.layout(Left(20),Right(0).to(chatView.sendMessage),Height(maxHeight).when({[unowned self] in self.isOversized}))
      
        self.textView.anchor(bottom:self.chatView.cardView.bottomAnchor,paddingBottom: 30)
      
        textView.textContainerInset = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 5)
        self.textView.delegate = self
 
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if token != nil {
            SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
                DispatchQueue.main.async { () -> Void in
                    self.chatMessages.append(messageInfo)
                    self.chatView.tableView.reloadData()
                    self.chatView.tableView.scrollToBottom()
                }
            }
        }
       
    }
  
    
    private lazy var textView: UITextView = {
        let view = UITextView(frame: CGRect.zero)
        view.backgroundColor  =  .white
        return view
    }()
  
    private var isOversized = false {
            didSet {
                self.textView.easy.reload()
                self.textView.isScrollEnabled = isOversized
            }
        }
        
        private let maxHeight: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        chatView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
       // chatView.tableView.delegate = self
        registerForKeyboardNotifications()
        if isLand {
            chatView.cardView.backgroundColor = .white
        } else {
            chatView.cardView.backgroundColor = .clear
            chatView.cardView.layer.cornerRadius = 8
            chatView.cardView.layer.borderWidth = 0.8
            chatView.cardView.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        }

//        NotificationCenter.default.addObserver(self,selector: Selector(("handleConnectedUserUpdateNotification")), name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: "handleDisconnectedUserUpdateNotification:", name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: "handleUserTypingNotification:", name: NSNotification.Name(rawValue: "userTypingNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleConnectedUserUpdateNotification(notification:)), name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDisconnectedUserUpdateNotification(notification:)), name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserTypingNotification(notification:)), name: NSNotification.Name(rawValue: "userTypingNotification"), object: nil)


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatView.backgroundColor = color
        chatView.sendMessage.tintColor = tint
        textView.backgroundColor = tint
        chatView.cardView.backgroundColor = color
        chatView.tableView.backgroundColor = color
        textView.textColor = .lightGray
      
        self.chatView.tableView.reloadData()

        guard let broad = broadcast else { return }
        guard let id = broad.channelIds?.first,let broadID = broad.id,let name = UserDefaults.standard.string(forKey: Constants.userFullName) else { return }
        self.nickname = name
        
        
        
        if token != nil {
    
            bindingMessage(broad: broadID)
            SocketIOManager.sharedInstance.getTokenChat()
            SocketIOManager.sharedInstance.establishConnection(broadcastId: "\(broadID)", chanelId: "\(id)")
                    makeTableView()
            SocketIOManager.sharedInstance.connectToServerWithNickname(nicname: "\(name)") { arrayId in
                  
                guard let array = arrayId else { return }
                self.bindingUserMap(ids: array)
               }
            
            chatView.tableView.isHidden = false
            chatView.imageNotToken.isHidden = true
        } else {
            chatView.tableView.isHidden = true
            chatView.imageNotToken.isHidden = false
        }
      
    }
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.changeBackgroundColor()
        super.viewDidDisappear(animated)

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

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
        chatView.buttonCloseChat.addTarget(self, action: #selector(buttonJoin), for: .touchUpInside)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
       if UIDevice.current.orientation.isLandscape {
            dismiss(animated: true)
           } else {
            dismiss(animated: true)
            }
    }
    @objc func handleConnectedUserUpdateNotification(notification: NSNotification) {
        let connectedUserInfo = notification.object as! [String: AnyObject]
        let connectedUserNickname = connectedUserInfo["user"] //as? String
        guard  let id = connectedUserNickname?["userId"] as? Int else { return }
        var setId: Set<Int> = []
        setId.insert(id)
        let array = Array(setId)
        self.bindingUserMap(ids: array)
    }
    
    
    @objc func handleDisconnectedUserUpdateNotification(notification: NSNotification) {
        let disconnectedUserNickname = notification.object as! String
    }
    
    
    @objc func handleUserTypingNotification(notification: NSNotification) {
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
            }
        }
    }
    @objc func sendMessage() {
        if token != nil {
            chatView.tableView.isHidden = false
            let name = UserDefaults.standard.string(forKey: Constants.userFullName)
            if textView.text.count > 0 {
                SocketIOManager.sharedInstance.sendMessage(message: ["text" : textView.text!], withNickname: "\(name)")
                SocketIOManager.sharedInstance.connectToServerWithNickname(nicname: "\(name)") { arrayId in
                              guard let array = arrayId else { return }
                              self.bindingUserMap(ids: array)
                         }
                self.nickname = name
                scrollToBottom()
                textView.text = ""
                textView.resignFirstResponder()
                self.chatView.tableView.reloadData()
             }
         }
    }
    func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { () -> Void in
            if self.chatMessages.count > 0 {
                let lastRowIndexPath = NSIndexPath(row: self.chatMessages.count - 1, section: 0)
                self.chatView.tableView.scrollToRow(at: lastRowIndexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }
    }
    //MARK: - Selectors
    @objc private func refreshAlbumList() {
        binding()
    }
    @objc  func buttonJoin() {
        delegate?.changeBackgroundColor()
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
    func bindingUserMap(ids: [Int])  {
        takeUser = fitMeetApi.getUserIdMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if !response.data.isEmpty  {
                    let dict = response.data
                    self.usersd = dict
                    self.chatView.tableView.reloadData()
   
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
                            if  let id = i.user?.userId {
                                messageDictionary["id"] = "\(id)"
                            }
                       
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
        chatView.tableView.separatorStyle  =  .none
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
        var size:CGFloat = 5
        if keyboardFrame.size.height == 303 {
            size = 48
        }
        UIView.animate(withDuration: 0.1, animations: { () -> Void in  
            self.textView.easy.layout(Bottom(keyboardFrame.size.height + size))
            self.view.layoutIfNeeded()

        })
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.textView.easy.layout(Bottom(20))
            self.view.layoutIfNeeded()
            })
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)

        }
    }

extension ChatVCPlayer: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == textView {
                self.textView.resignFirstResponder()
            }
            return true
        }
   
    
}
extension ChatVCPlayer: UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentChatMessage = chatMessages[indexPath.row]
        
        guard let senderNickname = currentChatMessage["username"],
              let message = currentChatMessage["message"],
              let messageDate = currentChatMessage["timestamp"],
              let nic = nickname,
              let id = currentChatMessage["id"] as? Int
        else { return UITableViewCell()}
        
        if senderNickname as! String == nic {
          if let cell = tableView.dequeueReusableCell(withIdentifier: "receiverCellId", for: indexPath) as? ChatCell {
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.topLabel.text = senderNickname as? String
                cell.timeLabel.text = (messageDate as? String)!.getFormattedDate(format: "HH:mm")
                cell.textView.text = message as? String
                cell.bottomLabel.text = ""
                guard let avatar = self.usersd[id]?.avatarPath else { return cell }
                cell.setImageLogo(image: avatar)
            
                return cell
            }
} else {
       
    if let cell = tableView.dequeueReusableCell(withIdentifier: "receiverCellId", for: indexPath) as? ChatCell
       {
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                cell.topLabel.text = senderNickname as? String
                cell.timeLabel.text = (messageDate as? String)!.getFormattedDate(format: "HH:mm")
                cell.textView.text = message as? String
                cell.bottomLabel.text = ""
                guard let avatar = self.usersd[id]?.avatarPath else { return cell }
                cell.setImageLogo(image: avatar)
                return cell
            }
        }
        return UITableViewCell()
    
    }
    
    // MARK: UITextViewDelegate Methods
    func textViewDidChange(textView: UITextView) {
           if textView.contentSize.height >= maxHeight {
                       isOversized = true
                }
            }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if token != nil {
            SocketIOManager.sharedInstance.sendStartTypingMessage(nickname: nickname ?? "")
        }
        return true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

