//
//  PresentVC.swift
//  MakeStep
//
//  Created by novotorica on 09.07.2021.
//


import Combine
import UIKit
import AVKit

class PresentVC: UIViewController, ClassBDelegate, CustomSegmentedControlDelegate, ClassBVCDelegate {
    
    func change(to index: Int) {
        print("segmentedControl index changed to \(index)")
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
        print("oldji")
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
 
            self.homeView.viewChat.anchor(top: self.homeView.labelStreamDescription.bottomAnchor,
                                     left: self.homeView.cardView.leftAnchor,
                                     right: self.homeView.cardView.rightAnchor,
                                     bottom: self.homeView.cardView.bottomAnchor,
                                     paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
            self.homeView.viewChat.removeFromSuperview()
            self.homeView.viewChat.layoutIfNeeded()
            
            self.controller.view.frame = CGRect(x: 0, y: 0, width: self.homeView.viewChat.frame.width, height: 0)
            self.controller.view.layoutIfNeeded()
          
                }, completion: { (finished) -> Void in
                    self.homeView.buttonChat.setTitle("Comments", for: .normal)
                    self.t = true
                    self.controller.view.removeFromSuperview()
                })
 
    }

    func changeUp(key: CGFloat) {
        print("OLLLL === \(key)")

    }
    func changeDown(key: CGFloat) {
        print("changeDown")

    }
    
    func changeBackground() {
        print("CLOSE PLAY")
        self.dismiss(animated: true, completion: nil)
    }
    var isPlaying: Bool = false
    var isButton: Bool = true
    var id: Int?
    var follow: String?
    
    let controller =  ChatVCPlayer()

    let homeView = PresentCode()
    var playerViewController: AVPlayerViewController?
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeUser: AnyCancellable?
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    var listBroadcast: [BroadcastResponce] = []
    private let refreshControl = UIRefreshControl()
    var  playerContainerView: PlayerContainerView?
  
    var Url: String?
    var playPauseButton: PlayPauseButton!
    var user: User?
    
    var t:Bool = true

    override  var shouldAutorotate: Bool {
        print(t)
        return t
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        
        if t {
            return .portrait
                        
        } else {
            return .all
            
        }
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
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
        loadPlayer()
        makeNavItem()
        homeView.imageLogoProfile.makeRounded()
        guard let id = id ,let live = follow else { return }
        bindingUser(id: id)
       // self.homeView.labelEye.text = follow!
      //  guard let us = user else { return }
      //  setUserProfile(user: us)
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        navigationItem.largeTitleDisplayMode = .always
        homeView.segmentControll.setButtonTitles(buttonTitles: ["Videos "," Timetable"])
        homeView.segmentControll.delegate = self
        homeView.segmentControll.backgroundColor = UIColor(hexString: "#F6F6F6")
        actionButton ()
        self.view.addSubview(self.homeView.viewChat)
       // controller.delegate = self
        SocketIOManager.sharedInstance.getTokenChat()
        
        let token = UserDefaults.standard.string(forKey: "tokenChat")
        let broadcastId = UserDefaults.standard.string(forKey: Constants.broadcastID)
        let chanelId = UserDefaults.standard.string(forKey: Constants.chanellID)
        
        print("GGGGGG=====\(token)\n JJJJJJ=====\(broadcastId)\n  KKKKKKK=====\(chanelId)")
        
        homeView.imagePromo.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(actionBut(sender:))))


    }
    func actionButton () {
        homeView.buttonLandScape.addTarget(self, action: #selector(rightHandAction), for: .touchUpInside)
        homeView.buttonOnline.addTarget(self, action: #selector(actionOnline), for: .touchUpInside)
        homeView.buttonOffline.addTarget(self, action: #selector(actionOffline), for: .touchUpInside)
        homeView.buttonComing.addTarget(self, action: #selector(actionComming), for: .touchUpInside)
        homeView.buttonChat.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
    }

    @objc func actionOnline() {
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#3B58A4")
        homeView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.imagePromo.isHidden = false
        homeView.labelCategory.isHidden = false
        homeView.labelStreamDescription.isHidden = false
        homeView.labelStreamInfo.isHidden = false
        
        
       // bindingChanell(status: "ONLINE")
       // setUserProfile()
    }
    @objc func actionOffline() {
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonOffline.backgroundColor = UIColor(hexString: "#3B58A4")
        homeView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
       // bindingChanell(status: )
        homeView.imagePromo.isHidden = true
        homeView.labelCategory.isHidden = true
        homeView.labelStreamDescription.isHidden = true
        homeView.labelStreamInfo.isHidden = true
        
        
        binding(status: "OFFLINE")
      // setUserProfile()
    

    }
    @objc func actionComming() {
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonComing.backgroundColor = UIColor(hexString: "#3B58A4")
       // bindingChanell(status: "PLANNED")
        homeView.imagePromo.isHidden = true
        homeView.labelCategory.isHidden = true
        homeView.labelStreamDescription.isHidden = true
        homeView.labelStreamInfo.isHidden = true
        binding(status: "PLANNED")
       // setUserProfile()

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
            isButton = false
        } else {
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
               // let playerFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
                //
        let playerFrame = self.homeView.imagePromo.bounds
        playerViewController!.player = player
                player.rate = 1 //auto play
        playerViewController!.view.frame = playerFrame
        playerViewController!.showsPlaybackControls = false
        playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                  
                
        addChild(playerViewController!)
      //  self.player.fillMode = .resizeAspectFit
      //  playerViewController.mode
               // view.addSubview(playerViewController.view)
        homeView.imagePromo.addSubview(playerViewController!.view)

        playerViewController!.didMove(toParent: self)

              playPauseButton = PlayPauseButton()
              playPauseButton.avPlayer = player
        
        
            //  playPauseButton.vies = homeView.imagePromo
            //  playPauseButton.vc = PresentVC()
              homeView.imagePromo.addSubview(playPauseButton)
              homeView.imagePromo.addSubview(homeView.buttonLandScape)
              homeView.buttonLandScape.anchor( right: homeView.imagePromo.rightAnchor, bottom: homeView.imagePromo.bottomAnchor, paddingRight: 20, paddingBottom: 20,width: 30,height: 30)
        
              homeView.imagePromo.addSubview(homeView.buttonSetting)
              homeView.buttonSetting.anchor( right: homeView.buttonLandScape.leftAnchor, bottom: homeView.imagePromo.bottomAnchor, paddingRight: 10, paddingBottom: 20,width: 30,height: 30)
        
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
        
        self.homeView.labelEye.text = "1"
            
        
               let tim : Float64 = CMTimeGetSeconds((player.currentItem?.asset.duration)!)
        print("TIM=====\(tim)")
        
               homeView.labelTimer.text = String(format: "\(tim.format(using: [.hour, .minute, .second])!)")
//              DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                        self.hidePlayerButtonsOnPlay()
//               }
        
              playPauseButton.setup(in: self)
        
//        let videoURL = URL(string: Url!)
//        let player = AVPlayer(url: videoURL!)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//
//      //  homeView.imagePromo.addSubview(self.p)
//                self.present(playerViewController, animated: true) {
//                    playerViewController.player!.play()
//                }
        
//        self.playerContainerView = Bundle.main.loadNibNamed("videoPlayerContainerNib", owner: self, options: nil)?.first as? PlayerContainerView
//
//        self.playerContainerView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//
//       // self.playerContainerView?.frame = homeView.imagePromo.bounds
//       // homeView.imagePromo.addSubview(self.playerContainerView!)
//        self.view.addSubview(self.playerContainerView!)
//        self.playerContainerView?.initializeView()
//        self.playerContainerView?.link = Url
//        self.playerContainerView?.delegate = self
//
//        self.playerContainerView?.minimizedOrigin = {
//            let x = UIScreen.main.bounds.width/2
//            let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32)
//            let coordinate = CGPoint.init(x: x, y: y)
//            return coordinate
//        }()
//        self.playerContainerView?.initializeView()
    
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
        
            playPauseButton.updateUI()
           if UIDevice.current.orientation.isLandscape {
               print("Landscape ===== \(t)")
            self.homeView.buttonChat.setTitle("", for: .normal)
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                    
                    self.view.setNeedsLayout()
                    self.homeView.imagePromo.fillFull(for: self.view)
                    self.view.setNeedsLayout()

                },completion: nil)
           // self.view.setNeedsLayout()
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.isHidden = true
            homeView.imageLogoProfile.isHidden = true
//            view.needsUpdateConstraints()
            isPlaying = true
            self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill

           } else {
               print("Portrait")
            self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill//resizeAspect

           }
       }
    
    @objc
    func rightHandAction() {
        
       // self.homeView.buttonSetting.removeFromSuperview()
       // self.view.layoutIfNeeded()
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        if isPlaying {
          
            isPlaying = false

            navigationController?.navigationBar.isHidden = false
            tabBarController?.tabBar.isHidden = false
            homeView.imageLogoProfile.isHidden = false

            
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                    
//                    self.homeView.imagePromo.removeFromSuperview()
//                    self.homeView.imagePromo.anchor(top: self.homeView.labelStreamDescription.bottomAnchor,
//                                                    left: self.homeView.cardView.leftAnchor,
//                                                    right: self.homeView.cardView.rightAnchor,
//                                                    bottom: self.homeView.cardView.bottomAnchor,
//                                                    paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 25)
                    
                    self.navigationController?.popViewController(animated: true)
                    
                },completion: nil)

        } else {
            self.homeView.buttonChat.setTitle("", for: .normal)
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                    
                    self.view.setNeedsLayout()
                    self.homeView.imagePromo.fillFull(for: self.view)
                    self.view.setNeedsLayout()

                },completion: nil)
           // self.view.setNeedsLayout()
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.isHidden = true
            homeView.imageLogoProfile.isHidden = true
