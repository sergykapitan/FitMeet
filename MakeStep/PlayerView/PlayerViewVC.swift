//
//  PlayerViewVC.swift
//  MakeStep
//
//  Created by Sergey on 18.02.2022.
//

import Combine
import UIKit
import AVKit
import Presentr
import TagListView
import MMPlayerView
import Kingfisher
import TimelineTableViewCell


class PlayerViewVC: UIViewController, ClassUserDelegate, TagListViewDelegate, VeritiPurchase{
    
    func addPurchase() {
        guard let userId = user?.id else { return }
        self.bindingChannel(id: userId)
    }
    
    
    
    
    var offsetObservation: NSKeyValueObservation?
    var myCell: PlayerViewCell?

    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
  
 
    func changeButton() {
       
        homeView.buttonChat.isHidden = false

    }
    
    var frame: CGRect?
    var button = UIButton()
    var indexTab: Int?

    var isPlaying: Bool = false
    var isButton: Bool = true
    
    var isLandscape: Bool = true
    var isLand:Bool = true
    var isPortraiteFull: Bool = false
    var isFullSize = false
    
    var id: Int?
    var follow: String?
    var watch: Int?
    
    let controller =  ChatVCPlayer()

    let homeView = PlayerViewVCCode()
    var playerViewController: AVPlayerViewController?
    @Inject var fitMeetChannel: FitMeetChannels
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    let actionChatTransitionManager = ActionTransishionChatManadger()
   // let actionPresentChat = ActionChatPresentationController()
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeUser: AnyCancellable?
    private var watcherMap: AnyCancellable?
    private var take: AnyCancellable?
    
    @Inject var fitMeetChannels: FitMeetChannels
    private var takeChannels: AnyCancellable?
    
   
    private var takeChanell: AnyCancellable?
    private var followBroad: AnyCancellable?
    
    var channel: ChannelResponce?
   
   
  
    var brodcast: [BroadcastResponce] = []
    var brodcastTime: BroadcastList?
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    var listBroadcast: [BroadcastResponce] = []
    
    var broadcast: BroadcastResponce?
    var  broadId: Int?
    var i : Int?
    
    private let refreshControl = UIRefreshControl()
   // var  playerContainerView: PlayerContainerView?
  
    var urlStream: String?
    var playPauseButton: PlayPauseButton!
    var user: User?
    var usersd = [Int: User]()
    var url: String?
    var heightBar: CGFloat?

    //MARK - LifeCicle
    override func loadView() {
        view = homeView

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.homeView.imageLogoProfile.makeRounded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.homeView.imageLogoProfile.makeRounded()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        homeView.imageLogoProfile.makeRounded()
        guard let id = id  else { return }
        bindingUser(id: id)
        guard let  broadId = broadId else { return }
        getMapWather(ids: [broadId])
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        makeNavItem()
        i = 0
        frame = self.view.frame

        homeView.labelStreamDescription.text = broadcast?.description
        let categorys = broadcast?.categories
//        let s = categorys.map{$0.title}
//        var arr = [""]
//        arr = s.map { String("\u{0023}" + $0)}
//        homeView.labelCategory.removeAllTags()
//        homeView.labelCategory.addTags(arr)
//        homeView.labelCategory.delegate = self
//        homeView.labelNameBroadcast.text = broadcast?.name
        loadPlayer()
        guard let idU = user?.id else { return }
        bindingChannel(id: idU)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.popViewController(animated: true)
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
        SocketWatcher.sharedInstance.closeConnection()
    }
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        navigationItem.largeTitleDisplayMode = .always
        homeView.tableView.isHidden = true
        makeTableView()
        actionButton ()
        self.view.addSubview(self.homeView.viewChat)
        SocketIOManager.sharedInstance.getTokenChat()
     

        _ = UserDefaults.standard.string(forKey: "tokenChat")
        _ = UserDefaults.standard.string(forKey: Constants.broadcastID)
        _ = UserDefaults.standard.string(forKey: Constants.chanellID)
        
