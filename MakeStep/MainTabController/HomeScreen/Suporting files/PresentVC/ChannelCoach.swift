//
//  ChannelCoach.swift
//  MakeStep
//
//  Created by Sergey on 24.02.2022.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass
import Combine
import ContextMenuSwift
import TimelineTableViewCell
import MMPlayerView
import AVFoundation
import EasyPeasy
import AVKit


// MARK: - State

private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}
//, CustomSegmentedControlDelegate//CustomSegmentedFullControlDelegate
class ChannelCoach: UIViewController, VeritiPurchase  {
    func addPurchase() {
        guard let userId = user?.id else { return }
        self.bindingChannel(userId: userId)
    }
    

 
    let popupOffset: CGFloat = -350
    var bottomConstraint = NSLayoutConstraint()
    
    var broadcast: BroadcastResponce?
    
     var topConstraint = NSLayoutConstraint()
     var leftConstant = NSLayoutConstraint()
     var botConstant = NSLayoutConstraint()
     var centerConstant = NSLayoutConstraint()
    
    var heightConstant = NSLayoutConstraint()
    var widthConstant = NSLayoutConstraint()
    
    var topWelcomLabelConstant = NSLayoutConstraint()
    var leftWelcomeLabelConstant = NSLayoutConstraint()
    var centerWelcomeLabelConstant = NSLayoutConstraint()
    var rightWelcomLabel = NSLayoutConstraint()
    
    var topOverlayConstant = NSLayoutConstraint()
    var rightLandscape = NSLayoutConstraint()
    var topbuttonSubscribeConstant = NSLayoutConstraint()
    var leftbuttonSubscribeConstant = NSLayoutConstraint()
    var rightbuttonSubscribeConstant = NSLayoutConstraint()
    var centerbuttonSubscribeConstant = NSLayoutConstraint()
    
    var bottomButtonChatConstant = NSLayoutConstraint()
    var heightViewTop = NSLayoutConstraint()
    
    
    let homeView = ChanellCoachCode()
    let selfId = UserDefaults.standard.string(forKey: Constants.userID)
    private var take: AnyCancellable?
    private var takeChanell: AnyCancellable?
    private var followBroad: AnyCancellable?

    var myCell: PlayerViewCell?
    
    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var firMeetChanell: FitMeetChannels
    @Inject var fitMeetStream: FitMeetStream
    var user: User?
    var brodcast: [BroadcastResponce] = []
    var indexButton: Int = 0
    let actionChatTransitionManager = ActionTransishionChatManadger()
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    var url: String?
    var usersd = [Int: User]()
    var userID = UserDefaults.standard.string(forKey: Constants.userID)
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)

    
    var playerViewController: AVPlayerViewController?
    
    private var takeChannel: AnyCancellable?
    private var channels: AnyCancellable?
    private var takeBroadcast: AnyCancellable?
    private var takeBroadcastPlanned : AnyCancellable?
 
    @Inject var fitMeetChannel: FitMeetChannels
    var channel: ChannelResponce?
    
   
    
    var isPlaying: Bool = false
    var isButton: Bool = true
    var playPauseButton: PlayPauseButton!

