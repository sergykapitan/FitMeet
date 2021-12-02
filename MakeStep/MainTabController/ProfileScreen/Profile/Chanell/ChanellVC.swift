//
//  ChanellVC.swift
//  FitMeet
//
//  Created by novotorica on 29.06.2021.
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

class ChanellVC: UIViewController, CustomSegmentedControlDelegate, CustomSegmentedFullControlDelegate {
    
    var offsetObservation: NSKeyValueObservation?
    let videoVC = VideosVC()
    let timeTable = TimetableVC()

    func change(to index: Int) {
        
        print("segmentedControl index changed to \(index)")
        if index == 0 {
//            profileView.buttonOnline.isHidden = false
//            profileView.buttonOffline.isHidden = false
//            profileView.buttonComing.isHidden = false
//            profileView.imagePromo.isHidden = false
//            profileView.labelCategory.isHidden = false
//            profileView.labelStreamInfo.isHidden = false
//            profileView.labelStreamDescription.isHidden = false
//            profileView.tableView.isHidden = true
            
            removeAllChildViewController(timeTable)
            configureChildViewController(videoVC, onView: profileView.selfView )
            
//            guard let userID = id else { return }
//            buttonOffline.userId = userID
//            buttonOffline.user = self.user
        }
        if index == 1 {
//            profileView.buttonOnline.isHidden = true
//            profileView.buttonOffline.isHidden = true
//            profileView.buttonComing.isHidden = true
//            profileView.imagePromo.isHidden = true
//            profileView.labelCategory.isHidden = true
//            profileView.labelStreamInfo.isHidden = true
//            profileView.labelStreamDescription.isHidden = true
//            profileView.tableView.isHidden = false
            removeAllChildViewController(videoVC)
            configureChildViewController(timeTable, onView: profileView.selfView )
        }
   
    }
    let popupOffset: CGFloat = -350
    var bottomConstraint = NSLayoutConstraint()
    
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
    
    
    let profileView = ChanellCode()
    private var take: AnyCancellable?
    private var takeChanell: AnyCancellable?
    private var followBroad: AnyCancellable?
    private var taskStream: AnyCancellable?
    private var startStream: AnyCancellable?
    
    var myCell: PlayerViewCell?
    
    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var firMeetChanell: FitMeetChannels
    @Inject var fitMeetStream: FitMeetStream
    var user: Users?
    var brodcast: [BroadcastResponce] = []
    var indexButton: Int = 0
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    var url: String?
    var usersd = [Int: User]()
    var userID = UserDefaults.standard.string(forKey: Constants.userID)
    var broadcast:  BroadcastResponce?
    
   // var url: String? ??????????????
    var myuri: String?
    var myPublish: String?
    
    private var takeChannel: AnyCancellable?
    private var channels: AnyCancellable?
 
    @Inject var fitMeetChannel: FitMeetChannels
    var channel: ChannelResponce?
    
   
    
    var isButtton: Bool = false

//    override  var shouldAutorotate: Bool {
//        return false
//    }
//    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
    
