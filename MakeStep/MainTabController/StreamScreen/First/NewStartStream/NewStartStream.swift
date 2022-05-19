//
//  NewStartStream.swift
//  FitMeet
//
//  Created by novotorica on 18.06.2021.
//

import Foundation
import UIKit
import ContextMenuSwift
import AuthenticationServices
import Combine
import BottomPopup
import Alamofire
import EasyPeasy
import Loaf
import TagListView
import iOSDropDown

class NewStartStream: UIViewController, DropDownTextFieldDelegate, UIScrollViewDelegate, TagListViewDelegate,CustomPresentable {
    
    var transitionManager: UIViewControllerTransitioningDelegate?
    
    
    func menuDidAnimate(up: Bool) {
        print("menuDidAnimate")
    }
    func optionSelected(option: String) {
        print("optionSelected===========\(option)")
    }
    var scrollViewBottomConstrain = NSLayoutConstraint()
    var bottomConstraint = NSLayoutConstraint()
    
    let authView = NewStartStreamCode()

    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetStream: FitMeetStream
    @Inject var fitMeetChanell: FitMeetChannels
    
    var imagePicker: ImagePicker!
    
    var image: String?
    
    var name: String = "JOPE"
    var user: User?

    private var take: AnyCancellable?
    private var takeChannel: AnyCancellable?
    private var takeImage: AnyCancellable?
    private var takeBroadcast: AnyCancellable?
    private var taskStream: AnyCancellable?
    
    
    let channelId = UserDefaults.standard.string(forKey: Constants.chanellID)
    let userId = UserDefaults.standard.string(forKey: Constants.userID)
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    
    
    private var chanellName: String?
    private var titleChanell: String?
    private var descriptionChanell: String?
    
    var listBroadcast: [BroadcastResponce] = []
    var listChanell: [ChannelResponce] = []
    var broadcast:  BroadcastResponce?
    
    var imageUpload: UploadImage?
    
    let date = Date()
    var url: String?
    var myuri: String?
    var myPublish: String?
    var status = "STANDARD"
    let serviceProvider = Serviceprovider<CharacterProvider>()
  
    
    private var dropDown: DropDownTextField!
    
    var listCategory: [Datum] = []
    var IdCategory = [Int]()
    
