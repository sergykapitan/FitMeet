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
import TagListView
import CloudKit


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

class ChannelCoach: SheetableViewController, VeritiPurchase, UIGestureRecognizerDelegate, TagListViewDelegate  {
    
    func addPurchase() {
        guard let userId = user?.id else { return }
        self.bindingChannel(userId: userId)
    }
    var arrayResolution = [String]()
    let popupOffset: CGFloat = -350
    var bottomConstraint = NSLayoutConstraint()
    
    var broadcast: BroadcastResponce?
    var startAnimation:Bool = true
    
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
    
    var currentPage : Int = 1
    var currentPageCategory : Int = 1
    var isLoadingList : Bool = true
    var itemCount: Int = 0
    var categoryCount: Int = 0
    var allCount: Int = 0
    
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
    private var takeOff: AnyCancellable?
    private var takeBroadcastPlanned : AnyCancellable?
    private var follow : AnyCancellable?
 
    @Inject var fitMeetChannel: FitMeetChannels
    var channel: ChannelResponce?
    
   
    
    var isPlaying: Bool = false
    var isButton: Bool = true
    var playPauseButton: PlayPauseButton!

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
        createTableView()
        makeNavItem()
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        layout()
        homeView.viewTop.addGestureRecognizer(panRecognizer)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        self.homeView.labelStreamInfo.isUserInteractionEnabled = true
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelAction))
        self.homeView.labelStreamInfo.addGestureRecognizer(tap)
        tap.delegate = self
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
         
           self.homeView.imagePromo.isHidden = true
           self.homeView.imageLogo.isHidden = true
           self.homeView.labelStreamInfo.isHidden = true
           self.homeView.buttonMore.isHidden = true
           self.homeView.buttonChat.isHidden = true
           
           self.navigationController?.navigationBar.isHidden = false
           guard let id = user?.id else { return }
           if self.brodcast.isEmpty {
               if token != nil {
                   self.bindingChannel(userId: id)
                   self.binding(id: "\(id)")
               } else {
                   self.bindingChannelNotAuth(userId: id)
                   self.bindingBroadcastNotAuth(status: "ONLINE", userId: "\(id)")
               }
          }
      }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        homeView.imageLogoProfile.makeRounded()
        setUserProfile()
    }
    
    @objc func labelAction(gr:UITapGestureRecognizer) {
        let vc = PlayerViewVC()
        guard let broadcast = broadcast else { return }
        if broadcast.status == .online {
            vc.broadcast = broadcast
            vc.id =  broadcast.userId
            vc.homeView.buttonChat.isHidden = false
            vc.homeView.labelLike.text = "\(String(describing: broadcast.followersCount!))"
            vc.homeView.playerSlider.isHidden = true
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

         if let swipeGesture = gesture as? UISwipeGestureRecognizer {
             switch swipeGesture.direction {
             case UISwipeGestureRecognizer.Direction.right:
                 self.navigationController?.popViewController(animated: true)
             default:
                 break
             }
         }
     }
   
    
    func bindingChanellVOD(userId: String,page: Int) {
        self.isLoadingList = false
        take = fitMeetStream.getBroadcastPrivateVOD(userId: "\(userId)", page: page, type: "STANDARD_VOD")
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
                    self.homeView.labelINTVideo.text = "\(self.itemCount)"
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
                    self.homeView.labelINTVideo.text = "\(self.itemCount)"
                }
           })
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
    func bindingOff() {
        takeOff = fitMeetStream.getOffBroadcast(page: 1)
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
    func loadMoreItemsForList(){
            currentPage += 1
            guard let id = user?.id else { return }
            bindingChanellVOD(userId: "\(id)", page: currentPage)
       }
    func loadMoreCaategoryForList(){
            currentPageCategory += 1
            guard let id = self.broadcast?.categories?.first?.id else { return }
            bindingCategory(categoryId: id,page: currentPageCategory)
       }
    func bindingChannel(userId: Int?) {
        guard let id = userId else { return }
        takeChanell = fitMeetChannel.listChannelsPrivate(idUser: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil  {
                    self.channel = response.data.last
                    guard let channel = self.channel else {
                        self.homeView.buttonSubscribe.backgroundColor = .lightGray
                        self.homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
                        self.homeView.buttonSubscribe.setTitle("Subscribe", for: .normal)
                        self.homeView.buttonSubscribe.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1).cgColor
                        return
                    }
                    if channel.isSubscribe! {                        
                        self.homeView.buttonSubscribe.setTitle("Subscribers", for: .normal)
                        self.homeView.buttonSubscribe.setTitleColor(.blueColor, for: .normal)
                        self.homeView.buttonSubscribe.backgroundColor = .white
                    } else {
                        if  channel.subscriptionPlans != nil {
                        self.homeView.buttonSubscribe.backgroundColor = .blueColor
                        self.homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
                        self.homeView.buttonSubscribe.setTitle("Subscribe", for: .normal)
                        } else {
                            self.homeView.buttonSubscribe.backgroundColor = .lightGray
                            self.homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
                            self.homeView.buttonSubscribe.setTitle("Subscribe", for: .normal)
                            self.homeView.buttonSubscribe.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1).cgColor
                        }
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
    func bindingChannelNotAuth(userId: Int?) {
        guard let id = userId else { return }
        takeChanell = fitMeetChannel.listChannelsNotAuth(idUser: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil  {
                    self.channel = response.data.last
                    guard let channel = self.channel else {
                        self.homeView.buttonSubscribe.backgroundColor = .lightGray
                        self.homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
                        self.homeView.buttonSubscribe.setTitle("Subscribe", for: .normal)
                        self.homeView.buttonSubscribe.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1).cgColor
                        return
                    }
                    self.homeView.buttonSubscribe.backgroundColor = .lightGray
                    self.homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
                    self.homeView.buttonSubscribe.setTitle("Subscribe", for: .normal)
                    self.homeView.buttonSubscribe.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1).cgColor
                    
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
                          homeView.tableView.anchor(top: homeView.imageLogoProfileBottom.bottomAnchor,
                                           left: homeView.cardView.leftAnchor,
                                           right: homeView.cardView.rightAnchor,
                                           bottom: homeView.cardView.bottomAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
                          loadPlayer(url: (self.brodcast.first?.streams?.first?.hlsPlaylistUrl)!)
                          guard let nameStream = self.brodcast.first?.streams?.first?.name else { return }
                          self.homeView.labelStreamInfo.text = "\(nameStream)"
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
                      self.bindingChanellVOD(userId: id, page: currentPage)
            }
        })
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
                    self.brodcast.append(contentsOf: response.data!)
                    if !response.data!.isEmpty  {
                        self.homeView.imagePromo.isHidden = false
                        self.homeView.imageLogo.isHidden = false
                        self.homeView.labelStreamInfo.isHidden = false
                        self.homeView.buttonMore.isHidden = false
                        self.homeView.cardView.addSubview(self.homeView.tableView)
                        self.homeView.tableView.anchor(top: self.homeView.imageLogoProfileBottom.bottomAnchor,
                                                       left: self.homeView.cardView.leftAnchor,
                                                       right: self.homeView.cardView.rightAnchor,
                                                       bottom: self.homeView.cardView.bottomAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
                        self.loadPlayer(url: (self.brodcast.first?.streams?.first?.hlsPlaylistUrl)!)
                        guard let nameStream = self.brodcast.first?.streams?.first?.name else { return }
                        self.homeView.labelStreamInfo.text = "\(nameStream)"
                    } else {
                        self.homeView.imagePromo.isHidden = true
                        self.homeView.imageLogo.isHidden = true
                        self.homeView.labelStreamInfo.isHidden = true
                        self.homeView.buttonMore.isHidden = true
                        self.homeView.cardView.addSubview(self.homeView.tableView)
                        self.homeView.tableView.anchor(top: self.homeView.cardView.topAnchor,
                                                       left: self.homeView.cardView.leftAnchor,
                                                       right: self.homeView.cardView.rightAnchor,
                                                       bottom: self.homeView.cardView.bottomAnchor, paddingTop: 110, paddingLeft: 0, paddingRight: 0, paddingBottom: 0)
                    }
                    
                    self.bindingChanellVODNotAuth(userId: userId, page: self.currentPage)
                }
           })
       }
    func bindingUserMap(ids: [Int])  {
        take = fitMeetApi.getUserIdMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if !response.data.isEmpty {
                    self.usersd = response.data
                    self.homeView.tableView.reloadData()
                }
          })
    }
    func loadPlayer(url: String) {
        print("URL == \(url)")
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
       
        let interval: CMTime = CMTimeMakeWithSeconds(0.001, preferredTimescale: Int32(NSEC_PER_SEC))
        playerViewController?.player!.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.playerViewController?.player!.currentItem?.status == .readyToPlay {
                 let timeLabel : Float64 = CMTimeGetSeconds((self.playerViewController?.player!.currentTime())!)
                 guard let time = self.playerViewController?.player!.currentTime() else { return }
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

        self.view.addSubview(self.homeView.labelTimeStart)
        self.homeView.labelTimeStart.anchor(left: self.playerViewController!.view.leftAnchor, bottom: self.playerViewController!.view.bottomAnchor, paddingLeft: 16, paddingBottom: 10)
        
        self.view.addSubview(self.homeView.labelTimeEnd)
        self.homeView.labelTimeEnd.anchor(left: self.homeView.labelTimeStart.rightAnchor, bottom: self.playerViewController!.view.bottomAnchor, paddingLeft: 2, paddingBottom: 10)
    }
    
    
    
    
    
    
    
    @objc func actionSubscribe() {
       guard  let _ = token else {
            let sign = SignInViewController()
            self.present(sign, animated: true, completion: nil)
            return }
        guard let channel = channel else { return }
        guard let subscribe = channel.isSubscribe else { return }
        if subscribe {
           
        } else {
          guard let subPlans = channel.subscriptionPlans else { return }
            if subPlans.isEmpty {
            } else {
                let subscribeView = SubscribeVC()
                       subscribeView.modalPresentationStyle = .custom
                       subscribeView.id = user?.id
                       subscribeView.delagatePurchase = self


                if view.bounds.height <= 718 {
                    actionChatTransitionManager.intHeight = 0.46
                } else {
                    actionChatTransitionManager.intHeight = 0.4
                }
                   actionChatTransitionManager.intWidth = 1
                   subscribeView.transitioningDelegate = actionChatTransitionManager
                   present(subscribeView, animated: true)
            }
        }
    }
    func makeNavItem() {
        
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
                    let titleLabel = UILabel()
                   titleLabel.text = "  Channel Coach"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
                    let backButton = UIButton()
                   // backButton.anchor( width: 40, height: 30)
                    backButton.setBackgroundImage(#imageLiteral(resourceName: "backButton"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)
        
                    let stackView = UIStackView(arrangedSubviews: [backButton,titleLabel])
                    stackView.distribution = .equalSpacing
                    stackView.alignment = .center
                    stackView.axis = .horizontal

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        
       
    }
    func setUserProfile() {
        homeView.setImage(image: user?.resizedAvatar?["avatar_120"]?.png ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
        guard let follow = self.channel?.followersCount,let fullName = user?.fullName,let sub = user?.channelSubscribeCount!  else { return }
        homeView.labelFollow.text = "Followers:" + "\(follow)"
        self.homeView.welcomeLabel.text = fullName
        self.homeView.labelINTFollows.text = "\(follow)"
        self.homeView.labelINTFolowers.text = "\(sub)"
        self.homeView.labelDescription.text = channel?.description
        self.homeView.labelNameCoach.text = fullName
        self.homeView.imageLogoProfileBottom.makeRounded()
        
        guard let isFollow = channel?.isFollow else { return }
               if isFollow {
                       self.homeView.buttonFollow.backgroundColor = .white
                       self.homeView.buttonFollow.setTitleColor(.blueColor, for: .normal)
                   } else {
                       self.homeView.buttonFollow.backgroundColor = .blueColor
                       self.homeView.buttonFollow.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
                   }

        guard  let categorys = broadcast?.categories else { return }
        let s = categorys.map{$0.title!}
        let arr = s.map { String("\u{0023}" + $0)}
        homeView.labelCategory.removeAllTags()
        homeView.labelCategory.addTags(arr)
        homeView.labelCategory.delegate = self
    }
    func actionButtonContinue() {
        homeView.buttonSetting.addTarget(self, action: #selector(actionSetting), for: .touchUpInside)
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
                self.playerViewController!.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.actionBut)))
                self.playerViewController!.view.addGestureRecognizer(UIPinchGestureRecognizer.init(target: self, action: #selector(self.actionResize(sender:))))
                self.view.addSubview(self.homeView.buttonLandScape)
                self.view.addSubview(self.homeView.buttonSetting)
                self.view.addSubview(self.homeView.labelTimeEnd)
                self.view.addSubview(self.homeView.labelTimeStart)
                let imageL = UIImage(named: "minimize")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                self.homeView.buttonLandScape.setImage(imageL, for: .normal)
                self.navigationController?.navigationBar.isHidden = true
                self.tabBarController?.tabBar.isHidden = true
                self.view.layoutIfNeeded()
            
            })
            transitionAnimator.startAnimation()
            playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspect
           } else {
               let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                   let playerFrame = self.homeView.imagePromo.bounds
                   self.playerViewController!.view.frame = playerFrame
                   self.playerViewController!.showsPlaybackControls = false
                   self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                   self.homeView.imagePromo.addSubview(self.playerViewController!.view)
                   self.playerViewController!.didMove(toParent: self)
                   let imageL = UIImage(named: "maximize")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                   self.homeView.buttonLandScape.setImage(imageL, for: .normal)
                   self.navigationController?.navigationBar.isHidden = false
                   self.tabBarController?.tabBar.isHidden = false
                   self.view.layoutIfNeeded()
                   })
               transitionAnimator.startAnimation()
                  playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspect
           }
    }
    // MARK: - ButtonLandscape
    @objc func actionSetting() {
        self.present()
    }
    @objc func rightHandAction() {
        if isPlaying {
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
            self.isPlaying = false
        } else {
            AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)
            self.isPlaying =  true
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
    @objc func actionFollow() {
        guard let _ = token else {
            let sign = SignInViewController()
            self.present(sign, animated: true, completion: nil)
            return }
        homeView.buttonFollow.isSelected.toggle()
        
        if homeView.buttonFollow.isSelected {
            guard let id = self.channel?.id else { return }
            followChannel(id: id)

        } else {
            guard let id = self.channel?.id else { return }
            unFollowChannel(id: id)

        }
    }
    private func followChannel(id: Int) {
        follow = firMeetChanell.followChannels(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil {
                    self.homeView.buttonFollow.backgroundColor = .white
                    self.homeView.buttonFollow.setTitleColor(.blueColor, for: .normal)
                   // guard let follow =  response.followersCount else { return }
                    self.homeView.labelINTFollows.text = "\(response.followersCount)"
                    
            }
        })
    }
    private func unFollowChannel(id: Int) {
        follow = firMeetChanell.unFollowChannels(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil {
                    self.homeView.buttonFollow.backgroundColor = .blueColor
                    self.homeView.buttonFollow.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
                   // guard let follow =  response.followersCount else { return }
                    self.homeView.labelINTFollows.text = "\(response.followersCount)"
            }
        })
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
    @objc func actionMore() {
        guard token != nil,let broadcastId = self.broadcast?.id else { return }
        showDownSheet(moreArtworkOtherUserSheetVC, payload: broadcastId)

    }
    @objc func actionBut(sender:UITapGestureRecognizer) {
        if isButton {
            homeView.overlay.isHidden = true
            homeView.imageLive.isHidden = true
            homeView.labelLive.isHidden = true
            homeView.imageEye.isHidden = true
            homeView.labelEye.isHidden = true
            homeView.buttonLandScape.isHidden = true
            homeView.buttonSetting.isHidden = true
            homeView.buttonVolum.isHidden = true

            isButton = false
        } else {
   
           
            homeView.buttonSetting.isHidden = false
            homeView.overlay.isHidden = false
            homeView.imageLive.isHidden = false
            homeView.labelLive.isHidden = false
            homeView.imageEye.isHidden = false
            homeView.labelEye.isHidden = false
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
    @objc func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }
    public func present() {
        
        guard let urlStream = url else { return }
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
    private func action(for type: String, title: String) -> UIAlertAction? {
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            guard let url = URL(string: url!) else { return }
      
            switch type {
            case "Auto" :
                print("TO DO")
                //self.replaceItem(with: url)
            default:
               break
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
                
              //  self.homeView.buttonSubscribe.isHidden = true
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
                self.homeView.buttonFollow.alpha = 1
                
               
                
               
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
                self.homeView.buttonFollow.alpha = 0
                
                
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
                    self.homeView.buttonFollow.alpha = 1
                
                 
             
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
                    self.homeView.buttonFollow.alpha = 0
                
               
                   
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

