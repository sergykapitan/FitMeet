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
import Alamofire

protocol OpenCoachDelegate: AnyObject {
    func coachTapped(userId: Int)
}



class PlayerViewVC: SheetableViewController, TagListViewDelegate {
    
   
    let background = UIView()
    
    var offsetObservation: NSKeyValueObservation?
    var myCell: PlayerViewCell?
    var arrayResolution = [String]()
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    let selfId = UserDefaults.standard.string(forKey: Constants.userID)
    weak var delegate: OpenCoachDelegate?
    var bottomConstraint = NSLayoutConstraint()
 
    
    var currentPage : Int = 0
    var currentPageCategory : Int = 1
    var isLoadingList : Bool = false
    var itemCount: Int = 0
    var categoryCount: Int = 0
    var allCount: Int = 0
   
  

    var isPlaying: Bool = false
    var timer = Timer()
    let delay = 3
    var isButton: Bool = false {
                didSet {
                    print(isButton)
                    if self.isButton {
                    timer = Timer.scheduledTimer(timeInterval: TimeInterval(delay), target: self, selector: #selector(actionBut), userInfo: nil, repeats: false)
                    }
                }
            }
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
    var BoolTrack: Bool = true
    
    private let refreshControl = UIRefreshControl()
  
  
    var urlStream: String?
    var playPauseButton: PlayPauseButton!
    var user: User?
    var usersd = [Int: User]()
    var url: String?
    var heightBar: CGFloat?
    var tracksInt = 1
    var isPlay: Bool = true
   
    
  // MARK: - LifeCicle
    override func loadView() {
        view = homeView
        homeView.imageLogoProfile.makeRounded()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        homeView.imageLogoProfile.makeRounded()
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name:
        NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        homeView.imageLogoProfile.makeRounded()
        alphaButton()
        if self.broadcast?.status == .online {
            self.urlStream = self.broadcast?.streams?.first?.hlsPlaylistUrl
        } else {
            self.urlStream = self.broadcast?.streams?.first?.vodUrl
        }
        self.bindingLike()
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
        SocketWatcher.sharedInstance.closeConnection()
    }
  // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
        actionButton ()
        SocketIOManager.sharedInstance.getTokenChat()
        homeView.imageLogoProfile.makeRounded()
        _ = UserDefaults.standard.string(forKey: "tokenChat")
        _ = UserDefaults.standard.string(forKey: Constants.broadcastID)
        _ = UserDefaults.standard.string(forKey: Constants.chanellID)
        
        homeView.imagePromo.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(actionBut)))
       

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)

    }
    deinit {
        offsetObservation?.invalidate()
        offsetObservation = nil
        NotificationCenter.default.removeObserver(self)
    }
    @objc func videoDidEnd(notification: NSNotification) {
       
       // isButton = false
       // self.timer.invalidate()
        actionBut()
        actionPlayPause()
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                self.dismiss(animated: true) {
                    AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
                }
            default:
                break
            }
        }
    }
    func actionButton () {
        homeView.buttonLandScape.addTarget(self, action: #selector(rightHandAction), for: .touchUpInside)
        homeView.buttonSetting.addTarget(self, action: #selector(actionSetting), for: .touchUpInside)
        homeView.buttonPlayPause.addTarget(self, action: #selector(actionPlayPause), for: .touchUpInside)
        homeView.buttonSkipNext.addTarget(self, action: #selector(actionSkipNext), for: .touchUpInside)
        homeView.buttonSkipPrevious.addTarget(self, action: #selector(actionSkipPrevious), for: .touchUpInside)
        
        homeView.buttonChat.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
        homeView.buttonMore.addTarget(self, action: #selector(actionMore), for: .touchUpInside)
        homeView.buttonLike.addTarget(self, action: #selector(actionLike), for: .touchUpInside)
        homeView.playerSlider.addTarget(self, action: #selector(sliderValueChange(slider:)), for: .valueChanged)
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.actionCoach))
        homeView.stackButton.addGestureRecognizer(tap)
    }
    @objc func actionCoach() {
        self.dismiss(animated: true) {
            guard let id = self.broadcast?.userId else { return }
            self.delegate?.coachTapped(userId: id)
        }
    }
    @objc func actionSkipNext() {
        if tracksInt <= self.brodcast.count - 1 {
            let indexPath = IndexPath(row: tracksInt, section: 0)
            self.homeView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            getTrack(isForwardTrack: true)
        } else { return }
        
    }
    @objc func actionSkipPrevious() {
        if tracksInt != 0 {
            let indexPath = IndexPath(row: tracksInt, section: 0)
            self.homeView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            getTrack(isForwardTrack: false)
        } else { return }
    }
    @objc func actionPlayPause() {
        homeView.buttonPlayPause.isSelected.toggle()
        if homeView.buttonPlayPause.isSelected {
            homeView.buttonPlayPause.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            self.timer.invalidate()
            self.playerViewController?.player?.pause()
        } else {
            isButton = true
            homeView.buttonPlayPause.setImage(#imageLiteral(resourceName: "PausePlayer"), for: .normal)
            self.playerViewController?.player?.play()
        }
    }
    @objc func actionLike() {
        guard token != nil else {
            let sign = SignInViewController()
            self.present(sign, animated: true, completion: nil)
            return
        }
        homeView.buttonLike.isSelected.toggle()
        if homeView.buttonLike.isSelected {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.selectionChanged()
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
    @objc func actionSetting() {
        self.present()
    }
    @objc func actionMore() {
        guard token != nil,let broadcastId = self.broadcast?.id else { return }
        showDownSheet(moreArtworkOtherUserSheetVC, payload: broadcastId)
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
                  if self.broadcast?.status == .online {
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
    func broadcastForId(id: Int) -> BroadcastResponce?{
        var broadcasrRet:BroadcastResponce?
        takeBroadcast = fitMeetStream.getPrivateBroadcastId(id: "\(id)")
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { response in
                  broadcasrRet = response
          })
        guard let broadcasrRet = broadcasrRet else {  return self.broadcast! }
        return broadcasrRet
      }
    func bindingBroadcastFor(id: String) {
        takeBroadcast = fitMeetStream.getBroadcastId(id: id)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { [self] response in
                      self.broadcast = response
                  if self.broadcast?.status == .online {
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
                if let i = self.brodcast.map{$0.id}.firstIndex(of: response.id) {
                    self.brodcast[i].isFollow = true
                    self.brodcast[i].followersCount = response.followersCount
                }
          })
    }
    func unFollowBroadcast(id: Int) {
        followBroad = fitMeetStream.unFollowBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                guard let like = response.followersCount else { return }
                self.homeView.labelLike.text = "\(like)"
                if let i = self.brodcast.map{$0.id}.firstIndex(of: response.id) {
                    self.brodcast[i].isFollow = false
                    self.brodcast[i].followersCount = response.followersCount
                }
         })
    }
    @objc func actionBut(_ sender: UITapGestureRecognizer? = nil) {
        if isButton {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                self.alphaButton()
                self.background.removeFromSuperview()
                self.timer.invalidate()
            } completion: { bool in
                self.isButton = false
            }
        } else {
            self.addBack()
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                self.addAlfabutton()
            } completion: { bool in
                self.isButton = true
            }
        }
    }
    @objc func actionResize(sender:UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
             let scale = sender.scale
            sender.scale = 1.0
            if  scale > 1 {
                self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
            } else  {
                self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspect}
        @unknown default:
            print("def")
        }
    }
    func setUserProfile(user: User) {
        guard let id = user.id else { return }
        self.currentPage = 1
        if token != nil {
            self.binding(id: "\(id)")
        } else {
            self.bindingBroadcastNotAuth(status: "ONLINE", userId: "\(id)")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.playerViewController?.player?.rate = 0
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
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
        playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspect
        addChild(playerViewController!)
        homeView.imagePromo.addSubview(playerViewController!.view)
        playerViewController!.didMove(toParent: self)
     
        

        self.homeView.playerSlider.minimumValue = 0
        self.homeView.playerSlider.setValue(0, animated: true)
        setTimeVideo()
 

        let interval: CMTime = CMTimeMakeWithSeconds(0.001, preferredTimescale: Int32(NSEC_PER_SEC))
        playerViewController?.player!.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.playerViewController?.player!.currentItem?.status == .readyToPlay {
                 let timeLabel : Float64 = CMTimeGetSeconds((self.playerViewController?.player!.currentTime())!)
                 guard let time = self.playerViewController?.player!.currentTime() else { return }
                 self.timerObserver(time: time)
                 self.homeView.labelTimeStart.text = Int(timeLabel).secondsToTime()
             }
         }
    
       
        self.view.addSubview(self.homeView.buttonLandScape)
        let imageL = UIImage(named: "maximize")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.homeView.buttonLandScape.setImage(imageL, for: .normal)
        self.homeView.buttonLandScape.anchor(right:self.playerViewController!.view.rightAnchor,bottom: self.playerViewController!.view.bottomAnchor,paddingRight: 5, paddingBottom: 5,width: 50,height: 30)
        
        self.view.addSubview(self.homeView.buttonSetting)
        self.homeView.buttonSetting.anchor( right: self.homeView.buttonLandScape.leftAnchor,  paddingRight: 1,width: 50,height: 30)
        self.homeView.buttonSetting.centerY(inView: self.homeView.buttonLandScape)
       
        self.view.addSubview(self.homeView.playerSlider)
        self.homeView.playerSlider.anchor(left: self.playerViewController!.view.leftAnchor, right: self.playerViewController!.view.rightAnchor, bottom: self.homeView.buttonSetting.topAnchor, paddingLeft: 2, paddingRight: 2, paddingBottom: 1,height: 20)
        
        self.view.addSubview(self.homeView.buttonPlayPause)
        self.homeView.buttonPlayPause.anchor(bottom: self.homeView.playerSlider.topAnchor, paddingBottom: 40)
      
        self.homeView.buttonPlayPause.centerX(inView: self.homeView.tableView)
        
        self.view.addSubview(self.homeView.buttonSkipPrevious)
        self.homeView.buttonSkipPrevious.anchor(right: self.homeView.buttonPlayPause.leftAnchor, paddingRight: 15)
        self.homeView.buttonSkipPrevious.centerY(inView: self.homeView.buttonPlayPause)
               
        self.view.addSubview(self.homeView.buttonSkipNext)
        self.homeView.buttonSkipNext.anchor(left: self.homeView.buttonPlayPause.rightAnchor, paddingLeft: 15)
        self.homeView.buttonSkipNext.centerY(inView: self.homeView.buttonPlayPause)
        
        self.view.addSubview(self.homeView.labelTimeStart)
        self.homeView.labelTimeStart.anchor(left: self.playerViewController!.view.leftAnchor, bottom: self.playerViewController!.view.bottomAnchor, paddingLeft: 16, paddingBottom: 10)
        
        self.view.addSubview(self.homeView.labelTimeEnd)
        self.homeView.labelTimeEnd.anchor(left: self.homeView.labelTimeStart.rightAnchor, bottom: self.playerViewController!.view.bottomAnchor, paddingLeft: 2, paddingBottom: 10)
        
    }
    private func setTimeVideo() {
        let duration : CMTime = (self.playerViewController?.player?.currentItem!.asset.duration)!
        let seconds : Float64 = CMTimeGetSeconds(duration)
               
        
        guard let broadcast = self.broadcast else { return }
        if broadcast.status == .online {
            self.homeView.playerSlider.maximumValue = 1
        } else {
            self.homeView.playerSlider.maximumValue = Float(seconds)
            self.homeView.playerSlider.isContinuous = true
            self.homeView.playerSlider.tintColor = .blueColor
            self.homeView.labelTimeEnd.text = " / " + Int(seconds).secondsToTime()
            
        }
    }
  
 // MARK: - Transishion
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
       
        if UIDevice.current.orientation.isLandscape {
            
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                self.playerViewController!.view.frame = self.view.bounds
                self.view.addSubview(self.playerViewController!.view)
                self.playerViewController!.didMove(toParent: self)
                self.playerViewController!.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.actionBut)))
                self.playerViewController!.view.addGestureRecognizer(UIPinchGestureRecognizer.init(target: self, action: #selector(self.actionResize(sender:))))
                
                self.view.addSubview(self.homeView.playerSlider)
                self.view.addSubview(self.homeView.buttonLandScape)
                self.view.addSubview(self.homeView.buttonSetting)
                self.view.addSubview(self.homeView.labelTimeEnd)
                self.view.addSubview(self.homeView.labelTimeStart)
                self.view.addSubview(self.homeView.buttonPlayPause)
                self.view.addSubview(self.homeView.buttonSkipNext)
                self.view.addSubview(self.homeView.buttonSkipPrevious)
                self.homeView.buttonPlayPause.anchor(bottom: self.homeView.playerSlider.topAnchor, paddingBottom: 130)
                
               
                let imageL = UIImage(named: "minimize")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                self.homeView.buttonLandScape.setImage(imageL, for: .normal)
                self.view.layoutIfNeeded()
            
            })
            transitionAnimator.startAnimation()
            playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspect
           } else {
               
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                self.homeView.buttonPlayPause.removeFromSuperview()
                let playerFrame = self.homeView.imagePromo.bounds
                self.playerViewController!.view.frame = playerFrame
                self.playerViewController!.showsPlaybackControls = false
                self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.homeView.imagePromo.addSubview(self.playerViewController!.view)
                self.playerViewController!.didMove(toParent: self)
                let imageL = UIImage(named: "maximize")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                
                self.view.addSubview(self.homeView.buttonPlayPause)
                self.homeView.buttonPlayPause.anchor(bottom: self.homeView.playerSlider.topAnchor, paddingBottom: 40)
                self.homeView.buttonPlayPause.centerX(inView: self.homeView.tableView)
                self.view.addSubview(self.homeView.buttonSkipPrevious)
                self.homeView.buttonSkipPrevious.anchor(right: self.homeView.buttonPlayPause.leftAnchor, paddingRight: 15)
                self.homeView.buttonSkipPrevious.centerY(inView: self.homeView.buttonPlayPause)
                       
                self.view.addSubview(self.homeView.buttonSkipNext)
                self.homeView.buttonSkipNext.anchor(left: self.homeView.buttonPlayPause.rightAnchor, paddingLeft: 15)
                self.homeView.buttonSkipNext.centerY(inView: self.homeView.buttonPlayPause)
                self.homeView.buttonLandScape.setImage(imageL, for: .normal)
                self.view.layoutIfNeeded()
                })
            transitionAnimator.startAnimation()
               playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspect
            }
    }
 // MARK: - Selectors
    @objc func rightHandAction() {
        homeView.buttonLandScape.isSelected.toggle()
        if homeView.buttonLandScape.isSelected {
            AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)
        } else {
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        }
    }
    func timerObserver(time: CMTime) {
        if let duration = self.playerViewController?.player?.currentItem?.asset.duration ,
            !duration.isIndefinite ,
            !isUpdateTime {
            if self.homeView.playerSlider.maximumValue != Float(duration.seconds) {
                self.homeView.playerSlider.maximumValue = Float(duration.seconds)
            }
            self.homeView.playerSlider.value = Float(time.seconds)
        }
    }
    @objc  func sliderValueChange(slider: UISlider) {
        self.isUpdateTime = true
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delaySeekTime), object: nil)
        self.perform(#selector(delaySeekTime), with: nil, afterDelay: 0.1)
    }
    @objc func delaySeekTime() {
        let time =  CMTimeMake(value: Int64(self.homeView.playerSlider.value), timescale: 1)
        self.playerViewController?.player?.seek(to: time, completionHandler: { [unowned self] (finish) in
            self.isUpdateTime = false
        })
    }
    @objc private func refreshAlbumList() {
       }
    @objc func rightBack() {
      //  self.navigationController?.popViewController(animated: true)
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
                }
            })
      }
    func bindingUser(id: Int) {
        takeUser = fitMeetApi.getUserId(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                    self.user = response
                    self.homeView.labelStreamDescription.text = self.user?.fullName
                    guard let categorys = self.broadcast?.categories else { return }
                    let s = categorys.map{$0.title!}
                    let arr = s.map { String("\u{0023}" + $0)}
                    self.homeView.labelCategory.removeAllTags()
                    self.homeView.labelCategory.addTags(arr)
                    self.homeView.labelCategory.delegate = self
                    self.homeView.setImage(image: self.user?.avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
                    
                    if self.BoolTrack {
                       self.setUserProfile(user: self.user!)
                    }
                    self.homeView.tableView.reloadData()
 
                }
            })
        }
    func bindingUserNotApdate(id: Int) {
        takeUser = fitMeetApi.getUserId(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                    self.user = response
                    self.homeView.setImage(image: self.user?.avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
                    self.homeView.labelStreamDescription.text = self.user?.fullName

                    guard let categorys = self.broadcast?.categories else { return }
                    let s = categorys.map{$0.title!}
                    let arr = s.map { String("\u{0023}" + $0)}
                    self.homeView.labelCategory.removeAllTags()
                    self.homeView.labelCategory.addTags(arr)
                    self.homeView.labelCategory.delegate = self
                    self.homeView.tableView.reloadData()
 
                }
            })
        }
    func bindingLike() {
        
        guard let likeCount = self.broadcast?.followersCount else { return }
        self.homeView.labelLike.text = "\(likeCount)"

        guard let like = self.broadcast?.isFollow else { return }
        like ?  homeView.buttonLike.setImage(#imageLiteral(resourceName: "Like"), for: .normal) :  homeView.buttonLike.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
        self.homeView.buttonLike.isSelected = like
        
        
    }
    func bindingChanellVOD(userId: String,page: Int) {
        take = fitMeetStream.getBroadcastPrivateVOD(userId: "\(userId)", page: page, type: "STANDARD_VOD")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    guard let brod = response.data else { return }
                    self.brodcast.append(contentsOf: brod)
                    self.isLoadingList = false
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
                    
                    self.isLoadingList = false
                    self.homeView.tableView.reloadData()
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
        takeOff = fitMeetStream.getOffBroadcast(page: 1)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    guard let brod = response.data else { return }
                    self.brodcast.append(contentsOf: brod)
                    self.homeView.tableView.reloadData()
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                }
                if response.meta != nil {
                    guard let itemCount = response.meta?.itemCount else { return }
                    self.allCount = itemCount
                }
            })
    }
    func bindingOffNot() {
        takeOff = fitMeetStream.getOffNotAuthBroadcast(page: 1)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    guard let brod = response.data else { return }
                    self.brodcast.append(contentsOf: brod)
                    self.homeView.tableView.reloadData()
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
    private func getTrack(isForwardTrack: Bool) {
        guard let indexPath = homeView.tableView.indexPathForSelectedRow else { return  }
        
        
        let tracks = self.brodcast
        var nextIndexPath: IndexPath!
                if isForwardTrack {
                    tracksInt += 1
                    nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                    if nextIndexPath.row == tracks.count {
                        nextIndexPath.row = 0
                        tracksInt = 0
                    }
                } else {
                    tracksInt -= 1
                    nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                   
                }
        let track = tracks[nextIndexPath.row]
 
        if track.status == .offline {
            self.homeView.imageLogo.isHidden = true
            self.homeView.buttonChat.isHidden = true
            homeView.buttonChat.isHidden = true
            homeView.imageLive.image = #imageLiteral(resourceName: "rec")
            homeView.imageLive.setImageColor(color: .gray)
            homeView.labelLive.text = ""
            homeView.imageEye.isHidden = true
            homeView.labelEye.isHidden = true
            homeView.playerSlider.isHidden = false
            self.broadcast = track
            self.urlStream = track.streams?.first?.vodUrl
            self.bindingLike()
            guard let url = urlStream else { return }
            guard let videoURL = URL(string: url) else { return}
            self.homeView.playerSlider.setValue(0, animated: true)
            self.playerViewController?.player!.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
            setTimeVideo()
            self.homeView.labelStreamInfo.text = self.broadcast?.name
            homeView.buttonPlayPause.setImage(#imageLiteral(resourceName: "PausePlayer"), for: .normal)
            self.playerViewController?.player?.play()
            guard let user = self.broadcast?.userId else { return}
            self.BoolTrack = false
            self.bindingUser(id: user)
        }

   }
    private func action(for type: String, title: String) -> UIAlertAction? {
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            guard let url = URL(string: urlStream!) else { return }
      
            switch type {
            case "Auto" :
                self.replaceItem(with: url)
            case "240" :
                let change = changeUrl(url: urlStream!, end: arrayResolution[0])
                guard let urls = URL(string: change) else { return }
                self.replaceItem(with: urls)
            case "360" :
                let change = changeUrl(url: urlStream!, end: arrayResolution[1])
                guard let urls = URL(string: change) else { return }
                self.replaceItem(with: urls)
            case "480" :
                let change = changeUrl(url: urlStream!, end: arrayResolution[2])
                guard let urls = URL(string: change) else { return }
                self.replaceItem(with: urls)
            case "720" :
                let change = changeUrl(url: urlStream!, end: arrayResolution[3])
                guard let urls = URL(string: change) else { return }
                self.replaceItem(with: urls)
            case "1080" :
                let change = changeUrl(url: urlStream!, end: arrayResolution[4])
                guard let urls = URL(string: change) else { return }
                self.replaceItem(with: urls)
                break
            default:
               break
            }
           
        }
    }
    public func present() {
        
        guard let urlStream = urlStream else { return }
        guard let url = URL(string: urlStream) else { return }
        var streamResolution = [StreamResolution]()
        var alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                         
        if UIDevice.current.orientation == .portrait {
                alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        } else if UIDevice.current.orientation == .landscapeLeft {
                alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        } else if UIDevice.current.orientation == .landscapeRight {
                alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            }
        
        self.getPlaylist(from: url) { result in
            switch result {
            case .success( let raw ):
                self.arrayResolution = self.getStreamResolutions(from: raw)
                streamResolution = self.getStreamResolutionsAll(from: raw)
                streamResolution.forEach {
                    let action = self.action(for: $0.stringHeight, title: $0.stringHeight + "p")
                    guard let action = action else {return  }
                    DispatchQueue.main.async {
                        alertController.addAction(action)
                    }
                }
                if let action = self.action(for: "Auto", title: "Auto") {
                    DispatchQueue.main.async {
                    alertController.addAction(action)
                    }
                }
                DispatchQueue.main.async {
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                }
                if UIDevice.current.userInterfaceIdiom == .pad {
                    alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
                }
                DispatchQueue.main.async {
                   self.present(alertController, animated: true)
                }
            case .failure(let error):
                print("Error = \(error)")
            }
        }
    }
        /// Downloads the stream file and converts it to the raw playlist.
        /// - Parameter completion: In successful case should return the `RawPlalist` which contains the url with which was the request performed
        /// and the string representation of the downloaded file as `content: String` parameter.
    func getPlaylist(from url: URL, completion: @escaping (Swift.Result<RawPlaylist,Error>) -> Void)  {
            let task = URLSession.shared.dataTask(with: url ){ data, response, error in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data, let string = String(data: data, encoding: .utf8) {
                    completion(.success(RawPlaylist(url: url, content: string)))
                } else {
                   print("TO DO:")
                }
            }
            task.resume()
        }
      /// Iterates over the provided playlist contetn and fetches all the stream info data under the `#EXT-X-STREAM-INF"` key.
      /// - Parameter playlist: Playlist object obtained from the stream url.
      /// - Returns: All available stream resolutions for respective bandwidth.
    func getStreamResolutions(from playlist: RawPlaylist) -> [String] {
        let band = playlist.content.components(separatedBy: "\n")
        let arrayResolution = band.filter(){$0.hasSuffix("m3u8")}
        return arrayResolution
    }
    func getStreamResolutionsAll(from playlist: RawPlaylist) -> [StreamResolution] {
        var resolutions = [StreamResolution]()
        playlist.content.enumerateLines { line, shouldStop in
            let infoline = line.replacingOccurrences(of: "#EXT-X-STREAM-INF", with: "")
            let infoItems = infoline.components(separatedBy: ",")
            let bandwidthItem = infoItems.first(where: { $0.contains(":BANDWIDTH") })
            let resolutionItem = infoItems.first(where: { $0.contains("RESOLUTION")})
            if let bandwidth = bandwidthItem?.components(separatedBy: "=").last,
               let numericBandwidth = Double(bandwidth),
               let resolution = resolutionItem?.components(separatedBy: "=").last?.components(separatedBy: "x"),
               let strignWidth = resolution.first,
               let stringHeight = resolution.last,
               let width = Double(strignWidth),
               let height = Double(stringHeight) {
               resolutions.append(StreamResolution(maxBandwidth: numericBandwidth,
                                                    averageBandwidth: numericBandwidth,
                                                   resolution: CGSize(width: width, height: height), stringHeight: stringHeight))
            }
        }
        return resolutions
    }
    private func replaceItem(with newResolution: URL ) {
            let currentTime: CMTime
        if let currentItem = self.playerViewController?.player?.currentItem {
                currentTime = currentItem.currentTime()
            } else {
                currentTime = .zero
            }
            
        self.playerViewController?.player?.replaceCurrentItem(with: AVPlayerItem(url: newResolution))
        self.playerViewController?.player?.seek(to: currentTime, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    func changeUrl(url: String,end: String) -> (String) {
        let i = url.replacingOccurrences(of: "playlist.m3u8", with: end)
        return i
    }
    public func addBack() {
        background.backgroundColor = .black
        background.alpha = 0.3
        playerViewController!.view.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.bottomAnchor.constraint(equalTo: playerViewController!.view.bottomAnchor).isActive = true
        background.topAnchor.constraint(equalTo: playerViewController!.view.topAnchor).isActive = true
        background.leadingAnchor.constraint(equalTo: playerViewController!.view.leadingAnchor).isActive = true
        background.trailingAnchor.constraint(equalTo: playerViewController!.view.trailingAnchor).isActive = true

    }
 }

public extension UIView {

    @discardableResult
    public func addBlur(style: UIBlurEffect.Style = .dark) -> UIVisualEffectView { 
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        
        blurBackground.backgroundColor = .black
        blurBackground.alpha = 0.2
        addSubview(blurBackground)
        blurBackground.translatesAutoresizingMaskIntoConstraints = false
        blurBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        blurBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        return blurBackground
    }
    
    
    func removeBlurA() {
        for subview in self.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
}
extension PlayerViewVC {
    func alphaButton() {
        self.homeView.overlay.alpha = 0
        self.homeView.imageLive.alpha = 0
        self.homeView.labelLive.alpha = 0
        self.homeView.labelEye.alpha = 0
        self.homeView.buttonLandScape.alpha = 0
        self.homeView.buttonSetting.alpha = 0
        self.homeView.buttonPlayPause.alpha = 0
        self.homeView.buttonSkipNext.alpha = 0
        self.homeView.buttonSkipPrevious.alpha = 0
        self.homeView.playerSlider.alpha = 0
        self.homeView.labelTimeEnd.alpha = 0
        self.homeView.labelTimeStart.alpha = 0
        self.homeView.imageEye.alpha = 0
    }
    func addAlfabutton() {
        self.homeView.overlay.alpha = 1
        self.homeView.imageLive.alpha = 1
        self.homeView.labelLive.alpha = 1
        self.homeView.labelEye.alpha = 1
        self.homeView.buttonLandScape.alpha = 1
        self.homeView.buttonSetting.alpha = 1
        self.homeView.buttonPlayPause.alpha = 1
        self.homeView.buttonSkipNext.alpha = 1
        self.homeView.buttonSkipPrevious.alpha = 1
        self.homeView.playerSlider.alpha = 1
        self.homeView.labelTimeEnd.alpha = 1
        self.homeView.labelTimeStart.alpha = 1
        self.homeView.imageEye.alpha = 1
    }
}