    private var isOversized = false {
            didSet {
                self.authView.textFieldCategory.easy.reload()
            }
        }
    private let maxHeight: CGFloat = 100
    
    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override func loadView() {
        super.loadView()
        view = authView
//        scrollViewBottomConstrain = authView.scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        NSLayoutConstraint.activate([
//
//            authView.scroll.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollViewBottomConstrain,
//            authView.scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            authView.scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//        ])
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
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
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindingChanell()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        makeNavItem()
        bindingUser()
        bindingCategory()
        self.hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        authView.tagView.delegate = self
                        authView.buttonOK.backgroundColor = .blueColor
                        authView.buttonOK.isUserInteractionEnabled = true
      //  self.authView.buttonOK.isUserInteractionEnabled = false
        setupTapGesture()
//        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(self.scrollViewTapped))
//        scrollViewTap.numberOfTapsRequired = 1
//        authView.scroll.addGestureRecognizer(scrollViewTap)
        
        authView.textFieldName.delegate = self
        authView.textFieldDescription.delegate = self
        authView.scroll.delegate = self
   
        authView.textFieldCategory.delegate = self
        authView.textFieldStartDate.delegate = self
        authView.textFieldAviable.delegate = self
        authView.textFieldFree.delegate = self
       
        authView.textFieldStartDate.isSearchEnable = true
        authView.textFieldAviable.isSearchEnable = false
        authView.textFieldFree.isSearchEnable = false
        
        bottomConstraint = authView.textFieldDescription.topAnchor.constraint(equalTo: authView.textFieldCategory.bottomAnchor, constant: 15)
        bottomConstraint.isActive = true
      
        authView.textFieldStartDate.optionArray = ["Start now", "Schedule a stream"]
        
        authView.textFieldAviable.optionArray = ["Available for all","Private Stream"]
        
        authView.textFieldFree.optionArray = ["Free", "0,99","1,99","2,99","3,99","4,99","5,99","6,99", "7,99","8,99","9,99","10,99","11,99","12,99", "13,99","14,99","15,99","16,99","17,99", "18,99", "19,99", "20,99", "21,99", "22,99", "23,99", "24,99", "25,99", "26,99",  "27,99", "28,99","29,99","30,99", "31,99","32,99", "33,99", "34,99","35,99","36,99","37,99", "38,99", "39,99", "40,99", "41,99", "42,99","43,99","44,99","45,99","46,99","47,99", "48,99","49,99"]
        authView.textFieldFree.isHidden = true
        changeData()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        actionButtonContinue()
        authView.buttonContinue.isUserInteractionEnabled = false
        
        authView.textFieldCategory.didSelect { (ff, _, _) in

            let j =  self.authView.tagView.tagViews.filter {$0.titleLabel?.text == ff}
            if j.isEmpty {
                self.authView.tagView.addTag(ff)
                let p = self.listCategory.filter{$0.title == ff}.compactMap{$0.id}
                self.IdCategory.append(contentsOf: p)
                print("Category == \(self.IdCategory)")
                self.authView.tagView.layoutSubviews()
                self.updatePresentationLayout(animated: true)
            } else {
                Loaf("Not Saved \(ff)", state: Loaf.State.error, location: .bottom, sender:  self).show(.short)
            }
        self.authView.textFieldCategory.placeholder = ""                    
    }
            authView.textFieldCategory.easy.layout(Height(>=39))
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.authView.textFieldCategory.text = ""
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
           sender.removeTagView(tagView)
          let p = self.listCategory.filter{$0.title == title}.compactMap{$0.id}
          guard let id = p.first else { return }
        if IdCategory.contains(id) {
            let index = IdCategory.firstIndex(of: id)
                IdCategory.remove(at: index!)
               print(IdCategory)
            }
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
            if authView.textFieldDescription.isFirstResponder {
                self.authView.scroll.contentOffset.y = 100
        }
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        self.authView.scroll.contentOffset.y = 0
    }
    @objc func scrollViewTapped() {
            authView.scroll.endEditing(true)
            self.view.endEditing(true) // anyone
        }
    func changeData() {
        authView.textFieldAviable.didSelect { (str, ind, col) in
            if str == "Available for all" || str == "Subscribers only" {
                    let trA = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1) {
                        self.bottomConstraint.constant = 15
                        self.authView.textFieldFree.isHidden = true
                        self.authView.textFieldFree.isUserInteractionEnabled = false
                    }
                    self.view.layoutIfNeeded()
                    trA.startAnimation()
        } else if str == "PPV" {
                let transitionAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: {
                    
                    self.bottomConstraint.constant = 65
                    self.authView.textFieldFree.isHidden = false
                    self.authView.textFieldFree.isUserInteractionEnabled = true
                    
                    })
                    self.view.layoutIfNeeded()
                transitionAnimator.startAnimation()
           }
    }
        
