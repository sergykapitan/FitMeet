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
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
      // // homeView.buttonChat.setTitle("Comments", for: .normal)
        homeView.labelChat.text = "Comments"
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
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    let actionChatTransitionManager = ActionTransishionChatManadger()
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeUser: AnyCancellable?
    
    @Inject var fitMeetChannels: FitMeetChannels
    private var takeChannels: AnyCancellable?
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    var listBroadcast: [BroadcastResponce] = []
    
    var broadcast: BroadcastResponce?
    
    private let refreshControl = UIRefreshControl()
   // var  playerContainerView: PlayerContainerView?
  
    var Url: String?
    var playPauseButton: PlayPauseButton!
    var user: User?


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
        guard let id = id ,let _ = follow else { return }
        bindingUser(id: id)
       
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
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
    }
    //MARK: - Selectors
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
             
        let playerFrame = self.homeView.imagePromo.bounds
        playerViewController!.player = player
                player.rate = 1 //auto play
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
        
             homeView.imagePromo.addSubview(homeView.labelTimer)
             homeView.labelTimer.anchor( left: homeView.imagePromo.leftAnchor, bottom: homeView.imagePromo.bottomAnchor, paddingLeft: 10, paddingBottom: 20)
        
        homeView.imagePromo.addSubview(homeView.overlay)
        homeView.overlay.anchor(top: homeView.imagePromo.topAnchor,
                       left: homeView.imagePromo.leftAnchor,
                       paddingTop: 8, paddingLeft: 16,  width: 110, height: 24)
        
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
        
       // self.homeView.labelEye.text = "1"
            
        
               let tim : Float64 = CMTimeGetSeconds((player.currentItem?.asset.duration)!)
               print("TIM=====\(tim)")
        
             //  homeView.labelTimer.text = String(format: "\(tim.format(using: [.hour, .minute, .second])!)")
        
                playPauseButton.setup(in: self)

    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
        
            playPauseButton.updateUI()
        
           if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            self.homeView.labelChat.textColor = .white
            self.homeView.imageChat.image = UIImage(named: "arrow")
       
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                    
                    self.view.setNeedsLayout()
                    self.homeView.buttonLandScape.anchor( right: self.homeView.imagePromo.rightAnchor, bottom: self.homeView.imagePromo.bottomAnchor, paddingRight: 100, paddingBottom: 20,width: 45,height: 45)
                    self.homeView.buttonSetting.anchor( right: self.homeView.buttonLandScape.leftAnchor, bottom: self.homeView.imagePromo.bottomAnchor, paddingRight: 5, paddingBottom: 25,width: 30,height: 30)
                    self.homeView.imagePromo.fillFull(for: self.view)
                    self.view.setNeedsLayout()

                },completion: nil)
            self.view.setNeedsLayout()
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.isHidden = true
            homeView.imageLogoProfile.isHidden = true
           // self.homeView.labelChat.textColor = .white
           // self.homeView.imageChat.image = #imageLiteral(resourceName: "Back11")
            view.needsUpdateConstraints()
            isPlaying = true
            self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
           } else {
               print("Portrait")
            self.homeView.labelChat.textColor = .white
            self.homeView.imageChat.image = UIImage(named: "arrow")
            self.homeView.buttonLandScape.removeFromSuperview()
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                    
                    self.view.setNeedsLayout()
                
                    self.homeView.imagePromo.addSubview(self.homeView.buttonLandScape)
                    self.homeView.buttonLandScape.anchor( right: self.homeView.imagePromo.rightAnchor, bottom: self.homeView.imagePromo.bottomAnchor, paddingRight: 24, paddingBottom: 20,width: 45,height: 45)
                    self.homeView.imagePromo.addSubview(self.homeView.buttonSetting)
                    self.homeView.buttonSetting.anchor( right: self.homeView.buttonLandScape.leftAnchor, bottom: self.homeView.imagePromo.bottomAnchor, paddingRight: 5, paddingBottom: 25 ,width: 30,height: 30)
                    self.homeView.imagePromo.fillFull(for: self.view)
                    self.view.setNeedsLayout()

                },completion: nil)
            self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill

           }
       }
    
    @objc func rightHandAction() {
        self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        if isPlaying {
            isPlaying = false
            self.view.layoutIfNeeded()
           
            navigationController?.navigationBar.isHidden = false
            tabBarController?.tabBar.isHidden = false
            self.homeView.imageLogoProfile.isHidden = false
            self.homeView.buttonSubscribe.isHidden = false
            self.homeView.viewTop.isHidden =  false
            self.homeView.segmentControll.isHidden = false
            self.homeView.buttonComing.isHidden = false
            self.homeView.buttonOnline.isHidden = false
            self.homeView.buttonOffline.isHidden = false

            self.view.setNeedsLayout()
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                            
                    self.navigationController?.popViewController(animated: true)
                    
                },completion: nil)
        } else {
            AppUtility.lockOrientation(.all, andRotateTo: .landscapeLeft)
          //  controller.dismiss(animated: true, completion: nil)
        }
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
    @objc func actionChat(sender:UITapGestureRecognizer) {
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
           // homeView.buttonChat.setTitle("", for: .normal)
            
            homeView.labelChat.text = ""
            homeView.imageChat.isHidden = true
            let detailViewController = ChatVCPlayer()
            detailViewController.modalPresentationStyle = .custom
            detailViewController.transitioningDelegate = actionChatTransitionManager
            detailViewController.broadcast = broadcast
            detailViewController.delegate = self
            detailViewController.color = .clear
            detailViewController.chatView.imageComm.image = UIImage(named: "arrow")
            detailViewController.chatView.buttonChat.isHidden = true
            
                   
                   present(detailViewController, animated: true)
            
        } else {
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
            
            let detailViewController = ChatVCPlayer()
            detailViewController.modalPresentationStyle = .custom
            detailViewController.transitioningDelegate = actionChatTransitionManager
            detailViewController.broadcast = broadcast
            detailViewController.delegate = self
            detailViewController.color = .white
            //detailViewController.chatView.buttonChat.isHidden = false
                   
                   present(detailViewController, animated: true)

            
        }
       
    }
    
 
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
    
}

