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
            profileView.buttonOnline.isHidden = false
            profileView.buttonOffline.isHidden = false
            profileView.buttonComing.isHidden = false
            profileView.imagePromo.isHidden = false
            profileView.labelCategory.isHidden = false
            profileView.labelStreamInfo.isHidden = false
            profileView.labelStreamDescription.isHidden = false
            profileView.tableView.isHidden = true
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
    private let popupOffset: CGFloat = -400
    
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
    
    private var topOverlayConstant = NSLayoutConstraint()
    private var rightLandscape = NSLayoutConstraint()
    
    private var topbuttonSubscribeConstant = NSLayoutConstraint()
    private var leftbuttonSubscribeConstant = NSLayoutConstraint()
    private var rightbuttonSubscribeConstant = NSLayoutConstraint()
    private var centerbuttonSubscribeConstant = NSLayoutConstraint()
    
    
    let profileView = ChanellCode()
    private var take: AnyCancellable?
    private var takeChanell: AnyCancellable?
 
    @Inject var fitMeetApi: FitMeetApi
    @Inject var firMeetChanell: FitMeetChannels
    @Inject var fitMeetSream: FitMeetStream
    var user: Users?
    var brodcast: BroadcastResponce?

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
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButtonContinue()
        makeNavItem()
        profileView.segmentControll.setButtonTitles(buttonTitles: ["Videos"])//," Timetable"
        profileView.segmentControll.delegate = self
        profileView.tableView.isHidden = true
        actionOnline()
        layout()
        profileView.viewTop.addGestureRecognizer(panRecognizer)
       // profileView.tableView.dataSource = self
       // profileView.tableView.delegate = self
        bindingChanell(status: "ONLINE")
        let bundle = Bundle(for: TimelineTableViewCell.self)
        let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
            bundle: Bundle(url: nibUrl!)!)
        self.profileView.tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
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
    // homeView.buttonSubscribe.translatesAutoresizingMaskIntoConstraints = false
   //  homeView.buttonHelpCoach.translatesAutoresizingMaskIntoConstraints = false
     
     view.addSubview(profileView.viewTop)
     view.addSubview(profileView.imageLogoProfile)
     view.addSubview(profileView.welcomeLabel)
     view.addSubview(profileView.labelFollow)

        profileView.viewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileView.viewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
     bottomConstraint = profileView.viewTop.topAnchor.constraint(equalTo: view.topAnchor, constant: -400)
     bottomConstraint.isActive = true
        profileView.viewTop.heightAnchor.constraint(equalToConstant: 500).isActive = true

        profileView.labelFollow.bottomAnchor.constraint(equalTo: profileView.imageLogoProfile.bottomAnchor, constant: 0).isActive = true
        profileView.labelFollow.leadingAnchor.constraint(equalTo: profileView.imageLogoProfile.trailingAnchor, constant: 12).isActive = true
     

     topWelcomLabelConstant = profileView.welcomeLabel.topAnchor.constraint(equalTo: profileView.imageLogoProfile.topAnchor, constant: 0)
     topWelcomLabelConstant.isActive = true
     
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
   
 
    func setUserProfile() {
       // bindingUser()
        guard let userName = UserDefaults.standard.string(forKey: Constants.userFullName),let userFullName = UserDefaults.standard.string(forKey: Constants.userID) else { return }
     
        let name: String?
        if user?.fullName != nil {
            name = user?.fullName
        } else { name = userName }
        guard let n = name ,let imageUser = user?.avatarPath else { return }
        profileView.welcomeLabel.text =  n
        profileView.labelFollow.text = "Followers:" + "\(user?.channelSubscribeCount ?? 30)"
        profileView.setImage(image: imageUser,
        imagepromo: brodcast?.previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        profileView.labelStreamDescription.text = brodcast?.description
      //  profileView.setLabel(description: brodcast?.description, category: brodcast?.createdAt)
      //  profileView.setLabel(description: brodcast?.deleted, category: brodcast?.categories)
        
    }
    func actionButtonContinue() {
        profileView.buttonOnline.addTarget(self, action: #selector(actionOnline), for: .touchUpInside)
        profileView.buttonOffline.addTarget(self, action: #selector(actionOffline), for: .touchUpInside)
        profileView.buttonComing.addTarget(self, action: #selector(actionComming), for: .touchUpInside)

    }
    @objc func actionOnline() {
        profileView.buttonOnline.backgroundColor = UIColor(hexString: "#3B58A4")
        profileView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
        bindingChanell(status: "ONLINE")
        setUserProfile()
    }
    @objc func actionOffline() {
        profileView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonOffline.backgroundColor = UIColor(hexString: "#3B58A4")
        profileView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
        bindingChanell(status: "OFFLINE")
        setUserProfile()
    

    }
    @objc func actionComming() {
        profileView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonComing.backgroundColor = UIColor(hexString: "#3B58A4")
        bindingChanell(status: "PLANNED")
        setUserProfile()

    }
//    func bindingUser() {
//        take = fitMeetApi.getUser()
//            .mapError({ (error) -> Error in return error })
//            .sink(receiveCompletion: { _ in }, receiveValue: { response in
//                if response.username != nil  {
//                    self.user = response
//                }
//            })
//        }
    
    func bindingChanell(status: String) {
        takeChanell = fitMeetSream.getBroadcast(status: status)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.brodcast = response.data?.last
                    print(self.brodcast)
                    self.profileView.reloadInputViews()
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
                self.bottomConstraint.constant = -100
              
                self.profileView.labelFollow.transform = CGAffineTransform(scaleX: 1.6, y: 1.6).concatenating(CGAffineTransform(translationX: 0, y: 15))
                self.profileView.labelFollow.transform = .identity
            case .closed:
                self.bottomConstraint.constant = self.popupOffset
               
                self.profileView.labelFollow.transform = .identity
                self.profileView.labelFollow.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
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
                self.bottomConstraint.constant = -100
            case .closed:
                self.bottomConstraint.constant = self.popupOffset
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
        // an animator for the title that is transitioning into view
        let inTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
            switch state {
            case .open:
                self.profileView.labelFollow.alpha = 1
            case .closed:
                self.profileView.labelFollow.alpha = 1
            }
        })
        inTitleAnimator.scrubsLinearly = false
        
        // an animator for the title that is transitioning out of view
        let outTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.profileView.labelFollow.alpha = 0
            case .closed:
                self.profileView.labelFollow.alpha = 0
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

