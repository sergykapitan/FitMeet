//
//  ChanellVC.swift
//  FitMeet
//
//  Created by novotorica on 29.06.2021.
//

import Foundation
import UIKit
import Combine
import ContextMenuSwift

class ChanellVC: UIViewController {
    
    let profileView = ChanellCode()
    private var take: AnyCancellable?
    private var takeChanell: AnyCancellable?
 
    @Inject var fitMeetApi: FitMeetApi
    @Inject var firMeetChanell: FitMeetChannels
    @Inject var fitMeetSream: FitMeetStream
    var user: User?
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
        profileView.segmentControll.setButtonTitles(buttonTitles: ["Videos "," Timetable"])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        setUserProfile()
        profileView.segmentControll.backgroundColor = UIColor(hexString: "#F6F6F6")

        
        self.navigationController?.navigationBar.isHidden = false
        //profileView.viewTop.backgroundColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
   
 
    func setUserProfile() {
        guard let userName = UserDefaults.standard.string(forKey: Constants.userFullName),let userFullName = UserDefaults.standard.string(forKey: Constants.userID) else { return }
        print("token ====== \(UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults))")
        bindingUser()
        bindingChanell(status: "ONLINE")
        let name: String?
        if user?.fullName != nil {
            name = user?.fullName
        } else { name = userName }
        guard let n = name else { return }
        profileView.welcomeLabel.text =  n
        profileView.labelFollow.text = "Followers:" + "\(user?.channelFollowCount)"
        profileView.setImage(image: user?.avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png", imagepromo: brodcast?.previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        profileView.labelStreamDescription.text = brodcast?.description
      //  profileView.setLabel(description: brodcast?.description, category: brodcast?.createdAt)
       // profileView.setLabel(description: brodcast?.deleted, category: brodcast?.categories)
        
    }
    func actionButtonContinue() {
        profileView.buttonOnline.addTarget(self, action: #selector(actionOnline), for: .touchUpInside)
        profileView.buttonOffline.addTarget(self, action: #selector(actionOffline), for: .touchUpInside)
        profileView.buttonComing.addTarget(self, action: #selector(actionComming), for: .touchUpInside)

    }
    @objc func actionOnline() {
        profileView.buttonOnline.backgroundColor = UIColor(hexString: "#0099AE")
        profileView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
        bindingChanell(status: "ONLINE")
        //self.loadViewIfNeeded()
    }
    @objc func actionOffline() {
        profileView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonOffline.backgroundColor = UIColor(hexString: "#0099AE")
        profileView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
        bindingChanell(status: "OFFLINE")
       // self.loadViewIfNeeded()
    

    }
    @objc func actionComming() {
        profileView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        profileView.buttonComing.backgroundColor = UIColor(hexString: "#0099AE")
        bindingChanell(status: "PLANNED")
       // self.loadViewIfNeeded()

    }
    func bindingUser() {
        take = fitMeetApi.getUser()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                    self.user = response
                    print(self.user)
                }
        })
    }
    
    func bindingChanell(status: String) {
        takeChanell = fitMeetSream.getBroadcast(status: status)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.brodcast = response.data?.last
                    print(self.brodcast)
                }
        })
        
        
        
    }
    
    
    
    
    @objc func actionEditProfile() {

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
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "Note"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction)),
                                                   UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction))]
    }
    @objc
    func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc
    func rightHandAction() {
        print("right bar button action")
    }

}