//    override  var shouldAutorotate: Bool {
//        return false
//    }
//    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
    
    override func loadView() {
        super.loadView()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButtonContinue()
        makeNavItem()
        createTableView()
      //  profileView.segmentControll.setButtonTitles(buttonTitles: ["Videos","Timetable"])//,
      //  profileView.segmentControll.delegate = self
     //   removeAllChildViewController(timeTable)
      //  configureChildViewController(videoVC, onView: profileView.selfView )
        guard let userID = self.user?.id else { return }
       
     
        
        layout()
        homeView.viewTop.addGestureRecognizer(panRecognizer)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

         if let swipeGesture = gesture as? UISwipeGestureRecognizer {

             switch swipeGesture.direction {
             case UISwipeGestureRecognizer.Direction.right:
                 self.navigationController?.popViewController(animated: true)
             case UISwipeGestureRecognizer.Direction.down:
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white
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
      //  profileView.segmentControll.backgroundColor = UIColor(hexString: "#F6F6F6")
        self.navigationController?.navigationBar.isHidden = false
        
        guard let id = user?.id else { return }
        bindingChannel(userId: id)
        if token != nil {
          //  self.bindingBroadcast(status: "WAIT_FOR_APPROVE", userId: "\(id)",type: "STANDARD_VOD")
          //  self.bindingBroadcast(status: "OFFLINE", userId: "\(id)",type: "STANDARD_VOD")
          //  self.bindingBroadcast(status: "WAIT_FOR_APPROVE", userId: "\(id)",type: "STANDARD_VOD")
          
            self.binding(id: "\(id)")
          //  self.bindingPlanned(id: "\(id)")
            self.bindingChanellVOD(userId: "\(id)")
        } else {
            self.bindingBroadcastNotAuth(status: "PLANNED", userId: "\(id)")
        }
        AppUtility.lockOrientation(.portrait)
     //   configureChildViewController(videoVC, onView: profileView.selfView )
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        homeView.imageLogoProfile.makeRounded()
        setUserProfile()
      
       
    }
    func bindingChanellVOD(userId: String) {
        take = fitMeetStream.getBroadcastPrivateVOD(userId: "\(userId)")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    guard let brod = response.data else { return }
                    self.brodcast.append(contentsOf: brod)
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.brodcast = self.brodcast.reversed()
                    self.homeView.tableView.reloadData()
                }
           })
       }

    func bindingChannel(userId: Int?) {
        guard let id = userId else { return }
        takeChanell = fitMeetChannel.listChannelsPrivate(idUser: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil  {
                    self.channel = response.data.last
                    guard let channel = self.channel else {
                        return
                    }
                    if channel.isSubscribe! {                        
                        self.homeView.buttonSubscribe.setTitle("Subscribers", for: .normal)
                        self.homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
                        self.homeView.buttonSubscribe.backgroundColor = .white
                    } else {
                        self.homeView.buttonSubscribe.backgroundColor = .blueColor
                        self.homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
                        self.homeView.buttonSubscribe.setTitle("Subscribe", for: .normal)
                    }
                    guard let _ = self.channel?.twitterLink ,
                          let _ = self.channel?.instagramLink ,
                          let _ = self.channel?.facebookLink else { return }
                    self.homeView.buttonTwiter.setImageTintColor(.blueColor)
                    self.homeView.buttonfaceBook.setImageTintColor(.blueColor)
                    self.homeView.buttonInstagram.setImageTintColor(.blueColor)
                }
        })
    }
    func bindingBroadcast(status: String,userId: String,type: String) {
        take = fitMeetStream.getBroadcastPrivate(status: status, userId: userId,type: type)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                   
                    self.brodcast = response.data!
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    
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
                      if !response.data!.isEmpty  {
                          self.homeView.imagePromo.isHidden = false
                          self.homeView.imageLogo.isHidden = false
                          self.homeView.labelStreamInfo.isHidden = false
                          self.homeView.buttonMore.isHidden = false
                          homeView.cardView.addSubview(homeView.tableView)
                          homeView.tableView.anchor(top: homeView.labelStreamInfo.bottomAnchor,
                                           left: homeView.cardView.leftAnchor,
                                           right: homeView.cardView.rightAnchor,
                                           bottom: homeView.cardView.bottomAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
                          loadPlayer(url: (self.brodcast.first?.streams?.first?.hlsPlaylistUrl)!)
                      } else {
                          self.homeView.imagePromo.isHidden = true
                          self.homeView.imageLogo.isHidden = true
                          self.homeView.labelStreamInfo.isHidden = true
                          self.homeView.buttonMore.isHidden = true
                          homeView.cardView.addSubview(homeView.tableView)
                          homeView.tableView.anchor(top: homeView.cardView.topAnchor,
                                           left: homeView.cardView.leftAnchor,
                                           right: homeView.cardView.rightAnchor,
                                           bottom: homeView.cardView.bottomAnchor, paddingTop: 110, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
                      }
                      self.bindingChanellVOD(userId: id)
                     

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
    func bindingBroadcastNotAuth(status: String,userId: String) {
        take = fitMeetStream.getBroadcastNotAuth(status: status, userId: userId)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                   
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
    func loadPlayer(url: String) {
       
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
        self.view.addSubview(self.homeView.buttonLandScape)
        self.homeView.buttonLandScape.setImage(UIImage(named: "enlarge"), for: .normal)
        self.homeView.buttonLandScape.anchor(right:self.playerViewController!.view.rightAnchor,bottom: self.playerViewController!.view.bottomAnchor,paddingRight: 20, paddingBottom: 10,width: 20,height: 20)
        
        self.view.addSubview(self.homeView.buttonSetting)
        self.homeView.buttonSetting.anchor( right: self.homeView.buttonLandScape.leftAnchor,  paddingRight: 10,  width: 20, height: 20)
        self.homeView.buttonSetting.centerY(inView: self.homeView.buttonLandScape)
  
        self.view.addSubview(self.homeView.buttonVolum)
        self.homeView.buttonVolum.anchor(right:self.homeView.buttonSetting.leftAnchor,bottom: self.playerViewController!.view.bottomAnchor,paddingRight: 5 , paddingBottom: 10,width: 20,height: 20)
        
       
        
    }
    // MARK: - Animation
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    private var currentState: State = .closed
    
    /// All of the currently running animators.
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()
    
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = recognizer.translation(in: homeView.viewTop)
            var fraction = -translation.y / popupOffset
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let yVelocity = recognizer.velocity(in: homeView.viewTop).y
            let shouldClose = yVelocity < 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
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

    

    func setUserProfile() {

        homeView.setImage(image: user?.resizedAvatar?["avatar_120"]?.png ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
        guard let follow = user?.channelFollowCount,let fullName = user?.fullName,let sub = user?.channelSubscribeCount!  else { return }
        homeView.labelFollow.text = "Followers:" + "\(follow)"
        self.homeView.welcomeLabel.text = fullName
        self.homeView.labelINTFollows.text = "\(follow)"
        self.homeView.labelINTFolowers.text = "\(sub)"
        self.homeView.labelDescription.text = channel?.description //" Welcome to my channel!\n My name is \(fullName)"
 
    }
    
    func actionButtonContinue() {
      
        homeView.buttonSubscribe.addTarget(self, action: #selector(actionSubscribe), for: .touchUpInside)
        homeView.buttonTwiter.addTarget(self, action: #selector(actionTwitter), for: .touchUpInside)
        homeView.buttonfaceBook.addTarget(self, action: #selector(actionFacebook), for: .touchUpInside)
        homeView.buttonInstagram.addTarget(self, action: #selector(actionInstagram), for: .touchUpInside)
        homeView.buttonFollow.addTarget(self, action: #selector(actionFollow), for: .touchUpInside)
        
        homeView.buttonLandScape.addTarget(self, action: #selector(rightHandAction), for: .touchUpInside)
        homeView.buttonChat.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
        homeView.buttonMore.addTarget(self, action: #selector(actionMore), for: .touchUpInside)
        homeView.buttonVolum.addTarget(self, action: #selector(actionVolume), for: .touchUpInside)
       

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
                self.playerViewController?.view.addSubview(self.playPauseButton)
                self.playPauseButton.updatePosition()
                self.homeView.buttonLandScape.setImage(UIImage(named: "scale-down"), for: .normal)
                self.navigationController?.navigationBar.isHidden = true
                self.tabBarController?.tabBar.isHidden = true
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
                self.navigationController?.navigationBar.isHidden = false
                self.tabBarController?.tabBar.isHidden = false
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
    @objc func actionFollow() {
       print("Folow")
    }
    @objc func actionTwitter() {
        guard let link = self.channel?.twitterLink else { return }
        if let url = URL(string: link) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
    }
    @objc func actionInstagram() {
        guard let link = self.channel?.instagramLink else { return }
        if let url = URL(string: link) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
    }
    @objc func actionFacebook() {
        guard let link = self.channel?.facebookLink else { return }
        if let url = URL(string: link) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
    }
  
    // MARK: - ActionChat
    @objc func actionChat(sender:UITapGestureRecognizer) {

     
         
            isButton = false
            
            let detailViewController = ChatVCPlayer()
            detailViewController.modalPresentationStyle = .custom
            detailViewController.transitioningDelegate = actionChatTransitionManager
            detailViewController.broadcast = broadcast
            detailViewController.color = .white


            AppUtility.lockOrientation(.portrait)
            
           
           
           
            actionChatTransitionManager.intWidth = 1
            actionChatTransitionManager.intHeight = 0.7
            present(detailViewController, animated: true)
        
       
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
         detailViewController.url = broadcast?.url
         present(detailViewController, animated: true)

     }
    @objc func actionBut(sender:UITapGestureRecognizer) {
        
        
        if isButton {
           // homeView.overlay.isHidden = true
           // homeView.imageLive.isHidden = true
           // homeView.labelLive.isHidden = true
           // homeView.imageEye.isHidden = true
           // homeView.labelEye.isHidden = true
            homeView.buttonLandScape.isHidden = true
            homeView.buttonSetting.isHidden = true
          //  playPauseButton.isHidden = true
            homeView.buttonVolum.isHidden = true
           
         
            
            isButton = false
        } else {
   
           
            homeView.buttonSetting.isHidden = false
          //  homeView.overlay.isHidden = false
          //  homeView.imageLive.isHidden = false
          //  homeView.labelLive.isHidden = false
           // homeView.imageEye.isHidden = false
          //  homeView.labelEye.isHidden = false
            homeView.buttonLandScape.isHidden = false
            homeView.buttonVolum.isHidden = false
         
            
        
           
            isButton = true
        }

    }
    
  
    private func createTableView() {
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self
        homeView.tableView.register(PlayerViewCell.self, forCellReuseIdentifier: PlayerViewCell.reuseID)
        homeView.tableView.separatorStyle = .none
        homeView.tableView.showsVerticalScrollIndicator = false
    }
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Channel"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
                    
                    let backButton = UIButton()
                  //  backButton.setImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                    backButton.setBackgroundImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)
                    backButton.anchor(width:30,height: 30)
                   let stackView = UIStackView(arrangedSubviews: [backButton,titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .horizontal

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "notifications1"), style: .plain, target: self, action:  #selector(notificationHandAction))
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
    @objc func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //  MARK:  - Animation Top View
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                print("OPEN FIRST")
                
                self.rightbuttonSubscribeConstant.isActive = false
                self.centerbuttonSubscribeConstant.isActive = false
                self.topbuttonSubscribeConstant.isActive = true
                self.leftbuttonSubscribeConstant.isActive = true
                self.heightViewTop.constant = 400 + self.homeView.labelDescription.frame.height
                
                self.homeView.buttonSubscribe.isHidden = true
                self.homeView.labelFollow.isHidden = true

                   self.heightConstant.constant = 90
                   self.widthConstant.constant = 90
                   self.bottomConstraint.constant = -100
                   self.centerConstant.isActive = true
                   self.topConstraint.isActive = true
                   self.leftConstant.isActive = false
                   self.botConstant.isActive = false
                   self.leftWelcomeLabelConstant.isActive = false
                   self.topWelcomLabelConstant.constant = 80
                   self.rightWelcomLabel.isActive = false
                   self.centerWelcomeLabelConstant.isActive = true
                   self.homeView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 22)
                 
                self.homeView.imageLogoProfile.makeRounded()

            case .closed:
                print("CLOSE FIRST")
                self.rightbuttonSubscribeConstant.isActive = true
                self.centerbuttonSubscribeConstant.isActive = true
                self.topbuttonSubscribeConstant.isActive = false
                self.leftbuttonSubscribeConstant.isActive = false
                self.heightViewTop.constant = 450
                
                self.homeView.buttonSubscribe.isHidden = true
                self.homeView.labelFollow.isHidden = true
                
                self.bottomConstraint.constant = self.popupOffset
                   self.heightConstant.constant = 70
                   self.widthConstant.constant = 70
                   self.topConstraint.isActive = false
                   self.centerConstant.isActive = false
                   self.leftConstant.isActive = true
                   self.botConstant.isActive = true
                   self.rightWelcomLabel.isActive = true
                   self.topWelcomLabelConstant.isActive = true
                   self.leftWelcomeLabelConstant.isActive = true
                   self.topWelcomLabelConstant.constant = 0
                   self.centerWelcomeLabelConstant.isActive = false
                   self.homeView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 16)
                  
                
                
                
                self.homeView.imageLogoProfile.makeRounded()
            }
            self.view.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            
            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                print("OPEN SECOND")
                
                self.rightbuttonSubscribeConstant.isActive = false
                self.centerbuttonSubscribeConstant.isActive = false
                self.topbuttonSubscribeConstant.isActive = true
                self.leftbuttonSubscribeConstant.isActive = true
                self.heightViewTop.constant = 400 + self.homeView.labelDescription.frame.height

                   self.heightConstant.constant = 90
                   self.widthConstant.constant = 90
                   self.bottomConstraint.constant = -100
                   self.centerConstant.isActive = true
                   self.topConstraint.isActive = true
                   self.leftConstant.isActive = false
                   self.botConstant.isActive = false
                   self.leftWelcomeLabelConstant.isActive = false
                   self.rightWelcomLabel.isActive = false
                   self.topWelcomLabelConstant.constant = 80
                   self.centerWelcomeLabelConstant.isActive = true
                   self.homeView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 22)
                  
                
                self.homeView.buttonSubscribe.isHidden = false
                self.homeView.labelFollow.isHidden = true
                
                self.homeView.imageLogoProfile.makeRounded()

             
            case .closed:
                print("CLOSE SECOND")
                self.rightbuttonSubscribeConstant.isActive = true
                self.centerbuttonSubscribeConstant.isActive = true
                self.topbuttonSubscribeConstant.isActive = false
                self.leftbuttonSubscribeConstant.isActive = false
                self.heightViewTop.constant = 450
                
                self.bottomConstraint.constant = self.popupOffset
                   self.heightConstant.constant = 70
                   self.widthConstant.constant = 70
                   self.topConstraint.isActive = false
                   self.centerConstant.isActive = false
                   self.leftConstant.isActive = true
                   self.botConstant.isActive = true
                   self.rightWelcomLabel.isActive = true
                   self.topWelcomLabelConstant.isActive = true
                   self.leftWelcomeLabelConstant.isActive = true
                   self.topWelcomLabelConstant.constant = 0
                   self.centerWelcomeLabelConstant.isActive = false
                   self.homeView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 16)
                  
                
                self.homeView.buttonSubscribe.isHidden = false
                self.homeView.labelFollow.isHidden = false
                
                
                self.homeView.imageLogoProfile.makeRounded()
     
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
        // an animator for the title that is transitioning into view
        let inTitleAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn, animations: {
            switch state {
            case .open:
                print("OPEN FIR")
                self.homeView.labelVideo.alpha = 1
                self.homeView.buttonInstagram.alpha = 1
                self.homeView.buttonTwiter.alpha = 1
                self.homeView.buttonfaceBook.alpha = 1
                self.homeView.labelINTVideo.alpha = 1
                self.homeView.labelVideo.alpha = 1
                self.homeView.labelINTFollows.alpha = 1
                self.homeView.labelFollows.alpha = 1
                self.homeView.labelINTFolowers.alpha = 1
                self.homeView.labelFolowers.alpha = 1
                self.homeView.labelDescription.alpha = 1
                
               
                
               
            case .closed:
                print("Close FIR")
                self.homeView.labelVideo.alpha = 0
                self.homeView.buttonInstagram.alpha = 0
                self.homeView.buttonTwiter.alpha = 0
                self.homeView.buttonfaceBook.alpha = 0
                self.homeView.labelINTVideo.alpha = 0
                self.homeView.labelVideo.alpha = 0
                self.homeView.labelINTFollows.alpha = 0
                self.homeView.labelFollows.alpha = 0
                self.homeView.labelINTFolowers.alpha = 0
                self.homeView.labelFolowers.alpha = 0
                self.homeView.labelDescription.alpha = 0
                
                
            }
        })
        inTitleAnimator.scrubsLinearly = false
        
        // an animator for the title that is transitioning out of view
        let outTitleAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            switch state {
                case .open:
                    print("OPEN Sec")
                    self.homeView.labelVideo.alpha = 1
                    self.homeView.buttonInstagram.alpha = 1
                    self.homeView.buttonTwiter.alpha = 1
                    self.homeView.buttonfaceBook.alpha = 1
                    self.homeView.labelINTVideo.alpha = 1
                    self.homeView.labelVideo.alpha = 1
                    self.homeView.labelINTFollows.alpha = 1
                    self.homeView.labelFollows.alpha = 1
                    self.homeView.labelINTFolowers.alpha = 1
                    self.homeView.labelFolowers.alpha = 1
                    self.homeView.labelDescription.alpha = 1
                
                 
             
                case .closed:
                    print("Close sec")
                    self.homeView.labelVideo.alpha = 0
                    self.homeView.buttonInstagram.alpha = 0
                    self.homeView.buttonTwiter.alpha = 0
                    self.homeView.buttonfaceBook.alpha = 0
                    self.homeView.labelINTVideo.alpha = 0
                    self.homeView.labelVideo.alpha = 0
                    self.homeView.labelINTFollows.alpha = 0
                    self.homeView.labelFollows.alpha = 0
                    self.homeView.labelINTFolowers.alpha = 0
                    self.homeView.labelFolowers.alpha = 0
                    self.homeView.labelDescription.alpha = 0
                
               
                   
                }
            })
        outTitleAnimator.scrubsLinearly = false
        
        // start all animators
        transitionAnimator.startAnimation()
        inTitleAnimator.startAnimation()
        outTitleAnimator.startAnimation()
        
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
        runningAnimators.append(inTitleAnimator)
        runningAnimators.append(outTitleAnimator)
        
    }

}