//            view.needsUpdateConstraints()
            isPlaying = true
        }
        
       // homeView.imagePromo.fillFull(for: view)
        print("right bar button action")
    }

    @objc
    func leftHandAction() {
        print("left bar button action")
    }
    //MARK: - Selectors
    @objc private func refreshAlbumList() {

       }
    @objc func rightBack() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //weak var viewChat: UIView!
    
    @objc func actionChat() {
        self.homeView.buttonChat.setTitle("", for: .normal)
        self.t = false
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            self.view.addSubview(self.homeView.viewChat)

            self.homeView.viewChat.anchor(top: self.homeView.viewTop.bottomAnchor,
                                     left: self.homeView.cardView.leftAnchor,
                                     right: self.homeView.cardView.rightAnchor,
                                     bottom: self.homeView.cardView.bottomAnchor,
                                     paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)

            self.view.layoutIfNeeded()
                }, completion: { (finished) -> Void in

                   // self.controller.view.removeFromSuperview()
                   // self.btnComments.setTitle("Comments", for: .normal)
                })
        
        
       let h =  navigationController?.navigationBar.frame.height
        

        slideInTransitioningDelegate.direction = .bottom
        slideInTransitioningDelegate.disableCompactHeight = true
        
        controller.transitioningDelegate = slideInTransitioningDelegate
        controller.modalPresentationStyle = .custom
        controller.navBar = h
        controller.view.frame = homeView.viewChat.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.delegate = self
        // Add the view controller to the container.
         addChild(controller)
        homeView.viewChat.backgroundColor = UIColor(hexString: "#F6F6F6")
        homeView.viewChat.addSubview(controller.view)
        controller.didMove(toParent: controller.self)
    }
    
 
    func binding(status: String) {
        takeBroadcast = fitMeetStream.getBroadcast(status: "ONLINE")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.refreshControl.endRefreshing()
                }
        })
    }
    func bindingUser(id: Int) {
        takeUser = fitMeetApi.getUserId(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil  {
                        self.user = response
                    print("RES ========\(response)")
                       self.setUserProfile(user: self.user!)
                }
        })
    }
    
   
}

