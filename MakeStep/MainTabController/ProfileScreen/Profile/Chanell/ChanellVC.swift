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
        }
        if index == 1 {
            profileView.buttonOnline.isHidden = true
            profileView.buttonOffline.isHidden = true
            profileView.buttonComing.isHidden = true
            profileView.imagePromo.isHidden = true
            profileView.labelCategory.isHidden = true
            profileView.labelStreamInfo.isHidden = true
            profileView.labelStreamDescription.isHidden = true
            profileView.tableView.isHidden = false
        }
   
    }
    private let popupOffset: CGFloat = -350
    private var bottomConstraint = NSLayoutConstraint()
    
    private var topConstraint = NSLayoutConstraint()
    private var leftConstant = NSLayoutConstraint()
    private var botConstant = NSLayoutConstraint()
    private var centerConstant = NSLayoutConstraint()
    
    private var heightConstant = NSLayoutConstraint()
    private var widthConstant = NSLayoutConstraint()
    
    private var topWelcomLabelConstant = NSLayoutConstraint()
    private var leftWelcomeLabelConstant = NSLayoutConstraint()
    private var centerWelcomeLabelConstant = NSLayoutConstraint()
    private var rightWelcomLabel = NSLayoutConstraint()
    
    private var topOverlayConstant = NSLayoutConstraint()
    private var rightLandscape = NSLayoutConstraint()
    
    private var topbuttonSubscribeConstant = NSLayoutConstraint()
    private var leftbuttonSubscribeConstant = NSLayoutConstraint()
    private var rightbuttonSubscribeConstant = NSLayoutConstraint()
    private var centerbuttonSubscribeConstant = NSLayoutConstraint()
    
    private var bottomButtonChatConstant = NSLayoutConstraint()
    
    
    let profileView = ChanellCode()
    private var take: AnyCancellable?
    private var takeChanell: AnyCancellable?
    private var followBroad: AnyCancellable?
    
    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var firMeetChanell: FitMeetChannels
    @Inject var fitMeetStream: FitMeetStream
    var user: Users?
    var brodcast: [BroadcastResponce] = []
    var indexButton: Int = 0
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    var url: String?
    var usersd = [Int: User]()

    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
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
        profileView.segmentControll.setButtonTitles(buttonTitles: ["Videos"])//," Timetable"
        profileView.segmentControll.delegate = self
       // profileView.tableView.isHidden = true
        actionOnline()
        layout()
        profileView.viewTop.addGestureRecognizer(panRecognizer)
        makeTableView()
      //  profileView.tableView.dataSource = self
      //  profileView.tableView.delegate = self
      //  profileView.buttonOnline.isHidden = true
       // profileView.buttonOffline.isHidden = true
      //  profileView.buttonComing.isHidden = true
        profileView.imagePromo.isHidden = true
        profileView.labelCategory.isHidden = true
        profileView.labelStreamInfo.isHidden = true
        profileView.labelStreamDescription.isHidden = true
        profileView.tableView.isHidden = false
        
      //  let bundle = Bundle(for: TimelineTableViewCell.self)
      //  let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
      //  let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
      //      bundle: Bundle(url: nibUrl!)!)
      //  self.profileView.tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        guard let userId = user?.id else { return }
        bindingChanell(status: "ONLINE", userId: "\(userId)")
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
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        profileView.imageLogoProfile.makeRounded()
        //layout()
        setUserProfile()
        
        
       

    }
    private func layout() {
        profileView.viewTop.translatesAutoresizingMaskIntoConstraints = false
        profileView.imageLogoProfile.translatesAutoresizingMaskIntoConstraints = false
        profileView.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        profileView.labelFollow.translatesAutoresizingMaskIntoConstraints = false
        profileView.buttonSubscribe.translatesAutoresizingMaskIntoConstraints = false
        profileView.buttonHelpCoach.translatesAutoresizingMaskIntoConstraints = false
     
     view.addSubview(profileView.viewTop)
     view.addSubview(profileView.imageLogoProfile)
     view.addSubview(profileView.welcomeLabel)
     view.addSubview(profileView.labelFollow)
        
        view.addSubview(profileView.buttonHelpCoach)
        
        view.addSubview(profileView.buttonSubscribe)
        view.addSubview(profileView.buttonFollow)
        view.addSubview(profileView.buttonInstagram)
        view.addSubview(profileView.buttonTwiter)
        view.addSubview(profileView.buttonfaceBook)
        view.addSubview(profileView.labelINTVideo)
        view.addSubview(profileView.labelVideo)
        view.addSubview(profileView.labelINTFollows)
        view.addSubview(profileView.labelFollows)
        view.addSubview(profileView.labelINTFolowers)
        view.addSubview(profileView.labelFolowers)
        view.addSubview(profileView.labelDescription)

//        profileView.viewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        profileView.viewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//     bottomConstraint = profileView.viewTop.topAnchor.constraint(equalTo: view.topAnchor, constant: -400)
//     bottomConstraint.isActive = true
//        profileView.viewTop.heightAnchor.constraint(equalToConstant: 500).isActive = true
//
//        profileView.labelFollow.bottomAnchor.constraint(equalTo: profileView.imageLogoProfile.bottomAnchor, constant: 0).isActive = true
//        profileView.labelFollow.leadingAnchor.constraint(equalTo: profileView.imageLogoProfile.trailingAnchor, constant: 12).isActive = true
//
//
//     topWelcomLabelConstant = profileView.welcomeLabel.topAnchor.constraint(equalTo: profileView.imageLogoProfile.topAnchor, constant: 0)
//     topWelcomLabelConstant.isActive = true
//
//     leftWelcomeLabelConstant = profileView.welcomeLabel.leadingAnchor.constraint(equalTo: profileView.imageLogoProfile.trailingAnchor, constant: 15)
//     leftWelcomeLabelConstant.isActive = true
//
//     centerWelcomeLabelConstant = profileView.welcomeLabel.centerXAnchor.constraint(equalTo: profileView.cardView.centerXAnchor)
//     centerWelcomeLabelConstant.isActive = false
//
//
//     leftConstant = profileView.imageLogoProfile.leadingAnchor.constraint(equalTo: profileView.viewTop.leadingAnchor, constant: 20)
//     leftConstant.isActive = true
//
//
//     botConstant = profileView.imageLogoProfile.bottomAnchor.constraint(equalTo: profileView.viewTop.bottomAnchor, constant: -20)
//     botConstant.isActive = true
//
//     topConstraint = profileView.imageLogoProfile.topAnchor.constraint(equalTo: profileView.viewTop.topAnchor, constant: 120)
//     topConstraint.isActive = false
//
//     centerConstant = profileView.imageLogoProfile.centerXAnchor.constraint(equalTo: profileView.viewTop.centerXAnchor)
//     centerConstant.isActive = false
//
//     heightConstant = profileView.imageLogoProfile.heightAnchor.constraint(equalToConstant: 70)
//     heightConstant.isActive = true
//     widthConstant = profileView.imageLogoProfile.widthAnchor.constraint(equalToConstant: 70)
//     widthConstant.isActive = true
        profileView.viewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileView.viewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = profileView.viewTop.topAnchor.constraint(equalTo: view.topAnchor, constant: popupOffset)
        bottomConstraint.isActive = true
        profileView.viewTop.heightAnchor.constraint(equalToConstant: 450).isActive = true

        profileView.labelFollow.bottomAnchor.constraint(equalTo: profileView.imageLogoProfile.bottomAnchor, constant: 0).isActive = true
        profileView.labelFollow.leadingAnchor.constraint(equalTo: profileView.imageLogoProfile.trailingAnchor, constant: 15).isActive = true
        

       // topWelcomLabelConstant = homeView.welcomeLabel.topAnchor.constraint(equalTo: homeView.imageLogoProfile.topAnchor, constant: 0)
        topWelcomLabelConstant = profileView.welcomeLabel.centerYAnchor.constraint(equalTo: profileView.imageLogoProfile.centerYAnchor, constant: 0)
        topWelcomLabelConstant.isActive = true
        
        rightWelcomLabel = profileView.welcomeLabel.trailingAnchor.constraint(equalTo: profileView.buttonSubscribe.leadingAnchor, constant: -5)
        rightWelcomLabel.isActive = true
        
        leftWelcomeLabelConstant = profileView.welcomeLabel.leadingAnchor.constraint(equalTo: profileView.imageLogoProfile.trailingAnchor, constant: 15)
        leftWelcomeLabelConstant.isActive = true
        
        centerWelcomeLabelConstant = profileView.welcomeLabel.centerXAnchor.constraint(equalTo: profileView.cardView.centerXAnchor)
        centerWelcomeLabelConstant.isActive = false
        

        leftConstant = profileView.imageLogoProfile.leadingAnchor.constraint(equalTo: profileView.viewTop.leadingAnchor, constant: 20)
        leftConstant.isActive = true
        
        
        botConstant = profileView.imageLogoProfile.bottomAnchor.constraint(equalTo: profileView.viewTop.bottomAnchor, constant: -20)
        botConstant.isActive = true
        
        topConstraint = profileView.imageLogoProfile.topAnchor.constraint(equalTo: profileView.viewTop.topAnchor, constant: 120)
        topConstraint.isActive = false
        
        centerConstant = profileView.imageLogoProfile.centerXAnchor.constraint(equalTo: profileView.viewTop.centerXAnchor)
        centerConstant.isActive = false
        
        heightConstant = profileView.imageLogoProfile.heightAnchor.constraint(equalToConstant: 70)
        heightConstant.isActive = true
        widthConstant = profileView.imageLogoProfile.widthAnchor.constraint(equalToConstant: 70)
        widthConstant.isActive = true

        
        topbuttonSubscribeConstant = profileView.buttonSubscribe.topAnchor.constraint(equalTo: profileView.welcomeLabel.bottomAnchor, constant: 20)
        topbuttonSubscribeConstant.isActive = false
        leftbuttonSubscribeConstant = profileView.buttonSubscribe.leadingAnchor.constraint(equalTo: profileView.viewTop.leadingAnchor, constant: 18)
        leftbuttonSubscribeConstant.isActive = false
        
        rightbuttonSubscribeConstant = profileView.buttonSubscribe.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -10)
        rightbuttonSubscribeConstant.isActive = true
        centerbuttonSubscribeConstant = profileView.buttonSubscribe.centerYAnchor.constraint(equalTo: profileView.imageLogoProfile.centerYAnchor)
        centerbuttonSubscribeConstant.isActive = true
        
        
        profileView.buttonSubscribe.anchor( width: 90, height: 28)
        profileView.buttonFollow.anchor( width: 90, height: 28)
        
        
        profileView.buttonFollow.anchor(top: profileView.welcomeLabel.bottomAnchor, paddingTop: 20, width: 102, height: 28)
        profileView.buttonFollow.centerX(inView: profileView.viewTop)
 
       
        profileView.buttonInstagram.anchor(  right: profileView.cardView.rightAnchor,paddingRight: 17, width: 28, height: 28)
        profileView.buttonInstagram.centerY(inView: profileView.buttonSubscribe)
        
        
        
        profileView.buttonTwiter.anchor(right: profileView.buttonInstagram.leftAnchor,paddingRight: 8,  width: 28, height: 28)
        profileView.buttonTwiter.centerY(inView: profileView.buttonInstagram)

        
        profileView.buttonfaceBook.anchor( right: profileView.buttonTwiter.leftAnchor, paddingRight: 8, width: 28, height: 28)
        profileView.buttonfaceBook.centerY(inView: profileView.buttonInstagram)
        
        
 
       // homeView.labelVideo.alpha = 0
        self.profileView.buttonFollow.alpha = 0
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
       
        
        profileView.labelINTVideo.anchor(top: profileView.buttonSubscribe.bottomAnchor, left: profileView.viewTop.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 100, height: 20)
         
        profileView.labelVideo.anchor(top: profileView.labelINTVideo.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        profileView.labelVideo.centerX(inView: profileView.labelINTVideo)
        
        
        profileView.labelINTFollows.anchor(top: profileView.buttonSubscribe.bottomAnchor, paddingTop: 16, width: 100, height: 16)
        profileView.labelINTFollows.centerX(inView: profileView.buttonFollow)
        
        
        profileView.labelFollows.anchor(top: profileView.labelINTVideo.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        profileView.labelFollows.centerX(inView: profileView.viewTop)
        
  
        profileView.labelINTFolowers.anchor(top: profileView.buttonSubscribe.bottomAnchor, right: profileView.viewTop.rightAnchor, paddingTop: 16, paddingRight:  16, width: 100, height: 20)
        
        profileView.labelFolowers.anchor(top: profileView.labelINTFolowers.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        profileView.labelFolowers.centerX(inView: profileView.labelINTFolowers)
        
        
        profileView.labelDescription.anchor(top: profileView.labelFollows.bottomAnchor, left: profileView.viewTop.leftAnchor, right: profileView.viewTop.rightAnchor,  paddingTop: 10, paddingLeft: 15, paddingRight: 5)
        
        profileView.buttonHelpCoach.anchor(bottom:profileView.viewTop.bottomAnchor,paddingBottom: -5,width: 40, height: 30)
        profileView.buttonHelpCoach.centerX(inView: profileView.viewTop)
        profileView.buttonHelpCoach.isUserInteractionEnabled = false

    
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
        profileView.buttonSubscribe.isSelected.toggle()
        
        if profileView.buttonSubscribe.isSelected {
            profileView.buttonSubscribe.backgroundColor = UIColor(hexString: "#3B58A4")
            profileView.buttonSubscribe.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
            profileView.buttonSubscribe.setTitle("Subscribe", for: .normal)

        } else {
            profileView.buttonSubscribe.backgroundColor = UIColor(hexString: "FFFFFF")
            profileView.buttonSubscribe.setTitle("Subscribers", for: .normal)
            profileView.buttonSubscribe.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
        }

    }
    @objc func actionFollow() {
        profileView.buttonFollow.isSelected.toggle()
        
        if profileView.buttonFollow.isSelected {
            profileView.buttonFollow.backgroundColor = UIColor(hexString: "#3B58A4")
            profileView.buttonFollow.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)

        } else {
            profileView.buttonFollow.backgroundColor = UIColor(hexString: "FFFFFF")
            profileView.buttonFollow.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
        }

    }
 
    func setUserProfile() {

        profileView.setImage(image: user?.avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
        guard let follow = user?.channelFollowCount,let fullName = user?.fullName!,let sub = user?.channelSubscribeCount!  else { return }
        profileView.labelFollow.text = "Followers:" + "\(follow)"
        self.profileView.welcomeLabel.text = fullName
        self.profileView.labelINTFollows.text = "\(follow)"
        self.profileView.labelINTFolowers.text = "\(sub)"
        self.profileView.labelDescription.text = " Welcome to my channel!\n My name is \(fullName)"
 
    }
    
    private func makeTableView() {
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
        profileView.tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseID)
        profileView.tableView.separatorStyle = .none
    }
    
    func actionButtonContinue() {
        profileView.buttonOnline.addTarget(self, action: #selector(actionOnline), for: .touchUpInside)
        profileView.buttonOffline.addTarget(self, action: #selector(actionOffline), for: .touchUpInside)
        profileView.buttonComing.addTarget(self, action: #selector(actionComming), for: .touchUpInside)
        profileView.buttonSubscribe.addTarget(self, action: #selector(actionSubscribe), for: .touchUpInside)
        profileView.buttonFollow.addTarget(self, action: #selector(actionFollow), for: .touchUpInside)
        
        

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
        bindingChanell(status: "OFFLINE", userId: "\(userId)")
        setUserProfile()
        indexButton = 1
        
      //  self.profileView.tableView.reloadData()
    

    }
    @objc func actionComming() {
        profileView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonComing.backgroundColor = UIColor(hexString: "#3B58A4")
        
        
        guard let userId = user?.id else { return }
        bindingChanell(status: "PLANNED", userId: "\(userId)")
        setUserProfile()
        indexButton = 2
        
       // self.profileView.tableView.reloadData()

    }

    func bindingChanell(status: String,userId: String) {
        takeChanell = fitMeetStream.getBroadcastPrivate(status: status, userId: userId)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.brodcast = []
                    self.brodcast = response.data!
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
        let inTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
            switch state {
            case .open:
                print("OPEN FIR")
                self.profileView.labelVideo.alpha = 0
                self.profileView.buttonFollow.alpha = 0
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
                
               
            case .closed:
                print("Close FIR")
                self.profileView.labelVideo.alpha = 0
                self.profileView.buttonFollow.alpha = 0
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
        let outTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
                case .open:
                    print("OPEN Sec")
                    self.profileView.labelVideo.alpha = 1
                    self.profileView.buttonFollow.alpha = 1
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
                    self.profileView.buttonFollow.alpha = 0
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

// MARK: - TableView for Timetable

//extension ChanellVC: UITableViewDataSource, UITableViewDelegate {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return data.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        guard let sectionData = data[section] else {
//            return 0
//        }
//        return sectionData.count
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Day " + String(describing: section + 1)
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
//
//        // Configure the cell...
//        guard let sectionData = data[indexPath.section] else {
//            return cell
//        }
//
//        let (timelinePoint, timelineBackColor, title, description, lineInfo, thumbnails, illustration) = sectionData[indexPath.row]
//        var timelineFrontColor = UIColor.clear
//        if (indexPath.row > 0) {
//            timelineFrontColor = sectionData[indexPath.row - 1].1
//        }
//        cell.timelinePoint = timelinePoint
//        cell.timeline.frontColor = timelineFrontColor
//        cell.timeline.backColor = timelineBackColor
//        cell.titleLabel.text = title
//        cell.descriptionLabel.text = description
//        cell.lineInfoLabel.text = lineInfo
//
//        if let thumbnails = thumbnails {
//            cell.viewsInStackView = thumbnails.map { thumbnail in
//                return UIImageView(image: UIImage(named: thumbnail))
//            }
//        }
//        else {
//            cell.viewsInStackView = []
//        }
//
//        if let illustration = illustration {
//            cell.illustrationImageView.image = UIImage(named: illustration)
//        }
//        else {
//            cell.illustrationImageView.image = nil
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let sectionData = data[indexPath.section] else {
//            return
//        }
//
//        print(sectionData[indexPath.row])
//    }
//

//}

