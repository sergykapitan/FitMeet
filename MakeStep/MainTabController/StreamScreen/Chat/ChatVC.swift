//
//  ChatVC.swift
//  MakeStep
//
//  Created by novotorica on 08.07.2021.
//

import Combine
import UIKit
import EasyPeasy


protocol ClassBVCDelegate: class {
    
    func changeBackgroundColor()
    func changeUp(key: CGFloat)
    func changeDown(key: CGFloat)
}
class CellIds {
    static let senderCellId = "senderCellId"
    static let receiverCellId = "receiverCellId"
}


class ChatVC: UIViewController, UITabBarControllerDelegate, UITableViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate {
      
    let chatView = ChatVCCode()
    var nickname: String?
    var chatMessages = [[String: Any]]()
    var bannerLabelTimer: Timer!
    var messHistory: [Datums]?
    var isLand:Bool = false
    var user: User?
    var usersd = [Int: User]()

    private lazy var textView = UITextView(frame: CGRect.zero)
    private var isOversized = false {
            didSet {
                self.textView.easy.reload()
                self.textView.isScrollEnabled = isOversized
            }
        }
        
        private let maxHeight: CGFloat = 100
    
    //MARK: step 2 Create a delegate property here.
    weak var delegate: ClassBVCDelegate?

    var broadcastId: String?
    var chanellId: String?
    
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    @Inject var fitMeetChat: MakeStepChat
    private var takeMessage: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeUser: AnyCancellable?
    
    var listBroadcast: [BroadcastResponce] = []
    private let refreshControl = UIRefreshControl()
   
    //MARK - LifeCicle
    override func loadView() {
        view = chatView
        self.textView.delegate = self
        self.textView.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
        self.textView.layer.borderWidth = 1.5
        self.textView.layer.cornerRadius = 20
        //self.textView.clipsToBounds = true
        self.textView.font =  UIFont.systemFont(ofSize: 18)
        
//        self.textView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        self.textView.layer.shadowOpacity = 0.8
//        self.textView.layer.shadowRadius = 20
//        self.textView.layer.shadowColor = CGColor.init(srgbRed: 1, green: 0, blue: 0, alpha: 1)
        
//        self.textView.layer.masksToBounds = false
//        self.textView.layer.shadowRadius = 3.0
//        self.textView.layer.shadowColor = UIColor.black.cgColor
//        self.textView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        self.textView.layer.shadowOpacity = 1.0

        
        self.view.addSubview(self.textView)
        self.textView.clipsToBounds = true
        self.textView.isScrollEnabled = false
    
        
        
        self.textView.easy.layout(Left(5),Right(0).to(chatView.sendMessage),Height(maxHeight).when({[unowned self] in self.isOversized}))
        self.textView.anchor(bottom:self.chatView.cardView.bottomAnchor,paddingBottom: 30)
        textView.textContainerInset = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 5)
        self.textView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()

        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
            DispatchQueue.main.async { () -> Void in
                self.chatMessages.append(messageInfo)
                self.chatView.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatView.backgroundColor =  .white
        actionButton()
        chatView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        chatView.buttonChat.addTarget(self, action: #selector(buttonJoin), for: .touchUpInside)
        if isLand {
            chatView.cardView.backgroundColor = .white
        } else {
            chatView.cardView.layer.cornerRadius = 8
            chatView.cardView.layer.borderWidth = 0.8
            chatView.cardView.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        }
        registerForKeyboardNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleConnectedUserUpdateNotification(notification:)), name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDisconnectedUserUpdateNotification(notification:)), name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserTypingNotification(notification:)), name: NSNotification.Name(rawValue: "userTypingNotification"), object: nil)


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let broadId = broadcastId,let channelId = chanellId else { return }
            SocketIOManager.sharedInstance.getTokenChat()
            SocketIOManager.sharedInstance.establishConnection(broadcastId: broadId, chanelId: "\(channelId)")
            makeTableView()
        
        guard let broadID = broadcastId,let name = UserDefaults.standard.string(forKey: Constants.userFullName) else { return }
        SocketIOManager.sharedInstance.connectToServerWithNickname(nicname: "\(name)") { arrayId in
                      guard let array = arrayId else { return }
                      self.bindingUserMap(ids: array)
                 }
        self.nickname = name
        guard let intBroad = Int(broadId) else { return }
        bindingMessage(broad: intBroad)
      
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.changeBackgroundColor()
    }
 
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func actionButton() {
        chatView.sendMessage.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        SocketIOManager.sharedInstance.connectToServerWithNickname(nicname: "l") { arrayId in
                      guard let array = arrayId else { return }
                      self.bindingUserMap(ids: array)
        }
    }
    
    @objc func sendMessage() {
        let name = UserDefaults.standard.string(forKey: Constants.userFullName)
        if textView.text.count > 0 {
            SocketIOManager.sharedInstance.sendMessage( message: ["text" : textView.text!], withNickname: "\(name)")
            SocketIOManager.sharedInstance.connectToServerWithNickname(nicname: "\(name)") { arrayId in
                          guard let array = arrayId else { return }
                          self.bindingUserMap(ids: array)
                     }
            self.nickname = name
            self.chatView.tableView.reloadData()
            scrollToBottom()
            textView.text = ""
            textView.resignFirstResponder()
        }
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
        chatView.tableView.separatorStyle = .none
    }
    
    func registerForKeyboardNotifications() {
      NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShown(_:)),name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector:
    #selector(keyboardWillBeHidden(_:)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShown(_ notificiation: NSNotification) {
        let info = notificiation.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.textView.easy.layout(Bottom(keyboardFrame.size.height + 10))
            self.view.layoutIfNeeded()

        })
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        _ = notification.userInfo!
         UIView.animate(withDuration: 0.1, animations: { () -> Void in
             self.textView.easy.layout(Bottom(20))
             self.view.layoutIfNeeded()
        })
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)

        }
    
    func scrollToBottom() {
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
        }
    }
    @objc func handleConnectedUserUpdateNotification(notification: NSNotification) {
        let connectedUserInfo = notification.object as! [String: AnyObject]
        let connectedUserNickname = connectedUserInfo["message"] as? String
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
    
    func showBannerLabelAnimated() {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            
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
            }) { (finished) -> Void in
        }
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
}
extension ChatVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == textView {
                self.textView.resignFirstResponder()
            }
            return true
        }
}
extension ChatVC: UITableViewDataSource {

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
               cell.backgroundColor = .clear
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
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    // MARK: UIGestureRecognizerDelegate Methods
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
               let headerView = UIView()
               return headerView
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

