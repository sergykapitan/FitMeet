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


class PlayerViewVC: UIViewController, TagListViewDelegate, VeritiPurchase{
    
    func addPurchase() {
        guard let userId = user?.id else { return }
       
    }
    

    var offsetObservation: NSKeyValueObservation?
    var myCell: PlayerViewCell?

    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    let selfId = UserDefaults.standard.string(forKey: Constants.userID)
 
   
    
  

    var isPlaying: Bool = false
    var isButton: Bool = true
    
    var isLandscape: Bool = true
    var isLand:Bool = true
    var isPortraiteFull: Bool = false
    var isFullSize = false
    fileprivate var isUpdateTime = false
    
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
    private var takeBroadcastPlanned: AnyCancellable?
    
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        homeView.imageLogoProfile.makeRounded()

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
      
       
        
        let categorys = broadcast?.categories
        let s = categorys!.map{$0.title!}
        let arr = s.map { String("\u{0023}" + $0)}
        homeView.labelCategory.removeAllTags()
        homeView.labelCategory.addTags(arr)
        homeView.labelCategory.delegate = self
        self.urlStream = self.broadcast?.streams?.first?.vodUrl
        self.homeView.labelStreamInfo.text = broadcast?.name
        loadPlayer()
        guard let idU = self.id else { return }
        bindingUser(id: idU)
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
        makeTableView()
        actionButton ()
        SocketIOManager.sharedInstance.getTokenChat()
     

        _ = UserDefaults.standard.string(forKey: "tokenChat")
        _ = UserDefaults.standard.string(forKey: Constants.broadcastID)
        _ = UserDefaults.standard.string(forKey: Constants.chanellID)
        
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
  
