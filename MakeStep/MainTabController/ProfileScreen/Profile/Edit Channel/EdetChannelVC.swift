//
//  EdetChannelVC.swift
//  MakeStep
//
//  Created by Sergey on 11.10.2021.
//

import Foundation
import UIKit
import Combine
import EasyPeasy

class EdetChannelVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    private lazy var textViewNameChannel = UITextView(frame: CGRect.zero)
    private lazy var textViewDescription = UITextView(frame: CGRect.zero)
    private lazy var textViewFacebook = UITextView(frame: CGRect.zero)
    private lazy var textViewInstagram = UITextView(frame: CGRect.zero)
    private lazy var textViewTwitter = UITextView(frame: CGRect.zero)
    private lazy var textViewFavoriteCategories = UITextView(frame: CGRect.zero)
    
    private var isOversized = false {
            didSet {
                self.textViewNameChannel.easy.reload()
                self.textViewDescription.easy.reload()
                self.textViewFacebook.easy.reload()
                self.textViewInstagram.easy.reload()
                self.textViewTwitter.easy.reload()
                self.textViewFavoriteCategories.easy.reload()

                self.textViewNameChannel.isScrollEnabled = isOversized
                self.textViewDescription.isScrollEnabled = isOversized
                self.textViewFacebook.isScrollEnabled = isOversized
                self.textViewInstagram.isScrollEnabled = isOversized
                self.textViewTwitter.isScrollEnabled = isOversized
                self.textViewFavoriteCategories.isScrollEnabled = isOversized
      
            }
        }
        
    private let maxHeight: CGFloat = 100
    
    let profileView = EditChannelCode()
    private var take: AnyCancellable?
    private var channels: AnyCancellable?
 
    @Inject var fitMeetApi: FitMeetChannels
    var channel: ChannelResponce?
    
    
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
        makeNavItem()
        profileView.scroll.delegate = self
        self.hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        bindingUser()
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
    func registerForKeyboardNotifications() {
        
    NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShown(_:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillBeHidden(_:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }

    @objc func keyboardWillShown(_ notificiation: NSNotification) {
       
      // write source code handle when keyboard will show
        let info = notificiation.userInfo!
         let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
       
        if self.textViewFavoriteCategories.isFirstResponder {
            self.profileView.scroll.contentOffset.y = 120

        }
        if self.textViewTwitter.isFirstResponder {
            self.profileView.scroll.contentOffset.y = 70
       }
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        self.profileView.scroll.contentOffset.y = 0
    }
 
    func setChannel() {
        self.textViewNameChannel.text = channel?.name
        self.textViewDescription.text = channel?.description
        self.textViewFacebook.text = channel?.facebookLink
        self.textViewInstagram.text = channel?.instagramLink
        self.textViewTwitter.text = channel?.twitterLink
        guard let categories = channel?.favoriteCategories else { return }
        self.textViewFavoriteCategories.text = "\(categories)"
                
    }
    func actionButtonContinue() {
        profileView.buttonOK.addTarget(self, action: #selector(changeChannel), for: .touchUpInside)
    }

    func bindingUser() {
        take = fitMeetApi.listChannels()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil  {
                    self.channel = response.data.last
                }
        })
    }
    @objc func changeChannel() {
        guard let id = self.channel?.id else { return }
        
        channels = fitMeetApi.changeChannels(id: id, changeChannel: ChageChannel(
            name: self.textViewNameChannel.text,
            description: self.textViewDescription.text,
            facebookLink: self.textViewFacebook.text,
            instagramLink: self.textViewInstagram.text,
            twitterLink: self.textViewTwitter.text))
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil  {
                    self.navigationController?.popViewController(animated: true)
                }
        })
    }
    
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
                    let titleLabel = UILabel()
                   titleLabel.text = "Edit Channel"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
                   let backButton = UIButton()
                   backButton.setBackgroundImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                   backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)
                   backButton.anchor(width:30,height: 30)
                   let stackView = UIStackView(arrangedSubviews: [backButton,titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .horizontal

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
       
    }
    @objc func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUI() {
                profileView.labelNameOfChannel.anchor(top: profileView.cardView.topAnchor,
                                              left: profileView.cardView.leftAnchor,
                                              paddingTop: 31, paddingLeft: 16)
        
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
        
                profileView.labelDescription.anchor(top: textViewNameChannel.bottomAnchor,
                                            left: profileView.cardView.leftAnchor,
                                            paddingTop: 8, paddingLeft: 16)
        
                self.textViewDescription.delegate = self
                self.textViewDescription.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
                self.textViewDescription.layer.borderWidth = 1.5
                self.textViewDescription.layer.cornerRadius = 20
                self.textViewDescription.clipsToBounds = true
        
                self.textViewDescription.font =  UIFont.systemFont(ofSize: 18)
                self.view.addSubview(self.textViewDescription)
                self.textViewDescription.isScrollEnabled = false
                self.textViewDescription.easy.layout(Left(16),Right(16),Height(maxHeight).when({[unowned self] in self.isOversized}))
                self.textViewDescription.anchor(top:profileView.labelDescription.bottomAnchor,
                             left: profileView.cardView.leftAnchor,
                             paddingTop: 8,paddingLeft: 16)
                textViewDescription.textContainerInset = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 5)
        
        profileView.labelFaceBook.anchor(top: textViewDescription.bottomAnchor,
                                         left: profileView.cardView.leftAnchor,
                                         paddingTop: 8, paddingLeft: 16)
        self.textViewFacebook.delegate = self
        self.textViewFacebook.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
        self.textViewFacebook.layer.borderWidth = 1.5
        self.textViewFacebook.layer.cornerRadius = 20
        self.textViewFacebook.clipsToBounds = true

        self.textViewFacebook.font =  UIFont.systemFont(ofSize: 18)
        self.view.addSubview(self.textViewFacebook)
        self.textViewFacebook.isScrollEnabled = false
        self.textViewFacebook.easy.layout(Left(16),Right(16),Height(maxHeight).when({[unowned self] in self.isOversized}))
        self.textViewFacebook.anchor(top:profileView.labelFaceBook.bottomAnchor,
                     left: profileView.cardView.leftAnchor,
                     paddingTop: 8,paddingLeft: 16)
        textViewFacebook.textContainerInset = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 5)
        
        profileView.labelInstagram.anchor(top: textViewFacebook.bottomAnchor,
                                         left: profileView.cardView.leftAnchor,
                                         paddingTop: 8, paddingLeft: 16)
        self.textViewInstagram.delegate = self
        self.textViewInstagram.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
        self.textViewInstagram.layer.borderWidth = 1.5
        self.textViewInstagram.layer.cornerRadius = 20
        self.textViewInstagram.clipsToBounds = true

        self.textViewInstagram.font =  UIFont.systemFont(ofSize: 18)
        self.view.addSubview(self.textViewInstagram)
        self.textViewInstagram.isScrollEnabled = false
        self.textViewInstagram.easy.layout(Left(16),Right(16),Height(maxHeight).when({[unowned self] in self.isOversized}))
        self.textViewInstagram.anchor(top:profileView.labelInstagram.bottomAnchor,
                     left: profileView.cardView.leftAnchor,
                     paddingTop: 8,paddingLeft: 16)
        textViewInstagram.textContainerInset = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 5)
        
        profileView.labelTwitter.anchor(top: textViewInstagram.bottomAnchor,
                                         left: profileView.cardView.leftAnchor,
                                         paddingTop: 8, paddingLeft: 16)
        self.textViewTwitter.delegate = self
        self.textViewTwitter.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
        self.textViewTwitter.layer.borderWidth = 1.5
        self.textViewTwitter.layer.cornerRadius = 20
        self.textViewTwitter.clipsToBounds = true

        self.textViewTwitter.font =  UIFont.systemFont(ofSize: 18)
        self.view.addSubview(self.textViewTwitter)
        self.textViewTwitter.isScrollEnabled = false
        self.textViewTwitter.easy.layout(Left(16),Right(16),Height(maxHeight).when({[unowned self] in self.isOversized}))
        self.textViewTwitter.anchor(top:profileView.labelTwitter.bottomAnchor,
                     left: profileView.cardView.leftAnchor,
                     paddingTop: 8,paddingLeft: 16)
        textViewTwitter.textContainerInset = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 5)
        
        profileView.labelFavoriteCategories.anchor(top: textViewTwitter.bottomAnchor,
                                         left: profileView.cardView.leftAnchor,
                                         paddingTop: 8, paddingLeft: 16)
        self.textViewFavoriteCategories.delegate = self
        self.textViewFavoriteCategories.layer.borderColor = UIColor(hexString: "#F4F4F4").cgColor
        self.textViewFavoriteCategories.layer.borderWidth = 1.5
        self.textViewFavoriteCategories.layer.cornerRadius = 20
        self.textViewFavoriteCategories.clipsToBounds = true

        self.textViewFavoriteCategories.font =  UIFont.systemFont(ofSize: 18)
        self.view.addSubview(self.textViewFavoriteCategories)
        self.textViewFavoriteCategories.isScrollEnabled = false
        self.textViewFavoriteCategories.easy.layout(Left(16),Right(16),Height(maxHeight).when({[unowned self] in self.isOversized}))
        self.textViewFavoriteCategories.anchor(top:profileView.labelFavoriteCategories.bottomAnchor,
                     left: profileView.cardView.leftAnchor,
                     paddingTop: 8,paddingLeft: 16)
        textViewFavoriteCategories.textContainerInset = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 5)
        
        profileView.buttonOK.anchor(top: textViewFavoriteCategories.bottomAnchor,
                                    left: view.leftAnchor,
                                    right: view.rightAnchor,
                                    paddingTop: 32, paddingLeft: 16, paddingRight: 16,height: 39)
       
        

    }
    
    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               self.textViewNameChannel.resignFirstResponder()
               self.textViewNameChannel.resignFirstResponder()
               self.textViewDescription.resignFirstResponder()
               self.textViewFacebook.resignFirstResponder()
               self.textViewInstagram.resignFirstResponder()
               self.textViewTwitter.resignFirstResponder()
               self.textViewFavoriteCategories.resignFirstResponder()
               return true
           }
           return true
       }
 
}