    override func loadView() {
        super.loadView()
        view = profileView
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.profileView.imageLogoProfile.makeRounded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profileView.imageLogoProfile.makeRounded()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButtonContinue()
        makeNavItem()
        profileView.segmentControll.setButtonTitles(buttonTitles: ["Videos"," Timetable"])//,
        profileView.segmentControll.delegate = self
        
        actionOnline()
        layout()
        profileView.viewTop.addGestureRecognizer(panRecognizer)
        makeTableView()
        profileView.imagePromo.isHidden = true
        profileView.labelCategory.isHidden = true
        profileView.labelStreamInfo.isHidden = true
        profileView.labelStreamDescription.isHidden = true
        profileView.tableView.isHidden = false
        guard let userId = user?.id else { return }
        bindingChanell(status: "ONLINE", userId: "\(userId)")
        
        self.navigationController?.mmPlayerTransition.push.pass(setting: { (_) in
            
        })
        offsetObservation = profileView.tableView.observe(\.contentOffset, options: [.new]) { [weak self] (_, value) in
            guard let self = self, self.presentedViewController == nil else {return}
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.startLoading), with: nil, afterDelay: 0.2)
        }
        profileView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right:0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.updateByContentOffset()
            self?.startLoading()
        }
       
        profileView.mmPlayerLayer.fullScreenWhenLandscape = false
      
        profileView.mmPlayerLayer.getStatusBlock { [weak self] (status) in
            switch status {
            case .failed(let err):
                let alert = UIAlertController(title: "err", message: err.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            case .ready:
                print("Ready to Play")
            case .playing:
                print("Playing")
            case .pause:
                print("Pause")
            case .end:
                print("End")
            default: break
            }
        }
        profileView.mmPlayerLayer.getOrientationChange { (status) in
            print("Player OrientationChange \(status)")
        }
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
        profileView.segmentControll.backgroundColor = UIColor(hexString: "#F6F6F6")
        self.navigationController?.navigationBar.isHidden = false
        
        guard let id = user?.id else { return }
        bindingChannel(userId: id)
        AppUtility.lockOrientation(.portrait)
        configureChildViewController(videoVC, onView: profileView.selfView )
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        profileView.imageLogoProfile.makeRounded()
        setUserProfile()
        actionOffline()
       
    }
    deinit {
        offsetObservation?.invalidate()
        offsetObservation = nil
        print("ViewController deinit")
    }
    func bindingChannel(userId: Int?) {
        guard let id = userId else { return }
        takeChanell = fitMeetChannel.listChannelsPrivate(idUser: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil  {                    
                    self.channel = response.data.last
                }
        })
    }
   
    
    @objc fileprivate func startLoading() {
        self.updateByContentOffset()
        if self.presentedViewController != nil {
            return
        }
        // start loading video
        profileView.mmPlayerLayer.resume()
    }
    fileprivate func updateByContentOffset() {
        if profileView.mmPlayerLayer.isShrink {
            return
        }

        if let path = findCurrentPath(),
            self.presentedViewController == nil {
            self.updateCell(at: path)
        }
    }
    func findCurrentPath() -> IndexPath? {
        let p = CGPoint(x: profileView.tableView.frame.width/2, y: profileView.tableView.contentOffset.y + profileView.tableView.frame.width/2)
        return profileView.tableView.indexPathForRow(at: p)
    }

    func findCurrentCell(path: IndexPath) -> UITableViewCell {

        return profileView.tableView.cellForRow(at: path)!
    }
    fileprivate func updateCell(at indexPath: IndexPath) {
        if let cell = profileView.tableView.cellForRow(at: indexPath) as? PlayerViewCell, let playURL = cell.data?.streams?.first?.vodUrl {
            // this thumb use when transition start and your video dosent start
            profileView.mmPlayerLayer.thumbImageView.image = cell.backgroundImage.image
            // set video where to play
            profileView.mmPlayerLayer.playView = cell.backgroundImage
            let url = URL(string: playURL)////"http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4"
            //playURL
            profileView.mmPlayerLayer.set(url: url)
        }
    }
    func destrtoyMMPlayerInstance() {
        self.profileView.mmPlayerLayer.player?.pause()
        self.profileView.mmPlayerLayer.playView = nil
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
            let translation = recognizer.translation(in: profileView.viewTop)
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
            let yVelocity = recognizer.velocity(in: profileView.viewTop).y
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
        
        let vc = EdetChannelVC()
        vc.modalPresentationStyle = .fullScreen
        vc.user = self.user
        self.navigationController?.pushViewController(vc, animated: true)
 
    }

    

    func setUserProfile() {

        profileView.setImage(image: user?.avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
        guard let follow = user?.channelFollowCount,let fullName = user?.fullName,let sub = user?.channelSubscribeCount!  else { return }
        profileView.labelFollow.text = "Followers:" + "\(follow)"
        self.profileView.welcomeLabel.text = fullName
        self.profileView.labelINTFollows.text = "\(follow)"
        self.profileView.labelINTFolowers.text = "\(sub)"
        self.profileView.labelDescription.text = channel?.description //" Welcome to my channel!\n My name is \(fullName)"
 
    }
    
    private func makeTableView() {
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
        profileView.tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseID)
        profileView.tableView.register(PlayerViewCell.self, forCellReuseIdentifier: PlayerViewCell.reuseID)
        profileView.tableView.separatorStyle = .none
    }
    
    func actionButtonContinue() {
       // profileView.buttonOnline.addTarget(self, action: #selector(actionOnline), for: .touchUpInside)
        profileView.buttonOffline.addTarget(self, action: #selector(actionOffline), for: .touchUpInside)
        profileView.buttonComing.addTarget(self, action: #selector(actionComming), for: .touchUpInside)
        profileView.buttonSubscribe.addTarget(self, action: #selector(actionSubscribe), for: .touchUpInside)
        profileView.buttonTwiter.addTarget(self, action: #selector(actionTwitter), for: .touchUpInside)
        profileView.buttonfaceBook.addTarget(self, action: #selector(actionFacebook), for: .touchUpInside)
        profileView.buttonInstagram.addTarget(self, action: #selector(actionInstagram), for: .touchUpInside)
      //  profileView.buttonFollow.addTarget(self, action: #selector(actionFollow), for: .touchUpInside)     

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

    @objc func actionOnline() {
        profileView.buttonOnline.backgroundColor = UIColor(hexString: "#3B58A4")
        profileView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
        
       
        guard let userId = user?.id else { return }
        bindingChanell(status: "ONLINE", userId: "\(userId)")
        setUserProfile()
        indexButton = 0
        
      //  self.profileView.tableView.reloadData()
    }
    @objc func actionOffline() {
        profileView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonOffline.backgroundColor = UIColor(hexString: "#3B58A4")
        profileView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
       
        guard let userId = user?.id else { return }
       // bindingChanell(status: "OFFLINE", userId: "\(userId)")
        bindingChanellVOD(userId: "\(userId)")
        setUserProfile()
        indexButton = 1

    }
    @objc func actionComming() {
        profileView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonComing.backgroundColor = UIColor(hexString: "#3B58A4")
        
        profileView.mmPlayerLayer.invalidate()
        guard let userId = user?.id else { return }
        bindingChanell(status: "PLANNED", userId: "\(userId)")
        setUserProfile()
        indexButton = 2
        
       // self.profileView.tableView.reloadData()

    }
 

    func bindingChanell(status: String,userId: String) {
        takeChanell = fitMeetStream.getBroadcastPrivate(status: status, userId: "\(userId)")//20
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                
                    self.brodcast.removeAll()// = []
                   // self.brodcast = response.data!.reversed()
                    let convertedArray = response.data?.sorted{$0.scheduledStartDate?.compare($1.scheduledStartDate!) == .orderedDescending}
                    self.brodcast = convertedArray!
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.profileView.tableView.reloadData()
                }
           })
       }
    func bindingChanellVOD(userId: String) {
        takeChanell = fitMeetStream.getBroadcastPrivateVOD(userId: "\(userId)")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {

                    self.brodcast.removeAll()// = []
                    self.brodcast = response.data!.reversed()
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.profileView.tableView.reloadData()
                }
           })
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
    func bindingUserMap(ids: [Int])  {
        take = fitMeetApi.getUserIdMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.usersd = response.data
                    self.profileView.tableView.reloadData()
                }
          })
    }
 
    @objc func actionEditProfile() {

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
        
        
       // self.navigationItem.rightBarButtonItems = [startItem,timeTable]
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
                self.heightViewTop.constant = 400 + self.profileView.labelDescription.frame.height

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
                   self.profileView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 22)
                   self.profileView.labelFollow.isHidden = true
                self.profileView.imageLogoProfile.makeRounded()

            case .closed:
                print("CLOSE FIRST")
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
                   self.profileView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 16)
                   self.profileView.labelFollow.isHidden = false
                
                
                
                self.profileView.imageLogoProfile.makeRounded()
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
                self.heightViewTop.constant = 400 + self.profileView.labelDescription.frame.height

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
                   self.profileView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 22)
                   self.profileView.labelFollow.isHidden = true
                self.profileView.imageLogoProfile.makeRounded()

             
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
                   self.profileView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 16)
                   self.profileView.labelFollow.isHidden = false
                
                
                
                self.profileView.imageLogoProfile.makeRounded()
     
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
        // an animator for the title that is transitioning into view
        let inTitleAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn, animations: {
            switch state {
            case .open:
                print("OPEN FIR")
                self.profileView.labelVideo.alpha = 1
                self.profileView.buttonInstagram.alpha = 1
                self.profileView.buttonTwiter.alpha = 1
                self.profileView.buttonfaceBook.alpha = 1
                self.profileView.labelINTVideo.alpha = 1
                self.profileView.labelVideo.alpha = 1
                self.profileView.labelINTFollows.alpha = 1
                self.profileView.labelFollows.alpha = 1
                self.profileView.labelINTFolowers.alpha = 1
                self.profileView.labelFolowers.alpha = 1
                self.profileView.labelDescription.alpha = 1
                
               
            case .closed:
                print("Close FIR")
                self.profileView.labelVideo.alpha = 0
                self.profileView.buttonInstagram.alpha = 0
                self.profileView.buttonTwiter.alpha = 0
                self.profileView.buttonfaceBook.alpha = 0
                self.profileView.labelINTVideo.alpha = 0
                self.profileView.labelVideo.alpha = 0
                self.profileView.labelINTFollows.alpha = 0
                self.profileView.labelFollows.alpha = 0
                self.profileView.labelINTFolowers.alpha = 0
                self.profileView.labelFolowers.alpha = 0
                self.profileView.labelDescription.alpha = 0
            }
        })
        inTitleAnimator.scrubsLinearly = false
        
        // an animator for the title that is transitioning out of view
        let outTitleAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            switch state {
                case .open:
                    print("OPEN Sec")
                    self.profileView.labelVideo.alpha = 1
                    self.profileView.buttonInstagram.alpha = 1
                    self.profileView.buttonTwiter.alpha = 1
                    self.profileView.buttonfaceBook.alpha = 1
                    self.profileView.labelINTVideo.alpha = 1
                    self.profileView.labelVideo.alpha = 1
                    self.profileView.labelINTFollows.alpha = 1
                    self.profileView.labelFollows.alpha = 1
                    self.profileView.labelINTFolowers.alpha = 1
                    self.profileView.labelFolowers.alpha = 1
                    self.profileView.labelDescription.alpha = 1
             
                case .closed:
                    print("Close sec")
                    self.profileView.labelVideo.alpha = 0
                    self.profileView.buttonInstagram.alpha = 0
                    self.profileView.buttonTwiter.alpha = 0
                    self.profileView.buttonfaceBook.alpha = 0
                    self.profileView.labelINTVideo.alpha = 0
                    self.profileView.labelVideo.alpha = 0
                    self.profileView.labelINTFollows.alpha = 0
                    self.profileView.labelFollows.alpha = 0
                    self.profileView.labelINTFolowers.alpha = 0
                    self.profileView.labelFolowers.alpha = 0
                    self.profileView.labelDescription.alpha = 0
                   
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
    func nextView(broadcastId: Int )  {

        startStream = fitMeetStream.startBroadcastId(id: broadcastId)

            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let id = response.id  {
                    self.broadcast = response
                    UserDefaults.standard.set(self.broadcast?.id, forKey: Constants.broadcastID)
                    self.fetchStream(id: self.broadcast?.id, name: response.name)
 

                }
             })
         
         }
    func fetchStream(id:Int?,name: String?) {
        let UserId = UserDefaults.standard.string(forKey: Constants.userID)
        guard let id = id , let name = name , let userId = UserId  else{ return }
        let usId = Int(userId)
        guard let usID = usId else { return }
        taskStream = fitMeetStream.startStream(stream: StartStream(name: name, userId: usID , broadcastId: id))
            .mapError({ (error) -> Error in
                  print(error)
                   return error })
                 .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    guard let url = response.url else { return }
                    UserDefaults.standard.set(url, forKey: Constants.urlStream)
                    let twoString = self.removeUrl(url: url)
                    self.myuri = twoString.0
                    self.myPublish = twoString.1
                    self.url = url
                    print(response)
                  
                    
                    
                        let navVC = LiveStreamViewController()
                        navVC.modalPresentationStyle = .fullScreen
                        navVC.idBroad = id
                        guard let myuris = self.myuri,let myPublishh = self.myPublish else { return }
                        navVC.myuri = myuris
                        navVC.myPublish = myPublishh
                        self.present(navVC, animated: true, completion: nil)
                       // self.present(navVC, animated: true) {
                           
                      //  }
                    })
                }

    
    func removeUrl(url: String) -> (url:String,publish: String) {
        let fullUrlArr = url.components(separatedBy: "/")
        let myuri = fullUrlArr[0] + "//" + fullUrlArr[2] + "/" + fullUrlArr[3]
        let myPublish = fullUrlArr[4]
        return (myuri,myPublish)
    }
    
  

}
extension ChanellVC: MMPlayerFromProtocol {
    // when second controller pop or dismiss, this help to put player back to where you want
    // original was player last view ex. it will be nil because of this view on reuse view
    func backReplaceSuperView(original: UIView?) -> UIView? {
        guard let path = self.findCurrentPath() else {
            return original
        }
        
        let cell = self.findCurrentCell(path: path) as! PlayerViewCell
        return cell.backgroundImage
    }

    // add layer to temp view and pass to another controller
    var passPlayer: MMPlayerLayer {
        return self.profileView.mmPlayerLayer
    }
    func transitionWillStart() {
    }
    // show cell.image
    func transitionCompleted() {
        self.updateByContentOffset()
        self.startLoading()
    }
}
