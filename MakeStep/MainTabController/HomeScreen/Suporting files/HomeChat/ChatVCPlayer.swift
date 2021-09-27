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
        if token != nil {
            SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
                DispatchQueue.main.async { () -> Void in
                    self.chatMessages.append(messageInfo)
                    self.chatView.tableView.reloadData()
                    self.chatView.tableView.scrollToBottom()
                }
            }
        } else {
            
        }
       
    }
    
    private lazy var textView = UITextView(frame: CGRect.zero)
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
        chatView.tableView.delegate = self
        registerForKeyboardNotifications()
        if isLand {
            chatView.cardView.backgroundColor = .white
        } else {
            chatView.cardView.backgroundColor = .clear
            chatView.cardView.layer.cornerRadius = 8
            chatView.cardView.layer.borderWidth = 0.8
            chatView.cardView.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        }

        NotificationCenter.default.addObserver(self,selector: Selector(("handleConnectedUserUpdateNotification")), name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: "handleDisconnectedUserUpdateNotification:", name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: "handleUserTypingNotification:", name: NSNotification.Name(rawValue: "userTypingNotification"), object: nil)


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatView.backgroundColor = color
        chatView.sendMessage.tintColor = tint
        textView.backgroundColor = tint
        chatView.cardView.backgroundColor = color
        chatView.tableView.backgroundColor = color
        textView.textColor = .lightGray
        if color == .clear {
            chatView.imageComm.image  = UIImage(named: "arrow")
            chatView.labelComm.textColor = .white
        }
        self.chatView.tableView.reloadData()

        guard let broad = broadcast else { return }
        guard let id = broad.channelIds?.first,let broadID = broad.id,let name = UserDefaults.standard.string(forKey: Constants.userFullName) else { return }
        self.nickname = name
        
        
        
        if token != nil {
    
            bindingMessage(broad: broadID)
            SocketIOManager.sharedInstance.getTokenChat()
            SocketIOManager.sharedInstance.establishConnection(broadcastId: "\(broadID)", chanelId: "\(id)")
                    makeTableView()
            
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
        guard let nic = nickname else { return }

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
        chatView.buttonComm.addTarget(self, action: #selector(buttonJoin), for: .touchUpInside)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
       if UIDevice.current.orientation.isLandscape {
            dismiss(animated: true)
           } else {
            dismiss(animated: true)
            }
    }
    @objc func sendMessage() {
        if token != nil {
            chatView.tableView.isHidden = false
            let name = UserDefaults.standard.string(forKey: Constants.userFullName)
            if textView.text.count > 0 {
                SocketIOManager.sharedInstance.getChatMessage { (old) in
                                        print("OLD ==== \(old)") }
                SocketIOManager.sharedInstance.sendMessage(message: ["text" : textView.text!], withNickname: "\(name)")
                self.nickname = name
                self.chatView.tableView.reloadData()
                textView.text = ""
                textView.resignFirstResponder()
            
        }
        
        } else {
            chatView.tableView.isHidden = true
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
            print("KEY ====\( self.textView.frame.origin.y)")
            print("VIEW ======= \(self.view.frame)")
            print("Keyword ====== \(keyboardFrame.size.height)")
            self.textView.easy.layout(Bottom(keyboardFrame.size.height + size))

            self.view.layoutIfNeeded()
//            }
        })
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
       // write source code handle when keyboard will be hidden
        let info = notification.userInfo!
      //  let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.textView.easy.layout(Bottom(20))
           // self.textView.frame.origin.y = 587.0//keyboardFrame.size.height
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

}

