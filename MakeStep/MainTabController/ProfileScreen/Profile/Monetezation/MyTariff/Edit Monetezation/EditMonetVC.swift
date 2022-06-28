//
//  EditMonetVC.swift
//  MakeStep
//
//  Created by Sergey on 07.11.2021.
//


import Foundation
import Combine
import UIKit
import EasyPeasy
import iOSDropDown
import Loaf



class EditMonetVC: UIViewController ,UITextViewDelegate, UITextFieldDelegate {
      
    let chatView = EditMonetVCCode()
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
  
    
    var color: UIColor?
    var tint: UIColor?
    var navBar: CGFloat?
    
    private let maxHeight: CGFloat = 100
    var channelId: Int?
    var id: SubPlan?
    
    
    weak var delagateFrame: AddFrame?
    
      
    private var isOversized = false {
        didSet {
            self.chatView.textViewName.easy.reload()
            self.chatView.textViewName.isScrollEnabled = isOversized
            self.chatView.textViewDescription.easy.reload()
            self.chatView.textViewDescription.isScrollEnabled = isOversized
            }
        }
           
    private var take: AnyCancellable?
    @Inject var fitMeetApi: FitMeetChannels

    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
  
    
    private var aspectRatioTextViewConstraint: NSLayoutConstraint?
    private var tvHeightConstraint: NSLayoutConstraint?
    let actionChatTransitionManager = ActionTransishionChatManadger()
    
    
    var listBroadcast: [BroadcastResponce] = []
    var broadcast: BroadcastResponce?
    private let refreshControl = UIRefreshControl()
    var flowHeightConstraint: NSLayoutConstraint?
    var frameViewY: CGFloat = 0
    
   
    //MARK - LifeCicle
    override func loadView() {
        view = chatView
        self.view.backgroundColor = UIColor.white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        frameViewY = self.view.frame.origin.y
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        registerForKeyboardNotifications()
        setMonnetezation()
        self.chatView.textViewName.delegate = self
        self.chatView.textViewName.easy.layout(Left(16),Right(16),Height(maxHeight).when({[unowned self] in self.isOversized}))
        
        self.chatView.textViewDescription.delegate = self
        self.chatView.textViewDescription.easy.layout(Left(16),Right(16),Bottom(40).to(chatView.buttonSave),Height(maxHeight).when({[unowned self] in self.isOversized}))
        
        self.chatView.textFieldPeriodType.delegate = self
        self.chatView.textFieldPeriodType.isSearchEnable = false
        self.chatView.textFieldPeriodType.optionArray = ["1 month"]
        
        self.chatView.textFieldPrice.delegate = self
        self.chatView.textFieldPrice.isSearchEnable = false
        self.chatView.textFieldPrice.optionArray = ["$5.99"]


        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatView.backgroundColor = color
        chatView.cardView.backgroundColor = color

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Loaf.dismiss(sender: EditMonetVC())
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        

    }
    private func setMonnetezation() {
        guard let id = id else { return }
        chatView.textViewName.text = id.name
        chatView.textFieldPeriodType.text = "1 month"
        chatView.textViewDescription.text = id.description
        chatView.textFieldPrice.text = "$5.99"

    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }

    func actionButton() {
        self.chatView.buttonSave.addTarget(self, action: #selector(actionSave), for: .touchUpInside)
        self.chatView.buttonCancel.addTarget(self, action: #selector(actionCancel), for: .touchUpInside)
    }
   
 
    @objc func actionSave() {
        guard let channelId = self.channelId,
              let name = self.chatView.textViewName.text,
              let periodType = self.chatView.textFieldPeriodType.text,
              let price = self.chatView.textFieldPrice.text,
              let description = self.chatView.textViewDescription.text,
              let id = self.id?.subscriptionPriceId  else { return }
        
       
        let components = periodType.components(separatedBy: " ")
        
        bindingChannel(id: channelId, sub: NewSub(newPlans: nil,
                                                  editSubscriptionPrices: [EditSubscriptionPrice(id: id, name: name, price: 599, periodType: components[0], periodCount: Int(components[1]), description: description, available: true)], disableSubscriptionPriceIds: nil))
      
       
    }
 

    @objc func actionCancel() {
        chatView.buttonCancel.backgroundColor = UIColor(hexString: "#3B58A4")
        chatView.buttonCancel.setTitleColor(UIColor.white, for: .normal)
        
        chatView.buttonSave.backgroundColor = .clear
        chatView.buttonSave.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    func bindingChannel(id:Int,sub:NewSub) {
        take = fitMeetApi.monnetChannels(id: id, sub: sub)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                print("responce = \(response)")
                var loafStyle = Loaf.State.info
                loafStyle = Loaf.State.success
                guard let ids = self.id?.name else { return  }

                if response.message == nil {
                    self.view.endEditing(true)
                    DispatchQueue.main.async {
                    Loaf(" Saved" + " in \(ids)", state: loafStyle, location: .bottom, sender:  self).show(.short) { disType in
                            switch disType {
                                     case .tapped: print("Tapped!")
                                     case .timedOut: self.dismiss(animated: true) {
                                self.delagateFrame?.addFrame()
                            }
                        }
                    }
                }
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
       
      // write source code handle when keyboard will show
        let info = notificiation.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            if self.view.frame.origin.y == self.frameViewY {
                self.view.frame.origin.y -= keyboardFrame.size.height
                self.view.layoutIfNeeded()
            }
            
        })
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
       // write source code handle when keyboard will be hidden
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.frame.origin.y += keyboardFrame.size.height
            self.delagateFrame?.addFrame()
            self.view.layoutIfNeeded()
            })

    }
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
       
       }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)

        }

    func textViewDidBeginEditing(_ textView: UITextView) {
//        if self.chatView.textViewName.text == "Name" {
//            self.chatView.textViewName.text = ""
//            self.chatView.textViewName.textColor = UIColor.black
//            self.chatView.textViewName.font = UIFont.systemFont(ofSize: 18)
//            }
//        if self.chatView.textViewDescription.text == "Description" {
//            self.chatView.textViewDescription.text = ""
//            self.chatView.textViewDescription.textColor = UIColor.black
//            self.chatView.textViewDescription.font = UIFont.systemFont(ofSize: 18)
//            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.chatView.textViewName.text == "" {
            self.chatView.textViewName.text = "Name"
            self.chatView.textViewName.textColor = UIColor.lightGray
            self.chatView.textViewName.font =  UIFont.systemFont(ofSize: 18)
            }
        if self.chatView.textViewDescription.text == "" {
            self.chatView.textViewDescription.text = "Description"
            self.chatView.textViewDescription.textColor = UIColor.lightGray
            self.chatView.textViewDescription.font =  UIFont.systemFont(ofSize: 18)
            }
        }
    
    }

