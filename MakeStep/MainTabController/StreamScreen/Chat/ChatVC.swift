//
//  ChatVC.swift
//  MakeStep
//
//  Created by novotorica on 08.07.2021.
//

import Combine
import UIKit

//MARK: step 1 Add Protocol here.
protocol ClassBVCDelegate: class {
    
    func changeBackgroundColor()
    func changeUp(key: CGFloat)
    func changeDown(key: CGFloat)
}



class ChatVC: UIViewController, UITabBarControllerDelegate, UITableViewDelegate, UIGestureRecognizerDelegate {
      
    let chatView = ChatVCCode()
    var nickname: String?
    var chatMessages = [[String: String]]()
    var bannerLabelTimer: Timer!
    
    var color: UIColor?
    var tint: UIColor?
    
    //MARK: step 2 Create a delegate property here.
    weak var delegate: ClassBVCDelegate?

    
    
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    var listBroadcast: [BroadcastResponce] = []
    private let refreshControl = UIRefreshControl()
   
    //MARK - LifeCicle
    override func loadView() {
        view = chatView
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
        chatView.backgroundColor =  .clear
       // makeTableView()
        makeNavItem()
        actionButton()
        chatView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        chatView.buttonChat.addTarget(self, action: #selector(buttonJoin), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
        registerForKeyboardNotifications()
        
        NotificationCenter.default.addObserver(self, selector: "handleConnectedUserUpdateNotification:", name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: "handleDisconnectedUserUpdateNotification:", name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: "handleUserTypingNotification:", name: NSNotification.Name(rawValue: "userTypingNotification"), object: nil)


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatView.backgroundColor = color
      //  chatView.sendMessage.tintColor = tint
      //  chatView.textView.backgroundColor = tint

        
            SocketIOManager.sharedInstance.getTokenChat()
            SocketIOManager.sharedInstance.establishConnection()
            makeNavItem()
            makeTableView()
      
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
        
    }
    
    @objc func sendMessage() {
        
        let name = UserDefaults.standard.string(forKey: Constants.userFullName)
        //let userName = UserDefaults.standard.string(forKey: Constants)
        
        if chatView.textView.text.count > 0 {
            SocketIOManager.sharedInstance.sendMessage( message: ["text" : chatView.textView.text!], withNickname: "\(name)")
            self.nickname = name
           // self.chatMessages.append(["nickname":"\(name!)","message": chatView.textView.text,"date":"5 sec"])
            self.chatView.tableView.reloadData()
            chatView.textView.text = ""
            chatView.textView.resignFirstResponder()
            SocketIOManager.sharedInstance.getChatMessage { (old) in
               
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
    
  
    
    private func makeTableView() {
        chatView.tableView.dataSource = self
        chatView.tableView.delegate = self
        chatView.tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.reuseID)
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
            if self.chatView.cardView.frame.origin.y == 0{
            self.chatView.cardView.frame.origin.y -= keyboardFrame.size.height
            self.view.layoutIfNeeded()
            }
            })
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
       // write source code handle when keyboard will be hidden
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.chatView.cardView.frame.origin.y += keyboardFrame.height
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
            
            SocketIOManager.sharedInstance.sendStopTypingMessage(nickname: nickname ?? "")
        }
    }
    func handleConnectedUserUpdateNotification(notification: NSNotification) {
        let connectedUserInfo = notification.object as! [String: AnyObject]
        let connectedUserNickname = connectedUserInfo["nickname"] as? String
       // lblNewsBanner.text = "User \(connectedUserNickname!.uppercased()) was just connected."
       // showBannerLabelAnimated()
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
extension ChatVC: UITableViewDataSource {
    

    func numberOfSections(in tableView: UITableView) -> Int {
            return self.chatMessages.count
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return chatMessages.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        let currentChatMessage = chatMessages[indexPath.section]
        
        
        
        let senderNickname = currentChatMessage["username"] as? String
        let message = currentChatMessage["message"] as? String
        let messageDate = currentChatMessage["timestamp"] as? String
        
        
        
        print("senderNickname=====\(senderNickname)\n   nikname=====\(nickname)")
        if senderNickname == nickname {
      
            cell.labelChatMessage.textAlignment = NSTextAlignment.right
            cell.labelMessageDetail.textAlignment = NSTextAlignment.right
            cell.backgroundColor = UIColor(hexString: "#3B58A4")
            cell.labelChatMessage.textColor = .blue
        } else {
            cell.cardView.fillSuperviewforCellRight()
            viewWillLayoutSubviews()
            cell.labelChatMessage.textAlignment = NSTextAlignment.left
            cell.labelMessageDetail.textAlignment = NSTextAlignment.left
           // cell.backgroundColor = .lightGray
            cell.labelChatMessage.textColor = .black
            
        }
        
        cell.labelChatMessage.text = message
        cell.labelMessageDetail.text = "by \(senderNickname?.uppercased()) @ \(messageDate?.getFormattedDate(format: "HH:mm:ss"))"
        cell.labelChatMessage.textColor = .white
        
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor(hexString: "DADADA").cgColor
        cell.layer.borderWidth = 1
        cell.clipsToBounds = true

        
        return cell
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
            return 88
        }

        // Set the spacing between sections
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 10
        }

}