//        authView.textFieldStartDate.didSelect { (ff, _, _) in
//                       if ff == "Schedule a stream" {
//                        self.showPicker()
//                           self.authView.buttonOK.setTitle("Planned", for: .normal)
//                       } else {
//                           self.authView.buttonOK.setTitle("Start stream", for: .normal)
//                       }
//                   }
}
    private func showPicker() {
        var style = DefaultStyle()
        style.pickerColor = StyleColor.colors([style.textColor, .red, .blueColor])
        style.pickerMode = .dateAndTime
        style.titleString = "Please Сhoose Date"
        style.returnDateFormat = .yyyy_To_ss
        style.minimumDate = Date()
        style.maximumDate = Date().addingTimeInterval(3600*24*7*52)
        style.titleFont = UIFont.systemFont(ofSize: 25, weight: .bold)
    
        style.textColor = UIColor(hexString: "#3B58A4")
        let pick:PresentedViewController = PresentedViewController()
        pick.style = style
        pick.block = { [weak self] (date) in
            self?.authView.textFieldStartDate.text = date
        }
        self.present(pick, animated: true, completion: nil)
    }
    func actionButtonContinue() {
        authView.buttonOK.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        authView.imageButton.addTarget(self, action: #selector(actionUploadImage), for: .touchUpInside)
    }
    @objc func actionSignUp() {
//        updatePresentationLayout(animated: true)
//        if authView.textFieldAviable.text == "" {
//            authView.textFieldAviable.text = "Available for all"
//        }
//        if authView.textFieldStartDate.text == "" {
//            authView.textFieldStartDate.text = "Start now"
//        }
//
//        guard let chanelId = listChanell.last?.id ,
//              let name = authView.textFieldName.text ,
//              let description = authView.textFieldDescription.text
//               else { return }
//        let img = image ?? ""
//        UserDefaults.standard.set(self.listChanell.last?.id, forKey: Constants.chanellID)
//        var isPlan: Bool?
//        var date: String?
//
//        var onlyForSponsors : Bool?
//        var onlyForSubscribers: Bool?
//
//        if authView.textFieldStartDate.text == "Start now" {
//            isPlan = false
//            date = "\(Date())"
//        } else {
//            isPlan = true
//            date = authView.textFieldStartDate.text
//        }
//
//        if authView.textFieldAviable.text == "Available for all" {
//             onlyForSponsors = false
//             onlyForSubscribers = false
//             status = "STANDARD"
//        } else if authView.textFieldAviable.text == "Subscribers only" {
//            onlyForSponsors = false
//            onlyForSubscribers = true
//            status = "STANDARD"
//        } else if authView.textFieldAviable.text == "Only Sponsors" {
//            onlyForSponsors = true
//            onlyForSubscribers = false
//        } else if authView.textFieldAviable.text == "Private Stream" {
//            onlyForSponsors = false
//            onlyForSubscribers = false
//            status = "PRIVATE_LINK"
//        }
//
//
//        guard let isP = isPlan,
//              let d = date,
//              let sponsor = onlyForSponsors,
//              let sub = onlyForSubscribers else { return }
//
//
//        self.nextView(chanellId: chanelId, name: name, description: description, previewPath: img, isPlaned: isP, date: d, onlyForSponsors: sponsor, onlyForSubscribers: sub, categoryId: self.IdCategory, type: status)
     
    }
    @objc func actionUploadImage(_ sender: UIButton) {
        self.imagePicker.present(from: sender)

    }
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Start Stream"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

                   let stackView = UIStackView(arrangedSubviews: [titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .vertical

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
    func bindingCategory() {
        takeBroadcast = fitMeetStream.getCategoryPrivate()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listCategory = response.data!
                    let list = self.listCategory.compactMap{$0.title}
                    self.authView.textFieldCategory.optionArray = list
                }
        })
    }
    func bindingChanell() {
        takeChannel = fitMeetChanell.listChannels()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listChanell = response.data
                    guard let sub = self.listChanell.last?.isSubscribe else { return }
                    if sub {
                        self.authView.textFieldAviable.optionArray = ["Available for all","Subscribers only","Private Stream"]
                    }
                }
        })
    }
    func bindingImage(image: UIImage) {
        takeImage = fitMeetApi.uploadImage(image: image)
            .mapError({ (error) -> Error in  return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.imageUpload = response
            }
        })
    }
    func bindingUser() {
        take = fitMeetApi.getUser()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                    self.user = response
                    
                }
        })
    }
    func setupTapGesture() {
        authView.tagView.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureSelector))
        authView.tagView.addGestureRecognizer(tap)
    }
    @objc func tapGestureSelector() {
        authView.textFieldCategory.showList()
    }
    func nextView(chanellId: Int ,name: String , description: String,previewPath: String,isPlaned: Bool,date: String,onlyForSponsors: Bool,onlyForSubscribers:Bool,categoryId: [Int],type: String)  {

        takeChannel = fitMeetStream.createBroadcas(broadcast: BroadcastRequest(
                                                    channelID: chanellId,
                                                    name: name,
                                                    type: type,
                                                    access: "ALL",
                                                    hasChat: true,
                                                    isPlanned: isPlaned,
                                                    onlyForSponsors: onlyForSponsors,
                                                    onlyForSubscribers: onlyForSubscribers,
                                                    categoryIDS: categoryId,
                                                    scheduledStartDate: date,
                                                    description: description,
                                                    previewPath: self.imageUpload?.data?.first?.filename))

            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let id = response.id  {
                    guard let usId = self.userId else { return }
                    self.broadcast = response
                    UserDefaults.standard.set(self.broadcast?.id, forKey: Constants.broadcastID)
                    if self.authView.textFieldStartDate.text == "Start now" {
                    self.fetchStream(id: self.broadcast?.id, name: name)
                    } else {
                        let channelVC = ChanellVC()
                        channelVC.user = self.user
                        self.navigationController?.pushViewController(channelVC, animated: true)
                    }
                    self.authView.tagView.removeAllTags()
                    self.authView.textFieldName.text = ""
                    self.authView.textFieldFree.text = ""
                    self.authView.textFieldDescription.text = ""
                    self.authView.textFieldCategory.text = ""
                    self.IdCategory.removeAll()
                    self.authView.imageButton.setImage(nil, for: .normal)
                } else {
                    guard let mess = response.message else { return }
                    Loaf("Not Saved \(mess)", state: Loaf.State.error, location: .bottom, sender:  self).show(.short)
            }
        })
    }
    func fetchStream(id:Int?,name: String?) {
        let UserId = UserDefaults.standard.string(forKey: Constants.userID)
        guard let id = id , let name = name , let userId = UserId  else{ return }
        let usId = Int(userId)
        guard let usID = usId else { return }
        taskStream = fitMeetStream.startStream(stream: StartStream(name: name, userId: usID , broadcastId: id))
            .mapError({ (error) -> Error in
                  print(error)
                   return error })
                 .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    guard let url = response.url else { return }
                     if url != nil {
                     DispatchQueue.main.async {
                         AppUtility.lockOrientation(.all, andRotateTo: .portrait)
                         Loaf("Start  \(response.name!)", state: Loaf.State.success, location: .bottom, sender:  self).show(.short) { disType in
                             switch disType {
                             case .tapped:  self.startStream(id: id, url: url)
                             case .timedOut: self.startStream(id: id, url: url)
                         }
                     }
                 }
             } else {
                 Loaf("Not Saved \(response.message!)", state: Loaf.State.error, location: .bottom, sender:  self).show(.short)
             }
        })
    }
    private func startStream(id : Int, url : String) {
        UserDefaults.standard.set(url, forKey: Constants.urlStream)
        let twoString = self.removeUrl(url: url)
        self.myuri = twoString.0
        self.myPublish = twoString.1
        self.url = url

        
        if self.authView.textFieldStartDate.text == "Start now" {
            let navVC = LiveStreamViewController()
            navVC.modalPresentationStyle = .fullScreen
            navVC.idBroad = id
            guard let myuris = self.myuri,let myPublishh = self.myPublish else { return }
                navVC.myuri = myuris
                navVC.myPublish = myPublishh

        if self.authView.textFieldAviable.text == "Available for all" || self.authView.textFieldAviable.text == "Subscribers only" {
            navVC.isPrivate = false
        } else if self.authView.textFieldAviable.text == "Private Stream"{
            navVC.isPrivate = true
            navVC.broadcastId = self.broadcast?.id
            navVC.privateUrlKey = self.broadcast?.privateUrlKey
        }
    
        self.present(navVC, animated: true) {
            self.authView.textFieldStartDate.text = ""
            self.authView.textFieldAviable.text = ""
        }

        } else {
            let channelVC = ChanellVC()
            channelVC.user = self.user
            self.navigationController?.pushViewController(channelVC, animated: true)

        }
    }
    func removeUrl(url: String) -> (url:String,publish: String) {
        let fullUrlArr = url.components(separatedBy: "/")
        let myuri = fullUrlArr[0] + "//" + fullUrlArr[2] + "/" + fullUrlArr[3]
        let myPublish = fullUrlArr[4]
        return (myuri,myPublish)
    }
  
}
extension NewStartStream: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if textField == authView.textFieldName {
//            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//            if text.isEmpty {
//                authView.buttonOK.backgroundColor = .blueColor.alpha(0.4)
//                authView.buttonOK.isUserInteractionEnabled = false
//            } else {
//                authView.buttonOK.backgroundColor = .blueColor
//                authView.buttonOK.isUserInteractionEnabled = true
//            }
//        }
        return true
    }
    
    func NewStartStream(_ textField: UITextField) -> Bool {
        
        if textField == authView.textFieldName {
            self.authView.textFieldName.resignFirstResponder()
            return true
        }
        if textField == authView.textFieldCategory {
            self.authView.textFieldName.resignFirstResponder()
            return true
        }
        if textField == authView.textFieldStartDate {
            self.authView.textFieldName.resignFirstResponder()
            return true
        }
        if textField == authView.textFieldFree {
            self.authView.textFieldName.resignFirstResponder()
            return true
        }
        if textField == authView.textFieldAviable {
            self.authView.textFieldName.resignFirstResponder()
            return true
        }
        if textField == authView.textFieldDescription {
            self.authView.textFieldName.resignFirstResponder()
            return true
        }
   
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
        if textField == authView.textFieldCategory {
            self.authView.textFieldName.resignFirstResponder()
            return true
        }
     return false
  }
}
extension NewStartStream: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.authView.imageButton.setImage(image, for: .normal)
        guard let imagee = image else { return }
        bindingImage(image: imagee)
        let imageData:Data = imagee.pngData()!       
        let imageStr = imageData.base64EncodedString()
        self.image = imageStr
    }
}
