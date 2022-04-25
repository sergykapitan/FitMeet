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
import Loaf


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

class ChanellVC: SheetableViewController,Refreshable  {
   

    let videoVC = VideosVC()
    let timeTable = TimetableVC()
    let time = Timetable()
    var itemCount: Int = 0
    var isLoadingList : Bool = true
    var currentPage : Int = 1

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
    let selfId = UserDefaults.standard.string(forKey: Constants.userID)
    private var take: AnyCancellable?
    private var takePlan: AnyCancellable?
    private var takeChanell: AnyCancellable?
    private var followBroad: AnyCancellable?
    private var takeBroadcast: AnyCancellable?

    var myCell: PlayerViewCell?
    
    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var firMeetChanell: FitMeetChannels
    @Inject var fitMeetStream: FitMeetStream
    var user: User?
    var brodcast: [BroadcastResponce] = []
    var indexButton: Int = 0
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    var url: String?
    var usersd = [Int: User]()
    var userID = UserDefaults.standard.string(forKey: Constants.userID)
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)

    
    private var takeChannel: AnyCancellable?
    private var channels: AnyCancellable?
 
    @Inject var fitMeetChannel: FitMeetChannels
    var channel: ChannelResponce?
    var isButtton: Bool = false

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
        createTableView()
        layout()
        
        profileView.viewTop.addGestureRecognizer(panRecognizer)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    func refresh() {
        self.brodcast.removeAll()
        currentPage = 1
        guard let id = user?.id else { return }
        self.binding(id: "\(id)", page: currentPage)
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
        self.brodcast.removeAll()
        self.navigationController?.navigationBar.isHidden = false
        
        guard let id = user?.id else { return }
        bindingChannel(userId: id)
        self.binding(id: "\(id)", page: currentPage)
       
        AppUtility.lockOrientation(.portrait)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        profileView.imageLogoProfile.makeRounded()
        setUserProfile()
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
    func binding(id: String,page:Int) {
        takeBroadcast = fitMeetStream.getBroadcastPrivateChannel(userId: id, page: page)
              .mapError({ (error) -> Error in return error })
              .sink(receiveCompletion: { _ in }, receiveValue: { [self] response in
                  if response.data != nil  {
                      self.brodcast.append(contentsOf: response.data!)
                      let arrayUserId = self.brodcast.map{$0.userId!}
                      self.bindingUserMap(ids: arrayUserId)
                      self.profileView.tableView.reloadData()

                 }
                  if response.meta != nil {
                      guard let itemCount = response.meta?.itemCount else { return }
                      self.itemCount = itemCount
                      self.profileView.labelINTVideo.text = "\(self.itemCount)"
                  }
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
            animateTransitionIfNeeded(to: currentState.opposite, duration: 0.2)
            
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

        profileView.setImage(image: user?.resizedAvatar?["avatar_120"]?.png ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
        guard let follow = user?.channelFollowCount,let fullName = user?.fullName,let sub = user?.channelSubscribeCount!  else { return }
        profileView.labelFollow.text = "Followers:" + "\(follow)"
        self.profileView.welcomeLabel.text = fullName
        self.profileView.labelINTFollows.text = "\(follow)"
        self.profileView.labelINTFolowers.text = "\(sub)"
        self.profileView.labelDescription.text = channel?.description 
 
    }
    func actionButtonContinue() {
      
        profileView.buttonSubscribe.addTarget(self, action: #selector(actionSubscribe), for: .touchUpInside)
        profileView.buttonTwiter.addTarget(self, action: #selector(actionTwitter), for: .touchUpInside)
        profileView.buttonfaceBook.addTarget(self, action: #selector(actionFacebook), for: .touchUpInside)
        profileView.buttonInstagram.addTarget(self, action: #selector(actionInstagram), for: .touchUpInside)

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
    private func createTableView() {
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
        profileView.tableView.register(PlayerViewCell.self, forCellReuseIdentifier: PlayerViewCell.reuseID)
        profileView.tableView.separatorStyle = .none
        profileView.tableView.showsVerticalScrollIndicator = false
    }
    override func deleteBroadcast(with id: Int) {
        deleteBroad = fitMeetStreams.deleteBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil  {
                    self.view.addBlur()  
                    self.needUpdateAfterSuccessfullyCreate()
                    Loaf("Delete Broadcaast : " + response.name!, state: Loaf.State.success, location: .bottom, sender:  self).show(.short){ disType in
                        switch disType {
                        case .tapped: self.view.removeBlurA()
                        case .timedOut: self.view.removeBlurA()
                    }
                }
                   
            }
        })
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
                    backButton.anchor( width: 40, height: 30)
                    backButton.setBackgroundImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)

                   let stackView = UIStackView(arrangedSubviews: [backButton,titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .center
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
    func loadMoreItemsForList(){
            currentPage += 1
            guard let id = user?.id else { return }
            self.binding(id: "\(id)", page: currentPage)
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

}