        heightBar = tabBarController?.tabBar.frame.height
        homeView.imagePromo.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(actionBut(sender:))))
      
       
     
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)

    }
    deinit {
        offsetObservation?.invalidate()
        offsetObservation = nil
        print("ViewController deinit")
    }
   @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swipe Right")
            case UISwipeGestureRecognizer.Direction.down:
                self.dismiss(animated: true, completion: nil)
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    func deviceOrientationDidChange() {
           //2
           switch UIDevice.current.orientation {
           case .faceDown:
               print("Face down")
           case .faceUp:
               print("Face up")
           case .unknown:
               print("Unknown")
           case .landscapeLeft:
               print("Landscape left")
           case .landscapeRight:
               print("Landscape right")
           case .portrait:
               print("Portrait")
           case .portraitUpsideDown:
               print("Portrait upside down")
           }
       }
    func actionButton () {
        homeView.buttonLandScape.addTarget(self, action: #selector(rightHandAction), for: .touchUpInside)
        homeView.buttonChat.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
        homeView.buttonSubscribe.addTarget(self, action: #selector(actionSubscribe), for: .touchUpInside)
        homeView.buttonFollow.addTarget(self, action: #selector(actionFollow), for: .touchUpInside)
        button.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
        homeView.buttonMore.addTarget(self, action: #selector(actionMore), for: .touchUpInside)
        homeView.buttonLike.addTarget(self, action: #selector(actionLike), for: .touchUpInside)
       
      
        

    }
 
    @objc func actionLike() {
        guard token != nil else { return }
        homeView.buttonLike.isSelected.toggle()
        if homeView.buttonLike.isSelected {
            homeView.buttonLike.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
        } else {
            homeView.buttonLike.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
        }

    }
    @objc func actionMore() {
        guard token != nil else { return }
        let detailViewController = SendVC()
        actionSheetTransitionManager.height = 0.2
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = actionSheetTransitionManager
        detailViewController.url = broadcast?.url//self.url
        present(detailViewController, animated: true)

    }
 
    private func makeTableView() {
      //  homeView.tableView.dataSource = self
      //  homeView.tableView.delegate = self
       // homeView.tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseID)
       // homeView.tableView.register(PlayerViewCell.self, forCellReuseIdentifier: PlayerViewCell.reuseID)
       // homeView.tableView.separatorStyle = .none
        
    }
    
    func binding(id: String) {
        takeBroadcast = fitMeetStream.getBroadcastPrivateTime(status: "PLANNED", userId: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { [self] response in
                if response.data != nil  {
                    self.brodcastTime = response
                    self.homeView.tableView.reloadData()
                  
               }
        })
    }
    func bindingChanell(status: String,userId: String) {
        takeChanell = fitMeetStream.getBroadcastPrivate(status: status, userId: userId)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                self.brodcast.removeAll()
                if response.data != nil  {
                    
                    self.homeView.tableView.reloadData()
                    self.brodcast = response.data!
                    guard let broadcast = self.brodcast.first else {
                       
                       
                        let url = URL(string: self.channel?.backgroundUrl ?? "https://pixy.org/src2/575/5759243.jpg")
                       
                        return }
    
                    self.homeView.labelINTVideo.text = "\(self.brodcast.count)"
                    self.broadcast = broadcast
                    self.homeView.labelStreamDescription.text = self.broadcast?.description
                    let categorys = self.broadcast?.categories
                    let s = categorys!.map{$0.title!}
                    let arr = s.map { String("\u{0023}" + $0)}
                    self.homeView.labelCategory.addTags(arr)
                    self.homeView.labelCategory.delegate = self
                    self.homeView.labelNameBroadcast.text = self.broadcast?.name
                    self.urlStream = self.broadcast?.streams?.first?.hlsPlaylistUrl
                    self.loadPlayer()
                    SocketIOManager.sharedInstance.getTokenChat()
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    let  broadId = self.brodcast.compactMap{$0.id}
                    self.getMapWather(ids: broadId)
                    self.bindingUserMap(ids: arrayUserId)
                    self.homeView.tableView.reloadData()
                } else {
                    print("ADDDDDDDDD")
                }
           })
       }
    func bindingChanellNotAutn(status: String,userId: String) {
        takeChanell = fitMeetStream.getBroadcastNotAuth(status: status, userId: userId)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                self.brodcast.removeAll()
                if response.data != nil  {
                    
                    self.homeView.tableView.reloadData()
                    self.brodcast = response.data!
                    guard let broadcast = self.brodcast.first else {
                       
                        let url = URL(string: self.channel?.backgroundUrl ?? "https://pixy.org/src2/575/5759243.jpg")
                       
                        return }
                    self.homeView.labelINTVideo.text = "\(self.brodcast.count)"
                    self.broadcast = broadcast
                    self.homeView.labelStreamDescription.text = self.broadcast?.description
                    let categorys = self.broadcast?.categories
                    let s = categorys!.map{$0.title!}
                    let arr = s.map { String("\u{0023}" + $0)}
                    self.homeView.labelCategory.addTags(arr)
                    self.homeView.labelCategory.delegate = self
                    self.homeView.labelNameBroadcast.text = self.broadcast?.name
                    self.urlStream = self.broadcast?.streams?.first?.hlsPlaylistUrl
                    self.loadPlayer()
                    SocketIOManager.sharedInstance.getTokenChat()
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    let  broadId = self.brodcast.compactMap{$0.id}
                    self.getMapWather(ids: broadId)
                    self.bindingUserMap(ids: arrayUserId)
                    self.homeView.tableView.reloadData()
                }
           })
       }
    func bindingChanellVOD(userId: String) {
        takeChanell = fitMeetStream.getBroadcastPrivateVOD(userId: "\(userId)")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.brodcast.removeAll()
                  response.data!.forEach{
                        self.brodcast.append($0)
                    }
                  
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.brodcast = self.brodcast.reversed()
                    self.homeView.tableView.reloadData()
                }
           })
       }
    func bindingChanellMulti(userId: String) {
        takeChanell = fitMeetStream.getBroadcastPrivateMulty( userId: "\(userId)")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.brodcast.removeAll()
                    self.brodcast = response.data!
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.homeView.tableView.reloadData()
                }
           })
       }
    func bindingUserMap(ids: [Int])  {
        take = fitMeetApi.getUserIdMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.usersd = response.data
                    self.homeView.tableView.reloadData()
                }
          })
    }
    @objc func actionSubscribe() {
        guard let channel = channel,let _ = token else { return }
        guard let subscribe = channel.isSubscribe else { return }
        if subscribe {
           
        } else {
          guard let subPlans = channel.subscriptionPlans else { return }
            if subPlans.isEmpty {
                
            } else {
                
                let subscribe = SubscribeVC()
                       subscribe.modalPresentationStyle = .custom
                       subscribe.id = user?.id
                       subscribe.delagatePurchase = self
                if view.bounds.height <= 603 {
                    actionChatTransitionManager.intHeight = 0.5
                } else {
                    actionChatTransitionManager.intHeight = 0.4
                }
                    //   actionChatTransitionManager.intHeight = 0.4
                       actionChatTransitionManager.intWidth = 1
                       subscribe.transitioningDelegate = actionChatTransitionManager
                       present(subscribe, animated: true)
            }
       
        }
    }
    @objc func actionFollow() {
        guard let _ = token else { return }
        homeView.buttonFollow.isSelected.toggle()
        
        if homeView.buttonFollow.isSelected {
            homeView.buttonFollow.backgroundColor = UIColor(hexString: "#3B58A4")
            homeView.buttonFollow.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)

        } else {
            homeView.buttonFollow.backgroundColor = UIColor(hexString: "FFFFFF")
            homeView.buttonFollow.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
        }

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
    let buttonOffline = ButtonOffline()
    let buttonComming = ButtonCommingg()
    let vv = EditProfile()

   
    @objc func actionBut(sender:UITapGestureRecognizer) {
        
        
        if isButton {
            homeView.overlay.isHidden = true
            homeView.imageLive.isHidden = true
            homeView.labelLive.isHidden = true
            homeView.imageEye.isHidden = true
            homeView.labelEye.isHidden = true
            homeView.buttonLandScape.isHidden = true
            
            homeView.buttonChat.isHidden = true
           
            button.isHidden = true
            if playPauseButton == nil {
                
            } else {
                playPauseButton.isHidden = true
            }
           
            
            isButton = false
        } else {
   
           
            
            homeView.overlay.isHidden = false
            homeView.imageLive.isHidden = false
            homeView.labelLive.isHidden = false
            homeView.imageEye.isHidden = false
            homeView.labelEye.isHidden = false
            homeView.buttonLandScape.isHidden = false
            if playPauseButton == nil {
                
            } else {
                playPauseButton.isHidden = false
            }
           
            isButton = true
        }

    }
    
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = ""
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        
                    let backButto = UIButton()
                    backButto.setTitle("Back", for: .normal)
                    backButto.addTarget(self, action: #selector(rightBack), for: .touchUpInside)
                    
                    let backButton = UIButton()
                   // backButton.setImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                    backButton.setBackgroundImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)
                    backButton.anchor(width:40,height: 40)

                   let stackView = UIStackView(arrangedSubviews: [backButton,backButto,titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .horizontal

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Note"), style: .plain, target: self, action:  #selector(notificationHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(timeHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
      //  self.navigationItem.rightBarButtonItems = [startItem,timeTable]
    }
    
    @objc func timeHandAction() {
        print("timeHandAction")
        let tvc = Timetable()
        navigationController?.present(tvc, animated: true, completion: nil)
                
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
    
    
    func setUserProfile(user: User) {
        homeView.setImage(image: user.avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
        guard let follow = user.channelFollowCount else { return }
        self.homeView.labelINTFollows.text = "\(user.channelFollowCount!)"
        self.homeView.labelINTFolowers.text = "\(user.channelSubscribeCount!)"
        guard let id = user.id else { return }
        if token != nil {
            bindingChannel(id: id)
        } else {
            bindingNotChannel(id: id)
        }
       
    }
    
    func bindingChannel(id: Int) {
        take = fitMeetChannel.listChannelsPrivate(idUser: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data.first?.name != nil  {
                    self.channel = response.data.last
                    guard let channel = self.channel,let description = channel.description else { return }
                    self.homeView.labelDescription.text = " Welcome to my channel!\n \(description)"
                   
                    self.homeView.labelINTFollows.text = "\(channel.followersCount!)"
                    self.homeView.labelINTFolowers.text = "\(channel.subscribersCount!)"
                    
                    if channel.isSubscribe! {
                        
                        self.homeView.buttonSubscribe.setTitle("Subscribers", for: .normal)
                        self.homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
                        self.homeView.buttonSubscribe.backgroundColor = .white
                    } else {
                        self.homeView.buttonSubscribe.backgroundColor = UIColor(hexString: "#3B58A4")
                        self.homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
                        self.homeView.buttonSubscribe.setTitle("Subscribe", for: .normal)
                    }
                }
           })
    }
    func bindingNotChannel(id: Int) {
        take = fitMeetChannel.listChannelsNotAuth(idUser: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data.first?.name != nil  {
                    self.channel = response.data.last
                    guard let channel = self.channel,let description = channel.description else { return }
                    self.homeView.labelDescription.text = " Welcome to my channel!\n \(description)"
                   
                    self.homeView.labelINTFollows.text = "\(channel.followersCount!)"
                    self.homeView.labelINTFolowers.text = "\(channel.subscribersCount!)"
                    self.homeView.buttonSubscribe.backgroundColor = UIColor(hexString: "#3B58A4")
                    self.homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
                    self.homeView.buttonSubscribe.setTitle("Subscribe", for: .normal)
                }
           })
    }
    // MARK: - LoadPlayer
    func loadPlayer() {
        guard let url = urlStream else { return }
        print(url)
                let videoURL = URL(string: url)
                let player = AVPlayer(url: videoURL!)
                self.playerViewController = AVPlayerViewController()
             
        let playerFrame = self.homeView.imagePromo.bounds
        playerViewController!.player = player
        player.rate = 1
        playerViewController!.view.frame = playerFrame
        playerViewController!.showsPlaybackControls = false
        playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                  
                
        addChild(playerViewController!)
        homeView.imagePromo.addSubview(playerViewController!.view)

        playerViewController!.didMove(toParent: self)

              playPauseButton = PlayPauseButton()
              playPauseButton.avPlayer = player
        
        
              homeView.imagePromo.addSubview(playPauseButton)
 
        
       
        
//        homeView.overlay.anchor(
//                       left: homeView.imagePromo.leftAnchor,
//                       paddingLeft: 16,  width: 90, height: 24)
//
//        homeView.imagePromo.addSubview(homeView.imageLive)
//        homeView.imageLive.anchor( left: homeView.overlay.leftAnchor, paddingLeft: 6, width: 12, height: 12)
//        homeView.imageLive.centerY(inView: homeView.overlay)
//
//        homeView.imagePromo.addSubview(homeView.labelLive)
//        homeView.labelLive.anchor( left: homeView.imageLive.rightAnchor, paddingLeft: 6)
//        homeView.labelLive.centerY(inView: homeView.overlay)
//
//        homeView.imagePromo.addSubview(homeView.imageEye)
//        homeView.imageEye.anchor( left: homeView.labelLive.rightAnchor, paddingLeft: 6, width: 12, height: 12)
//        homeView.imageEye.centerY(inView: homeView.overlay)
//
//        homeView.imagePromo.addSubview(homeView.labelEye)
//        homeView.labelEye.anchor( left: homeView.imageEye.rightAnchor, paddingLeft: 6)
//        homeView.labelEye.centerY(inView: homeView.overlay)
  
//
//               let tim : Float64 = CMTimeGetSeconds((player.currentItem?.asset.duration)!)
//               print("TIM=====\(tim)")
               playPauseButton.setup(in: self)

    }

    //MARK: - Transishion
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
        if  indexTab == 1 { return }
        guard let url = urlStream else { return }
        playPauseButton.updateUI()
        deviceOrientationDidChange()
       
        if UIDevice.current.orientation.isFlat {
            print("isFlat")
        }
        if UIDevice.current.orientation.isValidInterfaceOrientation{
            print("isValidInterfaceOrientation")
        }
           if UIDevice.current.orientation.isLandscape {
              
            print("Landscape")
          //  AppUtility.lockOrientation(.allButUpsideDown)
            AppUtility.lockOrientation(.portrait)
            isFullSize = true
            isLand = true
            button.isHidden = false
            self.view.addSubview(button)
            self.homeView.buttonSubscribe.isHidden = true
            self.homeView.buttonFollow.isHidden = true
            self.homeView.labelINTVideo.isHidden = true
            self.homeView.labelVideo.isHidden = true
            self.homeView.labelINTFollows.isHidden = true
            self.homeView.labelFollows.isHidden = true
            self.homeView.labelINTFolowers.isHidden = true
            self.homeView.labelFolowers.isHidden = true
            self.homeView.labelDescription.isHidden = true
            self.homeView.buttonChat.isHidden = true
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.isHidden = true
            homeView.imageLogoProfile.isHidden = true
            
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                    self.playerViewController?.view.fillFull(for: self.view)
                    self.homeView.buttonLandScape.anchor( bottom: self.homeView.imagePromo.bottomAnchor,  paddingBottom: 20,width: 45,height: 45)
                
                self.view.layoutIfNeeded()
            
            })
            transitionAnimator.startAnimation()
            
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
 
                },completion: nil)
  
            isPlaying = true
            isLandscape = true
            self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
           } else {
            isLand = false
            button.isHidden = true
            self.homeView.buttonChat.isHidden = false
            isLandscape = false
   

            if self.isFullSize {
                
                AppUtility.lockOrientation(.landscapeLeft)
                    let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                   
                 
                   

                        
                        if self.view.frame.origin.y == 0.0 {
                            print("FRAME ==== \(self.view.frame.origin.y)")
                        }else {
                            print("FRAME ==== \(self.view.frame.origin.y)")
                        }

                    self.view.layoutIfNeeded()
                    })
                transitionAnimator.startAnimation()
    } else {
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
             
                self.view.layoutIfNeeded()
                })
            transitionAnimator.startAnimation()
            }
            
            self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill

           }
       }
    // MARK: - ButtonLandscape
    @objc func rightHandAction() {
        
           
       
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
               
                   
            
                self.view.layoutIfNeeded()
            
            })
            transitionAnimator.startAnimation()
            self.view.layoutIfNeeded()
        

        self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        if isPlaying {
            isFullSize = false
            isPlaying = false
            isPortraiteFull = false
            guard let frame = frame else { return }
     
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
              
                print("FRAME ==== \(frame)")
                self.view.frame = frame
               
                self.view.layoutIfNeeded()
            
            })
            transitionAnimator.startAnimation()
            self.view.layoutIfNeeded()
           
            navigationController?.navigationBar.isHidden = false
            tabBarController?.tabBar.isHidden = false
            self.homeView.imageLogoProfile.isHidden = false
            self.homeView.buttonSubscribe.isHidden = false
            self.homeView.buttonSubscribe.isHidden = false
            self.homeView.buttonFollow.isHidden = false
            self.homeView.labelINTVideo.isHidden = false
            self.homeView.labelVideo.isHidden = false
            self.homeView.labelINTFollows.isHidden = false
            self.homeView.labelFollows.isHidden = false
            self.homeView.labelINTFolowers.isHidden = false
            self.homeView.labelFolowers.isHidden = false
            self.homeView.labelDescription.isHidden = false
           
            
            self.homeView.buttonChat.isHidden = false
            
            self.homeView.imagePromo.isHidden = false

            self.homeView.imagePromo.removeFromSuperview()
            self.homeView.labelCategory.removeFromSuperview()
            self.homeView.labelNameBroadcast.removeFromSuperview()
            self.homeView.labelStreamInfo.removeFromSuperview()
            self.homeView.labelStreamDescription.removeFromSuperview()
            self.homeView.buttonChat.removeFromSuperview()
            self.homeView.buttonLandScape.removeFromSuperview()
            
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                   
                    self.homeView.cardView.addSubview(self.homeView.imagePromo)
                    self.homeView.imagePromo.anchor(top: self.homeView.cardView.topAnchor,
                                                    left: self.homeView.cardView.leftAnchor,
                                                    right: self.homeView.cardView.rightAnchor,
                                      paddingTop: 15, paddingLeft: 0, paddingRight: 0,height: 208 )
                 

                    self.view.addSubview(self.homeView.buttonLandScape)
                   
                    self.homeView.buttonLandScape.anchor(bottom: self.homeView.imagePromo.bottomAnchor, paddingBottom: 20,width: 40,height: 40)
                    
                    self.homeView.cardView.addSubview(self.homeView.labelNameBroadcast)
                    self.homeView.labelNameBroadcast.anchor(top: self.homeView.imagePromo.bottomAnchor,
                                         left: self.homeView.cardView.leftAnchor, paddingTop: 11, paddingLeft: 16)

                    self.homeView.cardView.addSubview(self.homeView.labelCategory)
                    self.homeView.labelCategory.anchor(top: self.homeView.labelNameBroadcast.bottomAnchor,
                                         left: self.homeView.cardView.leftAnchor, paddingTop: 5, paddingLeft: 16)

                    self.homeView.cardView.addSubview(self.homeView.labelStreamInfo)
                    self.homeView.labelStreamInfo.anchor(top: self.homeView.labelCategory.bottomAnchor,
                                                         left: self.homeView.cardView.leftAnchor,
                                           paddingTop: 9, paddingLeft: 16)

                    self.homeView.cardView.addSubview(self.homeView.labelStreamDescription)
                    self.homeView.labelStreamDescription.anchor(top: self.homeView.labelStreamInfo.bottomAnchor,
                                                                left: self.homeView.cardView.leftAnchor,
                                                                right: self.homeView.cardView.rightAnchor,
                                                  paddingTop: 4, paddingLeft: 16, paddingRight: 16)

                    self.homeView.cardView.addSubview(self.homeView.buttonMore)
                    self.homeView.buttonMore.anchor(top: self.homeView.imagePromo.bottomAnchor,right: self.homeView.cardView.rightAnchor, paddingTop: 11, paddingRight: 20, width: 30, height: 30)

                    self.homeView.cardView.addSubview(self.homeView.buttonLike)
                    self.homeView.buttonLike.anchor(top: self.homeView.imagePromo.bottomAnchor,right: self.homeView.buttonMore.leftAnchor, paddingTop: 11, paddingRight: 10, width: 30, height: 30)
                    //,bottom: self.view.bottomAnchor//,paddingBottom: 80
                    self.homeView.cardView.addSubview(self.homeView.buttonChat)
                    self.homeView.buttonChat.anchor(left:self.view.leftAnchor, paddingLeft: 15,width: 80, height: 30)
                   
               
                  
  
                    AppUtility.lockOrientation(.all, andRotateTo: .portrait)
                    self.isPortraiteFull = false
                    self.view.layoutIfNeeded()
                },completion: nil)
        } else {
            
            isFullSize = true
            isPortraiteFull = true
            AppUtility.lockOrientation(.all, andRotateTo: .landscapeLeft)
            print("ALL EXIT")
        }
    }
   
    @objc func leftHandAction() {
    
        print("left bar button action")
    }
    //MARK: - Selectors
    @objc private func refreshAlbumList() {
       }
    @objc func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - UserOnline
    @objc func actionUserOnline () {
        homeView.overlay.isHidden = true
        homeView.imageLive.isHidden = true
        homeView.labelLive.isHidden = true
        homeView.imageEye.isHidden = true
        homeView.labelEye.isHidden = true
        playPauseButton.isHidden = true

        let chatVC = UserVC()
        guard let id = broadcast?.id,let channel = broadcast?.channelIds?.first  else { return }
        chatVC.broadcastId = "\(id)"
        chatVC.chanellId = "\(channel)"
        chatVC.delegate = self
        
        chatVC.transitioningDelegate = actionChatTransitionManager
        chatVC.modalPresentationStyle = .custom
        if isLand {
          //  button.isHidden = true
            homeView.buttonChat.isHidden = true
            chatVC.isLand = true
            actionChatTransitionManager.intWidth = 0.5
            actionChatTransitionManager.intHeight = 1
            present(chatVC, animated: true, completion: nil)
        } else {
            homeView.buttonChat.isHidden = false
            chatVC.isLand = false
            actionChatTransitionManager.intWidth = 1
            actionChatTransitionManager.intHeight = 0.7
            actionChatTransitionManager.isLandscape = isLandscape
            present(chatVC, animated: true)
        }
    }
    
    
    // MARK: - ActionChat
    @objc func actionChat(sender:UITapGestureRecognizer) {

        if isPlaying {
            homeView.overlay.isHidden = true
            homeView.imageLive.isHidden = true
            homeView.labelLive.isHidden = true
            homeView.imageEye.isHidden = true
            homeView.labelEye.isHidden = true
            playPauseButton.isHidden = true
            isButton = false
            
            let detailViewController = ChatVCPlayer()
            detailViewController.modalPresentationStyle = .custom
            detailViewController.transitioningDelegate = actionChatTransitionManager
            detailViewController.broadcast = broadcast
            detailViewController.color = .white

            if isLand {
                detailViewController.isLand = true
                actionChatTransitionManager.intWidth = 0.5
                actionChatTransitionManager.intHeight = 1
                actionChatTransitionManager.isLandscape = isLand
                detailViewController.color = .white
                detailViewController.chatView.buttonComm.isHidden = true
                detailViewController.chatView.buttonCloseChat.isHidden = false
                present(detailViewController, animated: true)
            } else {
                detailViewController.isLand = false
                actionChatTransitionManager.intWidth = 1
                actionChatTransitionManager.intHeight = 0.7
                actionChatTransitionManager.isLandscape = isLand
                detailViewController.color = .white
                detailViewController.chatView.buttonComm.isHidden = true
                present(detailViewController, animated: true)
            }
            
        } else {
            AppUtility.lockOrientation(.portrait)
            
            let detailViewController = ChatVCPlayer()
            detailViewController.modalPresentationStyle = .custom
            detailViewController.transitioningDelegate = actionChatTransitionManager
            detailViewController.broadcast = broadcast
           
            detailViewController.color = .white
            actionChatTransitionManager.intWidth = 1
            actionChatTransitionManager.intHeight = 0.7
            present(detailViewController, animated: true)
        }
       
    }
    
 // MARK: - NetworkMetod
    func followChannels(id: Int) {
        takeChannels = fitMeetChannels.followChannels(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.subscribersCount != nil  {
                   print(response)
                }
            })
      }

    func bindingUser(id: Int) {
        takeUser = fitMeetApi.getUserId(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                        self.user = response
                        self.setUserProfile(user: self.user!)
                    guard let id = self.user?.id else { return }
                    self.bindingChanell(status: "ONLINE", userId: "\(id)")
                }
            })
        }
   
    
    func getMapWather(ids: [Int])  {
        watcherMap = fitMeetApi.getWatcherMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    guard let watchers = response.data["\(ids.first!)"] else { return }
                    self.homeView.labelEye.text = "\(watchers)"
                }
            })
       }
    
}
