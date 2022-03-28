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


protocol DissmisPlayer: class {
   func reloadbroadcast()
}


class PlayerViewVC: UIViewController, TagListViewDelegate {
    

    var offsetObservation: NSKeyValueObservation?
    var myCell: PlayerViewCell?

    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    let selfId = UserDefaults.standard.string(forKey: Constants.userID)
 
    weak var delegatePlayer: DissmisPlayer?
    
    var currentPage : Int = 1
    var currentPageCategory : Int = 1
    var isLoadingList : Bool = true
    var itemCount: Int = 0
    var categoryCount: Int = 0
    var allCount: Int = 0
  

    var isPlaying: Bool = false
    var isButton: Bool = true
    
    var isPrivate: Bool = false
   
    
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
 
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    private var takeOff: AnyCancellable?
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
    var broadId: String?
    var privateKey: String?
  
    
    private let refreshControl = UIRefreshControl()
  
  
    var urlStream: String?
    var playPauseButton: PlayPauseButton!
    var user: User?
    var usersd = [Int: User]()
    var url: String?
    var heightBar: CGFloat?
    
    var isPlay: Bool = true

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
      

        if self.broadcast?.status == "ONLINE" {
            self.urlStream = self.broadcast?.streams?.first?.hlsPlaylistUrl
        } else {
            self.urlStream = self.broadcast?.streams?.first?.vodUrl
        }
        self.homeView.labelStreamInfo.text = broadcast?.name
        if isPrivate {
            guard let id = broadId,let key = privateKey else { return }
            bindingBroadcastForId(id: id, key: key )
        } else {
            if self.broadcast != nil {
                loadPlayer()
                guard let idU = self.id else { return }
                bindingUser(id: idU)
            } else {
                guard let id = self.broadId else { return }
                bindingBroadcastFor(id: id)
                guard let idU = self.id else { return }
                bindingUser(id: idU)
            }
        }
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
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:            
                self.dismiss(animated: true) {
                    self.delegatePlayer?.reloadbroadcast()
                }
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
        homeView.playerSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
        homeView.buttonSetting.addTarget(self, action: #selector(actionSetting), for: .touchUpInside)
        homeView.settingView.button480.addTarget(self, action: #selector(action480), for: .touchUpInside)
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
            let highlightedImage = UIImage(named: "volumeMute")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            homeView.buttonVolum.setImage(highlightedImage, for: .normal)
            self.playerViewController?.player?.volume = 0
        } else {
            homeView.buttonVolum.setImage(#imageLiteral(resourceName: "volume-11"), for: .normal)
            self.playerViewController?.player?.volume = 1
        }

    }
    @objc func actionSetting() {
        homeView.buttonSetting.isSelected.toggle()
        if homeView.buttonSetting.isSelected {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
                self.view.addSubview(self.homeView.settingView)
                self.homeView.settingView.anchor( bottom: self.homeView.buttonSetting.topAnchor, paddingBottom: 3, width: 50, height: 100)
                self.homeView.settingView.centerX(inView: self.homeView.buttonSetting)
                self.homeView.settingView.alpha = 1
                }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
                self.homeView.settingView.alpha = 0
                }, completion: nil)
            
        }

    }
    @objc func action480() {
        homeView.settingView.button480.isSelected.toggle()
        if homeView.settingView.button480.isSelected {
            print("TODO: playlist")
        } else {
            print("TODO: playlist")
        }
    }
    @objc func actionMore() {
        guard token != nil else { return }
        let detailViewController = SendVC()
        actionSheetTransitionManager.height = 0.2
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = actionSheetTransitionManager
        detailViewController.url = broadcast?.url
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
                      self.bindingChanellVOD(userId: "\(id)", page: currentPage )
                 }
          })
      }
    func bindingBroadcastNotAuth(status: String,userId: String) {
        take = fitMeetStream.getBroadcastNotAuth(status: status, userId: userId)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.brodcast.append(contentsOf: response.data!)
                    self.bindingChanellVODNotAuth(userId: userId, page: self.currentPage)
                }
           })
       }

    func bindingBroadcastForId(id: String, key: String) {
        takeBroadcast = fitMeetStream.getBroadcastId(id: id, key: key)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { [self] response in
                      self.broadcast = response
                  if self.broadcast?.status == "ONLINE" {
                      self.urlStream = self.broadcast?.streams?.first?.hlsPlaylistUrl
                      self.homeView.playerSlider.isHidden = true
                      loadPlayer()
                      guard let userId = self.broadcast?.userId else { return }
                      bindingUser(id: userId)
                  } else {
                      self.urlStream = self.broadcast?.streams?.first?.vodUrl
                      loadPlayer()
                      guard let userId = self.broadcast?.userId else { return }
                      bindingUser(id: userId)
                  }
                  self.homeView.labelStreamInfo.text = broadcast?.name
                
          })
      }
    func bindingBroadcastFor(id: String) {
        takeBroadcast = fitMeetStream.getBroadcastId(id: id)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { [self] response in
                      self.broadcast = response
                  if self.broadcast?.status == "ONLINE" {
                      self.urlStream = self.broadcast?.streams?.first?.hlsPlaylistUrl
                      self.homeView.playerSlider.isHidden = true
                      loadPlayer()
                      guard let userId = self.broadcast?.userId else { return }
                      bindingUser(id: userId)
                  } else {
                      self.urlStream = self.broadcast?.streams?.first?.vodUrl
                      loadPlayer()
                      guard let userId = self.broadcast?.userId else { return }
                      bindingUser(id: userId)
                  }
                  self.homeView.labelStreamInfo.text = broadcast?.name
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
                if !response.data.isEmpty  {
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
             
         })
    }
   

   
    @objc func actionBut(sender:UITapGestureRecognizer) {
        if isButton {
  
            homeView.overlay.isHidden = true
            homeView.imageLive.isHidden = true
            homeView.labelLive.isHidden = true
            homeView.labelEye.isHidden = true
            homeView.buttonLandScape.isHidden = true
            homeView.buttonSetting.isHidden = true
            playPauseButton.isHidden = true
            homeView.buttonVolum.isHidden = true
            homeView.playerSlider.isHidden = true
            homeView.labelTimeEnd.isHidden = true
            homeView.labelTimeStart.isHidden =  true
            homeView.imageEye.isHidden = true
            if playPauseButton == nil {
                
            } else {
                playPauseButton.isHidden = true
            }
            isButton = false
        } else {
            if self.broadcast?.status == "OFFLINE" {
                homeView.overlay.isHidden = true
                homeView.imageLive.isHidden = true
                homeView.labelLive.isHidden = true
                homeView.labelEye.isHidden = true
                
            } else {
                homeView.overlay.isHidden = false
                homeView.imageLive.isHidden = false
                homeView.labelLive.isHidden = false
                homeView.labelEye.isHidden = false
            }
             if self.broadcast?.status == "ONLINE" {
                 homeView.playerSlider.isHidden = true
                 homeView.imageEye.isHidden = false
            } else {
                homeView.playerSlider.isHidden = false
               
            }
            homeView.buttonSetting.isHidden = false
            homeView.buttonLandScape.isHidden = false
            homeView.buttonVolum.isHidden = false
            homeView.labelTimeEnd.isHidden = false
            homeView.labelTimeStart.isHidden =  false
            
           
            
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
            self.bindingBroadcastNotAuth(status: "ONLINE", userId: "\(id)")
        }
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegatePlayer?.reloadbroadcast()
        self.playerViewController?.player?.rate = 0
    }
  
    // MARK: - LoadPlayer
    func loadPlayer() {
        guard let url = urlStream else { return }
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
        

       
        
        self.homeView.playerSlider.minimumValue = 0
        self.homeView.playerSlider.setValue(0, animated: true)
         
        
        let duration : CMTime = (playerViewController?.player?.currentItem!.asset.duration)!
        let seconds : Float64 = CMTimeGetSeconds(duration)
               
        
        guard let broadcast = self.broadcast else { return }
        if broadcast.status == "ONLINE" {
            self.homeView.playerSlider.maximumValue = 1
        } else {
            self.homeView.playerSlider.maximumValue = Float(seconds)
            self.homeView.playerSlider.isContinuous = true
            self.homeView.playerSlider.tintColor = .blueColor
            self.homeView.labelTimeEnd.text = " / " + Int(seconds).secondsToTime()
            
        }


      
            let interval: CMTime = CMTimeMakeWithSeconds(0.001, preferredTimescale: Int32(NSEC_PER_SEC))
            // CMTimeMakeWithSeconds(1, preferredTimescale: 1)
            playerViewController?.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
                if self.playerViewController?.player!.currentItem?.status == .readyToPlay {
                     let time : Float64 = CMTimeGetSeconds((self.playerViewController?.player!.currentTime())!)
                     UIView.animate(withDuration: 2) {
                         self.homeView.playerSlider.setValue(Float(time), animated: true)
                    }
                   
                     self.homeView.labelTimeStart.text = Int(time).secondsToTime()
                 }
             }
        
   
        

        self.homeView.imagePromo.addSubview(playPauseButton)
        playPauseButton.setup(in: self.playerViewController!)
     
        
        self.view.addSubview(self.homeView.buttonSetting)
        self.homeView.buttonSetting.anchor( right: self.homeView.buttonLandScape.leftAnchor,  paddingRight: 21,  width: 20, height: 20)
        self.homeView.buttonSetting.centerY(inView: self.homeView.buttonLandScape)
        
        self.view.addSubview(self.homeView.buttonLandScape)
        self.homeView.buttonLandScape.setImage(UIImage(named: "enlarge"), for: .normal)
        self.homeView.buttonLandScape.anchor(right:self.playerViewController!.view.rightAnchor,bottom: self.playerViewController!.view.bottomAnchor,paddingRight: 20, paddingBottom: 10,width: 20,height: 20)
        
        self.view.addSubview(self.homeView.buttonVolum)
        self.homeView.buttonVolum.anchor(right:self.homeView.buttonSetting.leftAnchor,bottom: self.playerViewController!.view.bottomAnchor,paddingRight: 21 , paddingBottom: 10,width: 20,height: 20)
        
        self.view.addSubview(self.homeView.playerSlider)
        self.homeView.playerSlider.anchor(left: self.playerViewController!.view.leftAnchor, right: self.playerViewController!.view.rightAnchor, bottom: self.homeView.buttonSetting.topAnchor, paddingLeft: 2, paddingRight: 2, paddingBottom: 2)
        
        self.view.addSubview(self.homeView.labelTimeStart)
        self.homeView.labelTimeStart.anchor(left: self.playerViewController!.view.leftAnchor, bottom: self.playerViewController!.view.bottomAnchor, paddingLeft: 16, paddingBottom: 10)
        
        self.view.addSubview(self.homeView.labelTimeEnd)
        self.homeView.labelTimeEnd.anchor(left: self.homeView.labelTimeStart.rightAnchor, bottom: self.playerViewController!.view.bottomAnchor, paddingLeft: 2, paddingBottom: 10)
        
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
                self.view.addSubview(self.homeView.labelTimeEnd)
                self.view.addSubview(self.homeView.labelTimeStart)
                
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
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        print("Value == \(playbackSlider.value)")
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        self.playerViewController?.player!.seek(to: targetTime)
        
        if  self.playerViewController?.player!.rate == 0
        {
            self.playerViewController?.player!.play()
        }
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
                detailViewController.chatView.buttonCloseChat.isHidden = false
                present(detailViewController, animated: true)
            } else {
                detailViewController.isLand = false
                actionChatTransitionManager.intWidth = 1
                actionChatTransitionManager.intHeight = 0.7
                actionChatTransitionManager.isLandscape = isLand
                detailViewController.color = .white
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
                    guard let categorys = self.broadcast?.categories else { return }
                    let s = categorys.map{$0.title!}
                    let arr = s.map { String("\u{0023}" + $0)}
                    self.homeView.labelCategory.removeAllTags()
                    self.homeView.labelCategory.addTags(arr)
                    self.homeView.labelCategory.delegate = self
                    self.setUserProfile(user: self.user!)
                    self.homeView.tableView.reloadData()
 
                }
            })
        }
   
    
    func bindingChanellVOD(userId: String,page: Int) {
        take = fitMeetStream.getBroadcastPrivateVOD(userId: "\(userId)", page: page, type: "STANDARD_VOD")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    guard let brod = response.data else { return }
                    self.brodcast.append(contentsOf: brod)
                   
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                }
                if response.meta != nil {
                    guard let itemCount = response.meta?.itemCount else { return }
                    self.itemCount = itemCount
                }
           })
       }
    func bindingChanellVODNotAuth(userId: String,page: Int) {
        self.isLoadingList = false
        take = fitMeetStream.getBroadcastPrivateVODNotAuth(userId: "\(userId)", page: page, type: "STANDARD_VOD")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil {
                    guard let brod = response.data else { return }
                    self.brodcast.append(contentsOf: brod)
                   
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                }
                if response.meta != nil {
                    guard let itemCount = response.meta?.itemCount else { return }
                    self.itemCount = itemCount
                }
           })
       }
    func loadMoreItemsForList(){
            currentPage += 1
            guard let id = user?.id else { return }
        if token != nil {
            bindingChanellVOD(userId: "\(id)", page: currentPage)
        } else {
            bindingChanellVODNotAuth(userId: "\(id)", page: currentPage)
        }
       }
    func bindingCategory(categoryId: Int,page: Int) {
        self.isLoadingList = false
        takeBroadcast = fitMeetStream.getBroadcastCategoryId(categoryId: categoryId, page: page)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    guard let brod = response.data else { return }
                    self.brodcast.append(contentsOf: brod)
                    
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                }
                if response.meta != nil {
                    guard let itemCount = response.meta?.itemCount else { return }
                    self.categoryCount = itemCount
                }
        })
    }
    func loadMoreCaategoryForList(){
            currentPageCategory += 1
            guard let id = self.broadcast?.categories?.first?.id else { return }
            bindingCategory(categoryId: id,page: currentPageCategory)
       }
    func bindingOff() {
        takeOff = fitMeetStream.getOffBroadcast()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    guard let brod = response.data else { return }
                    self.brodcast.append(contentsOf: brod)
                    
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                }
                if response.meta != nil {
                    guard let itemCount = response.meta?.itemCount else { return }
                    self.allCount = itemCount
                }
            })
    }
    func getMapWather(ids: [Int])  {
        watcherMap = fitMeetApi.getWatcherMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if !response.data.isEmpty {
                    guard let watchers = response.data["\(ids.first!)"] else { return }
                    self.homeView.labelEye.text = "\(watchers)"
                }
            })
       }
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}