    func actionButton () {
        homeView.buttonLandScape.addTarget(self, action: #selector(rightHandAction), for: .touchUpInside)
        homeView.buttonChat.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
        homeView.buttonMore.addTarget(self, action: #selector(actionMore), for: .touchUpInside)
        homeView.buttonLike.addTarget(self, action: #selector(actionLike), for: .touchUpInside)
        homeView.buttonVolum.addTarget(self, action: #selector(actionVolume), for: .touchUpInside)
        homeView.playerSlider.addTarget(self, action: #selector(sliderValueChange), for: .touchUpInside)
    }
    @objc func sliderValueChange() {
        self.isUpdateTime = true
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delaySeekTime), object: nil)
        self.perform(#selector(delaySeekTime), with: nil, afterDelay: 0.1)
    }
    @objc func actionLike() {
        guard token != nil else { return }
        homeView.buttonLike.isSelected.toggle()
        if homeView.buttonLike.isSelected {
            homeView.buttonLike.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
            if let id = self.broadcast?.id {
                followBroadcast(id: id)
            }
            
        } else {
            homeView.buttonLike.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
            if let id = self.broadcast?.id {
                unFollowBroadcast(id: id)
            }
        }

    }
    @objc func actionVolume() {
        guard token != nil else { return }
        homeView.buttonVolum.isSelected.toggle()
        if homeView.buttonVolum.isSelected {
            self.playerViewController?.player?.volume = 0
        } else {
            self.playerViewController?.player?.volume = 1
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
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self
        homeView.tableView.register(PlayerViewCell.self, forCellReuseIdentifier: PlayerViewCell.reuseID)
        homeView.tableView.separatorStyle = .none
        homeView.tableView.showsVerticalScrollIndicator = false
        
    }
    
  
    func bindingChanell(status: String,userId: String,type: String) {
        takeChanell = fitMeetStream.getBroadcastPrivate(status: status, userId: userId,type: type)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    //self.brodcast = response.data!
                    self.brodcast.append(contentsOf: response.data!)
                    SocketIOManager.sharedInstance.getTokenChat()
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    let  broadId = self.brodcast.compactMap{$0.id}
                    self.getMapWather(ids: broadId)
                    self.bindingUserMap(ids: arrayUserId)
                    self.homeView.tableView.reloadData()
                }
           })
       }
    
    func binding(id: String) {
          takeBroadcast = fitMeetStream.getBroadcastPrivateTime(status: "ONLINE", userId: id)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { [self] response in
                  if response.data != nil  {
                      self.brodcast.append(contentsOf: response.data!)
                      self.bindingChanellVOD(userId: "\(id)")
                     // self.homeView.tableView.reloadData()

                 }
          })
      }
    func bindingPlanned(id: String) {
          takeBroadcastPlanned = fitMeetStream.getBroadcastPrivateTime(status: "PLANNED", userId: id)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { [self] response in
                  if response.data != nil  {
                      self.brodcast.append(contentsOf: response.data!)
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
  
   
    func followBroadcast(id: Int) {
        followBroad = fitMeetStream.followBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                guard let like = response.followersCount else { return }
                self.homeView.labelLike.text = "\(like)"
          })
    }
    func unFollowBroadcast(id: Int) {
        followBroad = fitMeetStream.unFollowBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
               // guard let like = response else { return }
              //  self.homeView.labelLike.text = "\(like)"
         })
    }
   

   
    @objc func actionBut(sender:UITapGestureRecognizer) {
        
        
        if isButton {
            homeView.overlay.isHidden = true
            homeView.imageLive.isHidden = true
            homeView.labelLive.isHidden = true
           // homeView.imageEye.isHidden = true
            homeView.labelEye.isHidden = true
            homeView.buttonLandScape.isHidden = true
            homeView.buttonSetting.isHidden = true
            playPauseButton.isHidden = true
            homeView.buttonVolum.isHidden = true
            homeView.playerSlider.isHidden = true
          
            if playPauseButton == nil {
                
            } else {
                playPauseButton.isHidden = true
            }
           
            
            isButton = false
        } else {
   
           
            homeView.buttonSetting.isHidden = false
            homeView.overlay.isHidden = false
            homeView.imageLive.isHidden = false
            homeView.labelLive.isHidden = false
           // homeView.imageEye.isHidden = false
            homeView.labelEye.isHidden = false
            homeView.buttonLandScape.isHidden = false
            homeView.buttonVolum.isHidden = false
            homeView.playerSlider.isHidden = false
            
            
            if playPauseButton == nil {
                
            } else {
                playPauseButton.isHidden = false
            }
           
            isButton = true
        }

    }
    
  
    
    
    func setUserProfile(user: User) {
        homeView.setImage(image: user.avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
        homeView.labelStreamDescription.text = self.user?.fullName
        guard let id = user.id else { return }
        if token != nil {
            self.binding(id: "\(id)")
        } else {
            self.binding(id: "\(id)")
        }
       
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

        self.homeView.imagePromo.addSubview(playPauseButton)
        playPauseButton.setup(in: self)
        
        self.view.addSubview(self.homeView.buttonSetting)
        self.homeView.buttonSetting.anchor( right: self.homeView.buttonLandScape.leftAnchor,  paddingRight: 10,  width: 20, height: 20)
        self.homeView.buttonSetting.centerY(inView: self.homeView.buttonLandScape)
        
        self.view.addSubview(self.homeView.buttonLandScape)
        self.homeView.buttonLandScape.setImage(UIImage(named: "enlarge"), for: .normal)
        self.homeView.buttonLandScape.anchor(right:self.playerViewController!.view.rightAnchor,bottom: self.playerViewController!.view.bottomAnchor,paddingRight: 20, paddingBottom: 10,width: 20,height: 20)
        
        self.view.addSubview(self.homeView.buttonVolum)
        self.homeView.buttonVolum.anchor(right:self.homeView.buttonSetting.leftAnchor,bottom: self.playerViewController!.view.bottomAnchor,paddingRight: 5 , paddingBottom: 10,width: 20,height: 20)
        
        self.view.addSubview(self.homeView.playerSlider)
        self.homeView.playerSlider.anchor(left: self.playerViewController!.view.leftAnchor, right: self.playerViewController!.view.rightAnchor, bottom: self.homeView.buttonSetting.topAnchor, paddingLeft: 2, paddingRight: 2, paddingBottom: 2)
        
    }

    //MARK: - Transishion
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
       
        if UIDevice.current.orientation.isLandscape {
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                self.playerViewController!.view.frame = self.view.bounds
                self.view.addSubview(self.playerViewController!.view)
                self.playerViewController!.didMove(toParent: self)
                self.playerViewController!.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.actionBut(sender:))))
                self.view.addSubview(self.homeView.buttonLandScape)
                self.view.addSubview(self.homeView.buttonSetting)
                self.view.addSubview(self.homeView.buttonVolum)
                self.view.addSubview(self.homeView.playerSlider)
                self.playerViewController?.view.addSubview(self.playPauseButton)               
                self.playPauseButton.updatePosition()
                self.homeView.buttonLandScape.setImage(UIImage(named: "scale-down"), for: .normal)
                self.view.layoutIfNeeded()
            
            })
            transitionAnimator.startAnimation()
            self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill            
           } else {
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                let playerFrame = self.homeView.imagePromo.bounds
                self.playerViewController!.view.frame = playerFrame
                self.playerViewController!.showsPlaybackControls = false
                self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.homeView.imagePromo.addSubview(self.playerViewController!.view)
                self.playerViewController!.didMove(toParent: self)
                self.homeView.buttonLandScape.setImage(UIImage(named: "enlarge"), for: .normal)
                self.view.layoutIfNeeded()
                })
            transitionAnimator.startAnimation()
            self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
            }
    }
   
    // MARK: - ButtonLandscape
    @objc func rightHandAction() {
        if isPlaying {
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
            self.isPlaying = false
        } else {
            AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
            self.isPlaying =  true
        }
    }
    func timerObserver(time: CMTime) {
        if let duration = self.playerViewController?.player?.currentItem?.asset.duration ,
            !duration.isIndefinite ,
            !isUpdateTime {
            if self.homeView.playerSlider.maximumValue != Float(duration.seconds) {
                self.homeView.playerSlider.maximumValue = Float(duration.seconds)
            }
          //  self.labCurrent.text = time.seconds.convertSecondString()
          //  self.labTotal.text = (duration.seconds-time.seconds).convertSecondString()
            self.homeView.playerSlider.value = Float(time.seconds)
        }
    }
    @objc func delaySeekTime() {
        let time =  CMTimeMake(value: Int64(self.homeView.playerSlider.value), timescale: 1)
        self.playerViewController?.player?.seek(to: time, completionHandler: { [unowned self] (finish) in
            self.isUpdateTime = false
        })
    }
    //MARK: - Selectors
    @objc private func refreshAlbumList() {
       }
    @objc func rightBack() {
        self.navigationController?.popViewController(animated: true)
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
                    self.homeView.tableView.reloadData()
 
                }
            })
        }
   
    func bindingChanellVOD(userId: String) {
        take = fitMeetStream.getBroadcastPrivateVOD(userId: "\(userId)")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {

                    guard  var s  = response.data?.reversed() else { return }
                    self.brodcast.append(contentsOf: s.reversed())
                    self.homeView.tableView.reloadData()
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
