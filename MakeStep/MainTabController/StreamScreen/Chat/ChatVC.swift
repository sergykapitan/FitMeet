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
    var chatMessages = [[String: String]]()
    var bannerLabelTimer: Timer!
    var messHistory: [Datums]?
    var isLand:Bool = false
    
   // var color: UIColor?
  //  var tint: UIColor?
    
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
    
    var listBroadcast: [BroadcastResponce] = []
    private let refreshControl = UIRefreshControl()
   
    //MARK - LifeCicle
    override func loadView() {
        view = chatView
        
        self.textView.delegate = self
               
        self.textView.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
        
        //UIColor.gray.withAlphaComponent(0.5).cgColor
        self.textView.layer.borderWidth = 1.5
        self.textView.layer.cornerRadius = 20
        self.textView.clipsToBounds = true
        self.textView.font =  UIFont.systemFont(ofSize: 18)
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
               // self.scrollToBottom()
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatView.backgroundColor =  .white
        makeNavItem()
        actionButton()
        chatView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        chatView.buttonChat.addTarget(self, action: #selector(buttonJoin), for: .touchUpInside)
        // Do any additional setup after loading the view.
        if isLand {
            chatView.cardView.backgroundColor = .white
        } else {
           // chatView.cardView.backgroundColor = .clear
            chatView.cardView.layer.cornerRadius = 8
            chatView.cardView.layer.borderWidth = 0.8
            chatView.cardView.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        }
        registerForKeyboardNotifications()
        
        NotificationCenter.default.addObserver(self, selector: "handleConnectedUserUpdateNotification:", name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: "handleDisconnectedUserUpdateNotification:", name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: "handleUserTypingNotification:", name: NSNotification.Name(rawValue: "userTypingNotification"), object: nil)


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // chatView.backgroundColor = color

        guard let broadId = broadcastId,let channelId = chanellId else { return }
            SocketIOManager.sharedInstance.getTokenChat()
            SocketIOManager.sharedInstance.establishConnection(broadcastId: broadId, chanelId: "\(chanellId)")
            makeNavItem()
            makeTableView()
        
        guard let broadID = broadcastId,let name = UserDefaults.standard.string(forKey: Constants.userFullName) else { return }
        self.nickname = name
        guard let intBroad = Int(broadId) else { return }
        bindingMessage(broad: intBroad)
      
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.changeBackgroundColor()
       // AppUtility.lockOrientation(.all, andRotateTo: .portrait)

        print("viewDidDisappear = \(nickname)")
        guard let nic = nickname else { return }
        print("viewDidDisappearGuard = \(nic)")
       // SocketIOManager.sharedInstance.sendStopTypingMessage(nickname: nic)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DISSSSAAAA")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("DEINIT")
    }

    func actionButton() {
        chatView.sendMessage.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
    }
    
    @objc func sendMessage() {
        
        let name = UserDefaults.standard.string(forKey: Constants.userFullName)
      
        print("CHATCOUNR = == == =  ==\( chatView.textView.text.count)")
        if textView.text.count > 0 {
            SocketIOManager.sharedInstance.sendMessage( message: ["text" : textView.text!], withNickname: "\(name)")
            self.nickname = name
           // self.chatMessages.append(["nickname":"\(name!)","message": chatView.textView.text,"date":"5 sec"])
            self.chatView.tableView.reloadData()
            textView.text = ""
            textView.resignFirstResponder()
            SocketIOManager.sharedInstance.getChatMessage { (old) in
               print( "OLD ====== \(old)")
            }
            self.chatView.tableView.reloadData()
        }
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
       
      // write source code handle when keyboard will show
        let info = notificiation.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.textView.easy.layout(Bottom(keyboardFrame.size.height + 10))
            self.view.layoutIfNeeded()

        })
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
       // write source code handle when keyboard will be hidden
         let info = notification.userInfo!
         UIView.animate(withDuration: 0.1, animations: { () -> Void in
             self.textView.easy.layout(Bottom(20))
            // self.textView.frame.origin.y = 587.0//keyboardFrame.size.height
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
    

    func numberOfSections(in tableView: UITableView) -> Int {
            return self.chatMessages.count
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
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
       // SocketIOManager.sharedInstance.sendStartTypingMessage(nickname: nickname ?? "")
        
        return true
    }

    
    // MARK: UIGestureRecognizerDelegate Methods
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
               let headerView = UIView()
              // headerView.backgroundColor = .clear
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

