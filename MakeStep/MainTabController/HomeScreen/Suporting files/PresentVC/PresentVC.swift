//
//  PresentVC.swift
//  MakeStep
//
//  Created by novotorica on 09.07.2021.
//


import Combine
import UIKit
import AVKit
import Presentr


class PresentVC: UIViewController, ClassBDelegate, CustomSegmentedControlDelegate, ClassBVCDelegate, ClassUserDelegate{
    
  
    
    func changeButton() {
        AppUtility.lockOrientation(.all)
        homeView.buttonChatUser.isHidden = false
        homeView.buttonChat.isHidden = false

    }
    
    
    var button = UIButton()
    
    func change(to index: Int) {
        if index == 0 {
            homeView.buttonOnline.isHidden = false
            homeView.buttonOffline.isHidden = false
            homeView.buttonComing.isHidden = false
            homeView.imagePromo.isHidden = false
            homeView.labelCategory.isHidden = false
            homeView.labelStreamInfo.isHidden = false
            homeView.labelStreamDescription.isHidden = false
            homeView.tableView.isHidden = true
        }
        if index == 1 {
            homeView.buttonOnline.isHidden = true
            homeView.buttonOffline.isHidden = true
            homeView.buttonComing.isHidden = true
            homeView.imagePromo.isHidden = true
            homeView.labelCategory.isHidden = true
            homeView.labelStreamInfo.isHidden = true
            homeView.labelStreamDescription.isHidden = true
            homeView.tableView.isHidden = false
        }
    }
    func changeBackgroundColor() {
        AppUtility.lockOrientation(.all)
        isLandscape = false
        
        if isLandscape {

        } else {
           
            self.homeView.buttonChatUser.isHidden = false
        }
        if isLand {
            self.button.isHidden = false
        } else {
           // homeView.buttonChat.isHidden = false
        }
    }

    func changeUp(key: CGFloat) {
        print("OLLLL === \(key)")

    }
    func changeDown(key: CGFloat) {
        print("changeDown")

    }
    
    func changeBackground() {
        self.dismiss(animated: true, completion: nil)
    }
    var isPlaying: Bool = false
    var isButton: Bool = true
    
    var isLandscape: Bool = true
    var isLand:Bool = true
    var isPortraiteFull: Bool = false
    
    var id: Int?
    var follow: String?
    var watch: Int?
    
    let controller =  ChatVCPlayer()

    let homeView = PresentCode()
    var playerViewController: AVPlayerViewController?
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    let actionChatTransitionManager = ActionTransishionChatManadger()
   // let actionPresentChat = ActionChatPresentationController()
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeUser: AnyCancellable?
    private var watcherMap: AnyCancellable?
    
    @Inject var fitMeetChannels: FitMeetChannels
    private var takeChannels: AnyCancellable?
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    var listBroadcast: [BroadcastResponce] = []
    
    var broadcast: BroadcastResponce?
    var  broadId: Int?
    
    private let refreshControl = UIRefreshControl()
   // var  playerContainerView: PlayerContainerView?
  
    var Url: String?
    var playPauseButton: PlayPauseButton!
    var user: User?
   // var swipeableFlexLayout: NSLayoutConstraint?

   // var swipeableView: SwipeableView! = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    //swipeableView.setTranslatesAutoresizingMaskIntoConstraints(false)

