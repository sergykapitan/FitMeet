//
//  PresentVC.swift
//  MakeStep
//
//  Created by novotorica on 09.07.2021.
//


import Combine
import UIKit
import AVKit

class PresentVC: UIViewController, ClassBDelegate, CustomSegmentedControlDelegate {
    
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
        print("CLOSE PLAY")
        self.dismiss(animated: true, completion: nil)
    }
    var isPlaying: Bool = false
    var id: Int?

    let homeView = PresentCode()
    var playerViewController: AVPlayerViewController?
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeUser: AnyCancellable?
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    var listBroadcast: [BroadcastResponce] = []
    private let refreshControl = UIRefreshControl()
    var  playerContainerView: PlayerContainerView?
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var Url: String?
    var playPauseButton: PlayPauseButton!
    var user: User?

//    override  var shouldAutorotate: Bool {
//        return false
//    }
//    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
    
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
        guard let id = id  else { return }
        bindingUser(id: id)
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
        


    }
    func actionButton () {
        homeView.buttonLandScape.addTarget(self, action: #selector(rightHandAction), for: .touchUpInside)
        homeView.buttonOnline.addTarget(self, action: #selector(actionOnline), for: .touchUpInside)
        homeView.buttonOffline.addTarget(self, action: #selector(actionOffline), for: .touchUpInside)
        homeView.buttonComing.addTarget(self, action: #selector(actionComming), for: .touchUpInside)
        
        
        
    }

    @objc func actionOnline() {
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#3B58A4")
        homeView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.imagePromo.isHidden = false
       // bindingChanell(status: "ONLINE")
       // setUserProfile()
    }
    @objc func actionOffline() {
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonOffline.backgroundColor = UIColor(hexString: "#3B58A4")
        homeView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
       // bindingChanell(status: )
        homeView.imagePromo.isHidden = true
        binding(status: "OFFLINE")
      // setUserProfile()
    

    }
    @objc func actionComming() {
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonComing.backgroundColor = UIColor(hexString: "#3B58A4")
       // bindingChanell(status: "PLANNED")
        homeView.imagePromo.isHidden = true
        binding(status: "PLANNED")
       // setUserProfile()

    }
    
    
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Chanell"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
                    
                    let backButton = UIButton()
                    backButton.setImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)

                   let stackView = UIStackView(arrangedSubviews: [backButton,titleLabel])
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
        homeView.labelFollow.text = "Followers:" + "\(user.channelFollowCount)"
        homeView.setImage(image: user.avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
  
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
        
            
        
               let tim : Float64 = CMTimeGetSeconds((player.currentItem?.asset.duration)!)
        
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
               print("Landscape")
         //   self.playerViewController!.videoGravity = AVLayerVideoGravity.resize
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
                    
                    self.navigationController?.popViewController(animated: true)
                    
                },completion: nil)

        } else {

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

