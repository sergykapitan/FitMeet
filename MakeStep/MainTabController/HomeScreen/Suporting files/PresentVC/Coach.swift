//
//  Coach.swift
//  MakeStep
//
//  Created by novotorica on 07.09.2021.
//

import Foundation
import UIKit
import Combine

class Coach: UIViewController {
    
    let coachView = CoachCode()
    private var take: AnyCancellable?
 
    @Inject var fitMeetApi: FitMeetApi
    var user: User?
    
 
    override func loadView() {
        super.loadView()
        view = coachView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserProfile()
        actionButtonContinue()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.navigationController?.navigationBar.isHidden = false
        coachView.imageLogoProfile.round()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        setUserProfile()
        coachView.imageLogoProfile.round()
    
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
    }
 
    func setUserProfile() {
        guard let coach = user else { return }
        print("Coach = \(coach)")
        self.coachView.setImage(image: coach.avatarPath ?? "https://logodix.com/logo/1070633.png")
        self.coachView.welcomeLabel.text = coach.fullName
        self.coachView.labelINTFollows.text = "\(coach.channelFollowCount!)"
        self.coachView.labelINTFolowers.text = "\(coach.channelSubscribeCount!)"
        self.coachView.labelDescription.text = "Welcome to my channel!My name is \(coach.fullName!)"
        coachView.imageLogoProfile.round()

    }
    func actionButtonContinue() {
        self.coachView.buttonSubscribe.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        self.coachView.buttonFollow.addTarget(self, action: #selector(actionEditProfile), for: .touchUpInside)
    }
    @objc func actionSignUp() {
        coachView.buttonSubscribe.isSelected.toggle()
        
        if coachView.buttonSubscribe.isSelected {
            coachView.buttonSubscribe.backgroundColor = UIColor(hexString: "#3B58A4")
            coachView.buttonSubscribe.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
            
        } else {
            coachView.buttonSubscribe.backgroundColor = UIColor(hexString: "#DADADA")
            coachView.buttonSubscribe.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
        }

    }
    @objc func actionEditProfile() {
        coachView.buttonFollow.isSelected.toggle()
        
        if coachView.buttonFollow.isSelected {
            coachView.buttonFollow.backgroundColor = UIColor(hexString: "#3B58A4")
            coachView.buttonFollow.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
            
        } else {
            coachView.buttonFollow.backgroundColor = UIColor(hexString: "#DADADA")
            coachView.buttonFollow.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
        }

        
    }
    
    
    @objc func actionChanell() {
       
    }
    
   
    @objc func timeHandAction() {
        print("timeHandAction")
        let tvc = Timetable()
        navigationController?.present(tvc, animated: true, completion: nil)
        
        
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
}