    //MARK - LifeCicle
    override func loadView() {
        view = homeView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        homeView.buttonChatUser.isHidden = true
        
        loadPlayer()
        makeNavItem()
        homeView.imageLogoProfile.makeRounded()
        guard let id = id ,let _ = follow else { return }
        
        bindingUser(id: id)
        guard let  broadId = broadId else { return }
        getMapWather(ids: [broadId])
       

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
        SocketWatcher.sharedInstance.closeConnection()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        navigationItem.largeTitleDisplayMode = .always
        homeView.segmentControll.setButtonTitles(buttonTitles: ["Videos "," Timetable"])
        homeView.segmentControll.delegate = self
        homeView.segmentControll.backgroundColor = UIColor(hexString: "#F6F6F6")
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#3B58A4")
        actionButton ()
        self.view.addSubview(self.homeView.viewChat)
        SocketIOManager.sharedInstance.getTokenChat()
        
        _ = UserDefaults.standard.string(forKey: "tokenChat")
        _ = UserDefaults.standard.string(forKey: Constants.broadcastID)
        _ = UserDefaults.standard.string(forKey: Constants.chanellID)
        
        
        homeView.imagePromo.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(actionBut(sender:))))
        guard let broadcast = broadcast else { return }        
        homeView.labelStreamDescription.text = broadcast.description

    }
    func actionButton () {
        homeView.buttonLandScape.addTarget(self, action: #selector(rightHandAction), for: .touchUpInside)
        homeView.buttonOnline.addTarget(self, action: #selector(actionOnline), for: .touchUpInside)
        homeView.buttonOffline.addTarget(self, action: #selector(actionOffline), for: .touchUpInside)
        homeView.buttonComing.addTarget(self, action: #selector(actionComming), for: .touchUpInside)
        homeView.buttonChat.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
        homeView.buttonSubscribe.addTarget(self, action: #selector(actionSubscribe), for: .touchUpInside)
        homeView.buttonChatUser.addTarget(self, action: #selector(actionUserOnline), for: .touchUpInside)
        button.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
      //  homeView.buttonHelp.addTarget(self, action: #selector(viewTopPresent), for: .touchUpInside)
       // homeView.viewTop.addGestureRecognizer(createSwipeGestureRecognizer(for: .up))
        homeView.viewTop.addGestureRecognizer(createSwipeGestureRecognizer(for: .down))
    
  
    }
    // MARK: - Helper Methods
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {

            switch sender.direction {
            case .up:
              
             print("U{PPPPP")
            default:
                break
            }

            UIView.animate(withDuration: 0.25) {
                
                
              //  self.homeView.viewTop.frame = frame
              //  self.homeView.viewTop.transform = CGAffineTransform(scaleX: x, y: y)
            }
    }
    
    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(viewTopPresent))
        swipeGestureRecognizer.direction = direction        
        return swipeGestureRecognizer
    }
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .topHalf)
        return presenter
    }()
    //MARK: - Selectors
    @objc func viewTopPresent(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
          
         print("U{PPPPP")
        case .down:
        
        print("~Down")
        default:
            break
        }

        UIView.animate(withDuration: 0.25) {
            
            
          //  self.homeView.viewTop.frame = frame
          //  self.homeView.viewTop.transform = CGAffineTransform(scaleX: x, y: y)
        }
        presenter.transitionType = TransitionType.coverVerticalFromTop
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.dismissOnSwipe = true
        presenter.dismissAnimated = true
        presenter.roundCorners = true
    
        let vc = Coach()
        vc.user = self.user
        customPresentViewController(presenter, viewController: vc, animated: true)

    }
    @objc func actionOnline() {
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#3B58A4")
        homeView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.imagePromo.isHidden = false
        homeView.labelCategory.isHidden = false
        homeView.labelStreamDescription.isHidden = false
        homeView.labelStreamInfo.isHidden = false
        homeView.buttonChat.isHidden = false

    }
    @objc func actionSubscribe() {
        homeView.buttonSubscribe.isSelected.toggle()
        
        if homeView.buttonSubscribe.isSelected {
            homeView.buttonSubscribe.backgroundColor = UIColor(hexString: "#3B58A4")
            homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
            let detailViewController = SubscribeVC()

            detailViewController.modalPresentationStyle = .custom
            detailViewController.transitioningDelegate = actionSheetTransitionManager
            
            present(detailViewController, animated: true)
        } else {
            homeView.buttonSubscribe.backgroundColor = UIColor(hexString: "FFFFFF")
            homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
        }

    }
    @objc func actionOffline() {
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonOffline.backgroundColor = UIColor(hexString: "#3B58A4")
        homeView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
      
        homeView.imagePromo.isHidden = true
        homeView.labelCategory.isHidden = true
        homeView.labelStreamDescription.isHidden = true
        homeView.labelStreamInfo.isHidden = true
        homeView.buttonChat.isHidden = true

    }
    @objc func actionComming() {
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonComing.backgroundColor = UIColor(hexString: "#3B58A4")
     
        homeView.imagePromo.isHidden = true
        homeView.labelCategory.isHidden = true
        homeView.labelStreamDescription.isHidden = true
        homeView.labelStreamInfo.isHidden = true
        homeView.buttonChat.isHidden = true

    }
    @objc func actionBut(sender:UITapGestureRecognizer) {
        
        
        if isButton {
            homeView.overlay.isHidden = true
            homeView.imageLive.isHidden = true
            homeView.labelLive.isHidden = true
            homeView.imageEye.isHidden = true
            homeView.labelEye.isHidden = true
            homeView.buttonSetting.isHidden = true
            homeView.buttonLandScape.isHidden = true
            playPauseButton.isHidden = true
            homeView.buttonChat.isHidden = true
            homeView.buttonChatUser.isHidden = true
            button.isHidden = true
            isButton = false
        } else {
            button.isHidden = false
            homeView.buttonChatUser.isHidden = false
            homeView.buttonChat.isHidden = false
            homeView.overlay.isHidden = false
            homeView.imageLive.isHidden = false
            homeView.labelLive.isHidden = false
            homeView.imageEye.isHidden = false
            homeView.labelEye.isHidden = false
            homeView.buttonSetting.isHidden = false
            homeView.buttonLandScape.isHidden = false
            playPauseButton.isHidden = false
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
                    backButton.setImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)

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
        
        
        self.navigationItem.rightBarButtonItems = [startItem,timeTable]
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
        
        homeView.welcomeLabel.text =  user.fullName
        homeView.setImage(image: user.avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
        guard let follow = user.channelFollowCount else { return }
        homeView.labelFollow.text = "Followers:" + "\(follow)"
    }
    
    func loadPlayer() {
                let videoURL = URL(string: Url!)
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
        
              view.addSubview(homeView.buttonLandScape)
              homeView.buttonLandScape.anchor( right: homeView.imagePromo.rightAnchor, bottom: homeView.imagePromo.bottomAnchor, paddingRight: 24, paddingBottom: 20,width: 40,height: 40)
            
        
              homeView.addSubview(homeView.buttonSetting)
              homeView.buttonSetting.anchor( right: homeView.buttonLandScape.leftAnchor, bottom: homeView.imagePromo.bottomAnchor, paddingRight: 5, paddingBottom: 25,width: 30,height: 30)
        
        homeView.addSubview(homeView.buttonChatUser)
        homeView.buttonChatUser.anchor( right: homeView.buttonSetting.leftAnchor, paddingRight: 5, width: 30, height: 30)
        homeView.buttonChatUser.centerY(inView: homeView.buttonSetting)
        
             homeView.imagePromo.addSubview(homeView.labelTimer)
             homeView.labelTimer.anchor( left: homeView.imagePromo.leftAnchor, bottom: homeView.imagePromo.bottomAnchor, paddingLeft: 10, paddingBottom: 20)
        
        homeView.imagePromo.addSubview(homeView.overlay)
        homeView.overlay.anchor(top: homeView.imagePromo.topAnchor,
                       left: homeView.imagePromo.leftAnchor,
                       paddingTop: 8, paddingLeft: 16,  width: 90, height: 24)
        
        homeView.imagePromo.addSubview(homeView.imageLive)
        homeView.imageLive.anchor( left: homeView.overlay.leftAnchor, paddingLeft: 6, width: 12, height: 12)
        homeView.imageLive.centerY(inView: homeView.overlay)
        
        homeView.imagePromo.addSubview(homeView.labelLive)
        homeView.labelLive.anchor( left: homeView.imageLive.rightAnchor, paddingLeft: 6)
        homeView.labelLive.centerY(inView: homeView.overlay)
        
        homeView.imagePromo.addSubview(homeView.imageEye)
        homeView.imageEye.anchor( left: homeView.labelLive.rightAnchor, paddingLeft: 6, width: 12, height: 12)
        homeView.imageEye.centerY(inView: homeView.overlay)
        
        homeView.imagePromo.addSubview(homeView.labelEye)
        homeView.labelEye.anchor( left: homeView.imageEye.rightAnchor, paddingLeft: 6)
        homeView.labelEye.centerY(inView: homeView.overlay)
        
        if isLand {
            //button
        } else {
            
        }
       
        
               let tim : Float64 = CMTimeGetSeconds((player.currentItem?.asset.duration)!)
               print("TIM=====\(tim)")
               playPauseButton.setup(in: self)

    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
        
            playPauseButton.updateUI()
            
        
           if UIDevice.current.orientation.isLandscape {
            print("Landscape")
           // isPortraiteFull = true
           // homeView.buttonChatUser.isHidden = false
            homeView.buttonChatUser.removeFromSuperview()
            isLand = true
            button.isHidden = false
            self.view.addSubview(button)
            
           
            
            
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                    
                    self.view.setNeedsLayout()
                    
                    self.homeView.buttonChat.removeFromSuperview()
                    
                    self.homeView.buttonLandScape.anchor( right: self.homeView.imagePromo.rightAnchor, bottom: self.homeView.imagePromo.bottomAnchor, paddingRight: 100, paddingBottom: 20,width: 45,height: 45)
                    self.homeView.buttonSetting.anchor( right: self.homeView.buttonLandScape.leftAnchor, bottom: self.homeView.imagePromo.bottomAnchor, paddingRight: 5, paddingBottom: 25,width: 30,height: 30)
                    
                    self.homeView.addSubview(self.homeView.buttonChatUser)
                    self.homeView.buttonChatUser.anchor(right: self.homeView.buttonSetting.leftAnchor,
                                                        paddingRight: 5)
                    
                    self.homeView.buttonChatUser.centerY(inView: self.homeView.buttonSetting)
                    
                    
                    self.button.anchor( right: self.homeView.buttonChatUser.leftAnchor, paddingRight: 10, width: 30, height: 30)
                    self.button.centerY(inView: self.homeView.buttonChatUser)
                    self.button.setImage( #imageLiteral(resourceName: "Group1-1"), for: .normal)
                    
                    self.playerViewController?.view.fillFull(for: self.view)//, insets: <#T##UIEdgeInsets#>)
                    self.view.setNeedsLayout()

                },completion: nil)
            self.view.setNeedsLayout()
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.isHidden = true
            homeView.imageLogoProfile.isHidden = true
            view.needsUpdateConstraints()
            isPlaying = true
            isLandscape = true
            self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
           } else {
               print("Portrait")
            isLand = false
            button.isHidden = true
           // actionChatTransitionManager.intWidth = 1
           // actionChatTransitionManager.intHeight = 0.7
            
            self.homeView.buttonLandScape.removeFromSuperview()
            self.homeView.buttonChat.removeFromSuperview()
           // isPlaying = false
            isLandscape = false
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                    
                   // self.view.setNeedsLayout()
                    
                    self.homeView.cardView.addSubview(self.homeView.buttonChat)
                    
                    
                    
                    if self.isPortraiteFull {
                        self.homeView.buttonChat.anchor(left:self.homeView.cardView.leftAnchor,
                                                        bottom: self.homeView.imagePromo.bottomAnchor,
                                                        paddingLeft: 10,paddingBottom: 20,width: 80, height: 30)
                        self.homeView.labelChat.text = "Comments"
                        
                        self.homeView.labelChat.textColor = .white
                        self.homeView.imageChat.image = #imageLiteral(resourceName: "arrow")
                    } else if self.isPortraiteFull == false {
                        
                        self.homeView.buttonChat.anchor(left:self.homeView.cardView.leftAnchor,
                                                        bottom: self.homeView.cardView.bottomAnchor,
                                                        paddingLeft: 10,paddingBottom: 20,width: 80, height: 30)
                        self.homeView.labelChat.text = "Comments"
                        self.homeView.labelChat.textColor = .black
                        self.homeView.imageChat.image = #imageLiteral(resourceName: "icons8-expand-arrow-100")
                    }
                    
                                       
                    self.homeView.buttonChat.addSubview(self.homeView.imageChat)
                    self.homeView.imageChat.anchor(left: self.homeView.buttonChat.leftAnchor,  paddingLeft: 10,width: 15,height: 15)
                    self.homeView.imageChat.centerY(inView: self.homeView.buttonChat)
       
                    self.homeView.imagePromo.addSubview(self.homeView.buttonLandScape)
                    self.homeView.buttonLandScape.anchor( right: self.homeView.imagePromo.rightAnchor, bottom: self.homeView.imagePromo.bottomAnchor, paddingRight: 24, paddingBottom: 20,width: 45,height: 45)
                    self.homeView.imagePromo.addSubview(self.homeView.buttonSetting)
                    self.homeView.buttonSetting.anchor( right: self.homeView.buttonLandScape.leftAnchor, bottom: self.homeView.imagePromo.bottomAnchor, paddingRight: 5, paddingBottom: 25 ,width: 30,height: 30)
                  //  self.homeView.imagePromo.fillFull(for: self.view)
                    self.view.setNeedsLayout()

                },completion: nil)
            self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill

           }
       }
    // MARK: - ButtonLandscape
    @objc func rightHandAction() {
        
        print("ISPLAYENG === \(isPlaying)")
       let bounds =  self.homeView.imagePromo.bounds
        print("IS BOUNDS  ====== \(bounds)")
        self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        if isPlaying {
            isPlaying = false
            isPortraiteFull = false
            self.view.layoutIfNeeded()
           
            navigationController?.navigationBar.isHidden = false
            tabBarController?.tabBar.isHidden = false
            self.homeView.imageLogoProfile.isHidden = false
            self.homeView.buttonSubscribe.isHidden = false
            self.homeView.segmentControll.isHidden = false
            self.homeView.buttonComing.isHidden = false
            self.homeView.buttonOnline.isHidden = false
            self.homeView.buttonOffline.isHidden = false
            self.homeView.viewTop.isHidden = false
            self.homeView.imagePromo.removeFromSuperview()
            self.homeView.labelCategory.removeFromSuperview()
            self.homeView.labelStreamInfo.removeFromSuperview()
            self.homeView.labelStreamDescription.removeFromSuperview()
            self.homeView.buttonChat.removeFromSuperview()
            self.homeView.buttonChatUser.removeFromSuperview()
            self.homeView.imageChat.removeFromSuperview()
            self.homeView.labelChat.removeFromSuperview()
            self.homeView.labelChat.textColor = .black
            self.homeView.imageChat.image = #imageLiteral(resourceName: "icons8-expand-arrow-100")
            self.homeView.viewTop.removeFromSuperview()
            
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                    
                    self.homeView.cardView.addSubview(self.homeView.viewTop)
                    if self.isLand {
                        self.homeView.viewTop.anchor(top: self.self.homeView.cardView.topAnchor,
                                                     left: self.homeView.cardView.leftAnchor,
                                                     right: self.homeView.cardView.rightAnchor,
                                                     paddingTop: 0, paddingLeft: 0, paddingRight: 0,height: 100)
                        
                    } else {
                        self.homeView.viewTop.anchor(top: self.self.homeView.cardView.topAnchor,
                                                     left: self.homeView.cardView.leftAnchor,
                                                     right: self.homeView.cardView.rightAnchor,
                                                     paddingTop: 44, paddingLeft: 0, paddingRight: 0,height: 100)
                    }
                   

                    
                    self.homeView.cardView.addSubview(self.homeView.imagePromo)
                    self.homeView.imagePromo.anchor(top: self.homeView.buttonComing.bottomAnchor,
                                                  left: self.homeView.cardView.leftAnchor,
                                                  right: self.homeView.cardView.rightAnchor,
                                                  paddingTop: 15, paddingLeft: 0, paddingRight: 0, height: 208)
                    
                    self.homeView.cardView.addSubview(self.homeView.labelCategory)
                    self.homeView.labelCategory.anchor(top: self.homeView.imagePromo.bottomAnchor,
                                         left: self.homeView.cardView.leftAnchor, paddingTop: 11, paddingLeft: 16)
                    
                    self.homeView.cardView.addSubview(self.homeView.labelStreamInfo)
                    self.homeView.labelStreamInfo.anchor(top: self.homeView.labelCategory.bottomAnchor,
                                                         left: self.homeView.cardView.leftAnchor,
                                           paddingTop: 9, paddingLeft: 16)
                    
                    self.homeView.cardView.addSubview(self.homeView.labelStreamDescription)
                    self.homeView.labelStreamDescription.anchor(top: self.homeView.labelStreamInfo.bottomAnchor,
                                                                left: self.homeView.cardView.leftAnchor,
                                                                right: self.homeView.cardView.rightAnchor,
                                                  paddingTop: 4, paddingLeft: 16, paddingRight: 16)
                    
                    self.homeView.cardView.addSubview(self.homeView.buttonChat)
                    self.homeView.buttonChat.anchor(left:self.homeView.cardView.leftAnchor,bottom: self.homeView.cardView.bottomAnchor, paddingLeft: 15,paddingBottom: 55,width: 80, height: 30)
                    
                    self.homeView.buttonChat.addSubview(self.homeView.imageChat)
                    
                    self.homeView.imageChat.anchor(left: self.homeView.buttonChat.leftAnchor,  paddingLeft: 10,width: 15,height: 15)
                    self.homeView.imageChat.centerY(inView: self.homeView.buttonChat)
                    
                    self.homeView.buttonChat.addSubview(self.homeView.labelChat)
                    self.homeView.labelChat.anchor( left: self.homeView.imageChat.rightAnchor, paddingLeft: 10)
                    self.homeView.labelChat.centerY(inView: self.homeView.buttonChat)
                    
                  
                  
                    AppUtility.lockOrientation(.all, andRotateTo: .portrait)
                    self.isPortraiteFull = false
                    self.view.layoutIfNeeded()
                },completion: nil)
        } else {
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
        homeView.buttonSetting.isHidden = true
        homeView.buttonLandScape.isHidden = true
        playPauseButton.isHidden = true
        isButton = false
        homeView.buttonChat.isHidden = true
        homeView.buttonChatUser.isHidden = true

        let chatVC = UserVC()
        guard let id = broadcast?.id,let channel = broadcast?.channelIds?.first  else { return }
        chatVC.broadcastId = "\(id)"
        chatVC.chanellId = "\(channel)"
        chatVC.delegate = self
        
        chatVC.transitioningDelegate = actionChatTransitionManager
        chatVC.modalPresentationStyle = .custom
        if isLand {
            button.isHidden = true
            actionChatTransitionManager.intWidth = 0.5
            actionChatTransitionManager.intHeight = 1
            present(chatVC, animated: true, completion: nil)
        } else {
            actionChatTransitionManager.intWidth = 1
            actionChatTransitionManager.intHeight = 0.7
            actionChatTransitionManager.isLandscape = isLandscape
            present(chatVC, animated: true)
        }
    }
    
    
    // MARK: - ActionChat
    @objc func actionChat(sender:UITapGestureRecognizer) {
        self.button.isHidden = true
        self.homeView.buttonChatUser.isHidden = true
        if isPlaying {
            homeView.overlay.isHidden = true
            homeView.imageLive.isHidden = true
            homeView.labelLive.isHidden = true
            homeView.imageEye.isHidden = true
            homeView.labelEye.isHidden = true
            homeView.buttonSetting.isHidden = true
            homeView.buttonLandScape.isHidden = true
            playPauseButton.isHidden = true
            isButton = false
            homeView.buttonChat.isHidden = true
            
            let detailViewController = ChatVCPlayer()
            detailViewController.modalPresentationStyle = .custom
            detailViewController.transitioningDelegate = actionChatTransitionManager
            detailViewController.broadcast = broadcast
            detailViewController.delegate = self
            detailViewController.color = .clear

            if isLand {
                actionChatTransitionManager.intWidth = 0.5
                actionChatTransitionManager.intHeight = 1
                actionChatTransitionManager.isLandscape = isLand
                detailViewController.chatView.buttonChat.isHidden = true
                detailViewController.chatView.buttonComm.isHidden = true
                detailViewController.chatView.buttonCloseChat.isHidden = false
                present(detailViewController, animated: true)
                //transitionVc(vc: detailViewController, duration: 0.5, type: .fromRight)
            } else {
                actionChatTransitionManager.intWidth = 1
                actionChatTransitionManager.intHeight = 0.7
                actionChatTransitionManager.isLandscape = isLand
                detailViewController.chatView.buttonChat.isHidden = false
                detailViewController.chatView.buttonComm.isHidden = false
                detailViewController.chatView.buttonCloseChat.isHidden = true
                present(detailViewController, animated: true)
            }
            
        } else {
            AppUtility.lockOrientation(.portrait)
            
            let detailViewController = ChatVCPlayer()
            detailViewController.modalPresentationStyle = .custom
            detailViewController.transitioningDelegate = actionChatTransitionManager
            detailViewController.broadcast = broadcast
            detailViewController.delegate = self
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
                }
            })
        }
    
    
    
    func getMapWather(ids: [Int])  {
        watcherMap = fitMeetApi.getWatcherMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                   // print("WATCHERPresent======\(response.data["\(ids.first!)"]!)")
                    guard let watchers = response.data["\(ids.first!)"] else { return }
                   // self.loadPlayer()
                    self.homeView.labelEye.text = "\(watchers)"
                   // print("WATCH RETURN = \(self.watch)")
                        
                }
            })
       }
    
}

