//
//  ChangeNameVC.swift
//  MakeStep
//
//  Created by Sergey on 09.06.2022.
//

import Foundation
import UIKit
import Combine
import EasyPeasy
import Loaf
import TagListView
import iOSDropDown

class ChangeNameVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate, TagListViewDelegate, UITextFieldDelegate {
    
    private lazy var textViewNameChannel = UITextView(frame: CGRect.zero)
  
    
    private var isOversized = false {
            didSet {
                self.textViewNameChannel.easy.reload()
                self.textViewNameChannel.isScrollEnabled = isOversized

            }
        }
        
    private let maxHeight: CGFloat = 100
    
    let profileView = ChangeChannelCode()
    private var take: AnyCancellable?
    private var channels: AnyCancellable?
    private var takeChanell: AnyCancellable?
 
    @Inject var fitMeetApi: FitMeetChannels
    var channel: ChannelResponce?
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    var idCategory = [Int]()
  
    var user: User?
   
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    override func loadView() {
        super.loadView()
        view = profileView
        setUI()
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButtonContinue()
       // profileView.scroll.delegate = self
        self.hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()

    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
       // guard let id = user?.id else { return }
        let userId = UserDefaults.standard.string(forKey: Constants.userID)
        guard let userId = userId else { return  }
        let id = Int(userId)
        guard let id = id else { return }
        bindingUser(id: id)
        bindingUser(id: id)
     
      

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setChannel()
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
      
       
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
      
    }
    func bindingChannel(userId: Int?) {
        guard let id = userId else { return }
        takeChanell = fitMeetApi.listChannelsPrivate(idUser: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil  {
                    self.channel = response.data.last
                }
        })
    }
   
    func registerForKeyboardNotifications() {
        
    NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShown(_:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillBeHidden(_:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
   

    @objc func keyboardWillShown(_ notificiation: NSNotification) {
       
    
        let info = notificiation.userInfo!
        _ = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
       
        if self.textViewNameChannel.isFirstResponder {
          //  self.profileView.scroll.contentOffset.y = 120

        }
       
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        //self.profileView.scroll.contentOffset.y = 0
    }
 
    func setChannel() {
      //  self.textViewNameChannel.text = channel?.name
    }
    func actionButtonContinue() {
        profileView.buttonOK.addTarget(self, action: #selector(changeChannel), for: .touchUpInside)
        
    }

    func bindingUser(id: Int) {
        take = fitMeetApi.listChannelsPrivate(idUser: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data.first?.name != nil  {
                    self.channel = response.data.last
                }
        })
    }

  
    @objc func changeChannel() {
        guard let id = self.channel?.id else { return }
        
        channels = fitMeetApi.changeChannels(id: id, changeChannel: ChageChannel(
            name: self.textViewNameChannel.text,
            description: nil,
            addFavoriteCategoryIds:idCategory, removeFavoriteCategoryIds: idCategory,
            facebookLink: nil,
            instagramLink: nil,
            twitterLink: nil))
            .mapError({ (error) -> Error in
                print(error.localizedDescription)
                return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil  {
                    DispatchQueue.main.async {
                        Loaf("Saved in \(response.name!)", state: Loaf.State.success, location: .bottom, sender:  self).show(.short) { disType in
                            switch disType {
                            case .tapped:  self.openProfileViewController()
                            case .timedOut: self.openProfileViewController()
                        }
                    }
                }
            } else {
                Loaf("Not Saved \(response.message!)", state: Loaf.State.error, location: .bottom, sender:  self).show(.short)
            }
        })
    }
    
    private func openProfileViewController() {
        let viewController = MainTabBarViewController()
        viewController.selectedIndex = 4
        let mySceneDelegate = (self.view.window?.windowScene)!
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.openRootViewController(viewController: viewController, windowScene: mySceneDelegate)
    }
 
    
    private func setUI() {
                profileView.labelNameOfChannel.centerY(inView: profileView.cardView)
                profileView.labelNameOfChannel.anchor(left: profileView.cardView.leftAnchor, paddingLeft: 16)
            
                self.textViewNameChannel.delegate = self
                self.textViewNameChannel.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
                self.textViewNameChannel.layer.borderWidth = 1.5
                self.textViewNameChannel.layer.cornerRadius = 20
                self.textViewNameChannel.clipsToBounds = true
                self.textViewNameChannel.font =  UIFont.systemFont(ofSize: 18)
        
                self.view.addSubview(self.textViewNameChannel)
                self.textViewNameChannel.isScrollEnabled = false
                self.textViewNameChannel.easy.layout(Left(16),Right(16),Height(maxHeight).when({[unowned self] in self.isOversized}))
        
                self.textViewNameChannel.anchor(top:profileView.labelNameOfChannel.bottomAnchor,
                                     left: profileView.cardView.leftAnchor,
                                     paddingTop: 8,paddingLeft: 16)
                textViewNameChannel.textContainerInset = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 5)
        
            
        
        profileView.buttonOK.anchor(top: textViewNameChannel.bottomAnchor,
                                    left: view.leftAnchor,
                                    right: view.rightAnchor,
                                    paddingTop: 32, paddingLeft: 16, paddingRight: 16,height: 39)
       
        

    }
    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               self.textViewNameChannel.resignFirstResponder()
               self.textViewNameChannel.resignFirstResponder()
               return true
           }
           return true
       }
 
}


