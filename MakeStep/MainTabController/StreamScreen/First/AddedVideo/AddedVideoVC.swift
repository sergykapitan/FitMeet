//
//  AddedVideoVC.swift
//  MakeStep
//
//  Created by Sergey on 07.02.2022.
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
import AVKit

class AddedVideoVC: UIViewController, DropDownTextFieldDelegate, UIScrollViewDelegate, TagListViewDelegate {
    
    func menuDidAnimate(up: Bool) {
        print("menuDidAnimate")
    }
    
    func optionSelected(option: String) {
        print("optionSelected===========\(option)")
    }
    
    
    let authView = AddedVideoCode()
    

    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetStream: FitMeetStream
    @Inject var fitMeetChanell: FitMeetChannels
    
    var imagePicker: ImagePicker!
    var videoPicker: VideoPicker!
    
    var image: String?
    
    var name: String = "JOPE"
    var user: User?
    var videoURl: URL?

    private var take: AnyCancellable?
    private var takeChannel: AnyCancellable?
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
    
    let serviceProvider = Serviceprovider<CharacterProvider>()
   // let request: URLRequest?
    
    private var dropDown: DropDownTextField!
    var listCategory: [Datum] = []
    var IdCategory = [Int]()
    
    private var isOversized = false {
            didSet {
                self.authView.textFieldCategory.easy.reload()
              //  self.authView.textFieldCategory.isScrollEnabled = isOversized
           
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        authView.tagView.removeAllTags()
       

    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authView.cardView.anchor( left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 0, paddingRight: 0)
        self.authView.imageButton.setBackgroundImage(#imageLiteral(resourceName: "Rectangle 966gggg"), for: .normal)
        self.authView.buttonOK.setTitle("OK", for: .normal)
        self.authView.labelNameVOD.isHidden = true
        self.authView.resetVideo.isHidden = true
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavItem()
        bindingChanell()
        bindingUser()
        bindingCategory()
        self.hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        authView.tagView.delegate = self
    
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(self.scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        authView.scroll.addGestureRecognizer(scrollViewTap)
        
        authView.textFieldName.delegate = self
        authView.textFieldDescription.delegate = self
        authView.scroll.delegate = self
   
        authView.textFieldCategory.delegate = self
      //  authView.textFieldStartDate.delegate = self
        authView.textFieldAviable.delegate = self
        authView.textFieldFree.delegate = self
       
       // authView.textFieldStartDate.isSearchEnable = true
        authView.textFieldAviable.isSearchEnable = false
        authView.textFieldFree.isSearchEnable = false
        
       // self.authView.textFieldCategory.easy.layout(Left(10),Right(10),Height(maxHeight).when({[unowned self] in self.isOversized}))
      
      //  authView.textFieldStartDate.optionArray = ["NOW", "Later"]
        
        authView.textFieldAviable.optionArray = ["All","Suscribers","PPV","Private room"]
       
        
        authView.textFieldFree.optionArray = ["Free", "0,99","1,99","2,99","3,99","4,99","5,99","6,99", "7,99","8,99","9,99","10,99","11,99","12,99", "13,99","14,99","15,99","16,99","17,99", "18,99", "19,99", "20,99", "21,99", "22,99", "23,99", "24,99", "25,99", "26,99",  "27,99", "28,99","29,99","30,99", "31,99","32,99", "33,99", "34,99","35,99","36,99","37,99", "38,99", "39,99", "40,99", "41,99", "42,99","43,99","44,99","45,99","46,99","47,99", "48,99","49,99"]
        authView.textFieldFree.isHidden = true
        
        changeData()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.videoPicker = VideoPicker(presentationController: self, delegate: self)
        
        actionButtonContinue()
        authView.buttonContinue.isUserInteractionEnabled = false
        
            authView.textFieldCategory.didSelect { (ff, _, _) in

                let j =  self.authView.tagView.tagViews.filter {$0.titleLabel?.text == ff}
                if j.isEmpty {
                    self.authView.tagView.addTag(ff)
                } else {
                    Loaf("Not Saved \(ff)", state: Loaf.State.error, location: .bottom, sender:  self).show(.short)
                }
                
                
            let p = self.listCategory.filter{$0.title == ff}.compactMap{$0.id}
            self.IdCategory.append(contentsOf: p)
            self.authView.tagView.layoutSubviews()
            self.authView.textFieldCategory.placeholder = ""
                        
        }
        authView.textFieldCategory.easy.layout(Height(>=39))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.authView.textFieldCategory.text = ""
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
           print("Tag Remove pressed: \(title), \(sender)")
           sender.removeTagView(tagView)
           let p = self.listCategory.filter{$0.title == title}.compactMap{$0.id}
       
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
                UIView.animate(withDuration: 0.5) {
                   // self.authView.textFieldDescription.frame.origin.y -= 50
                   // self.authView.buttonOK.frame.origin.y -= 50

                }
             //   self.authView.scroll.contentOffset.y = 100
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
//        authView.textFieldStartDate.didSelect { (gg, tt, hh) in
//            if gg == "NOW" {
//                self.authView.buttonOK.setTitle("OK", for: .normal)
//                self.authView.buttonOK.isUserInteractionEnabled = true
//
//            } else {
//                self.authView.buttonOK.setTitle("Planned", for: .normal)
//                self.authView.buttonOK.isUserInteractionEnabled = true
//            }
//        }
         //All/Suscribers/PPV/Private room
        authView.textFieldAviable.didSelect { (str, ind, col) in
            if str == "All" || str == "Suscribers"{
                if self.authView.textFieldDescription.frame.origin.y == 463.0 {
                UIView.animate(withDuration: 0.5) {
                    self.authView.textFieldDescription.frame.origin.y -= 50
                    self.authView.buttonOK.frame.origin.y -= 50
                  
                } completion: { (bool) in
                    if bool {
                        self.authView.textFieldFree.isHidden = true
                        self.authView.textFieldFree.isUserInteractionEnabled = false
                    }
                }
            }
        } else if str == "PPV" {
            if self.authView.textFieldDescription.frame.origin.y == 413.0 {
            UIView.animate(withDuration: 0.5) {
                self.authView.textFieldDescription.frame.origin.y += 50
                self.authView.buttonOK.frame.origin.y += 50
              
            } completion: { (bool) in
                if bool {
                    self.authView.textFieldFree.isHidden = false
                    self.authView.textFieldFree.isUserInteractionEnabled = true
                }
            }
            self.authView.textFieldFree.isHidden = false
            self.authView.textFieldFree.isUserInteractionEnabled = true
       }
        }
   
    }
//        authView.textFieldStartDate.didSelect { (ff, _, _) in
//                       if ff == "Later" {
//                        self.showPicker()
//                        self.authView.buttonOK.setTitle("Planned", for: .normal)
//                        self.authView.buttonOK.isUserInteractionEnabled = true
//                       }
//                   }
}
//    private func showPicker() {
//        var style = DefaultStyle()
//        style.pickerColor = StyleColor.colors([style.textColor, .red, .blue])
//        style.pickerMode = .dateAndTime
//        style.titleString = "Please Сhoose Date"
//        style.returnDateFormat = .yyyy_To_ss
//        style.minimumDate = Date()
//        style.maximumDate = Date().addingTimeInterval(3600*24*7*52)
//        style.titleFont = UIFont.systemFont(ofSize: 25, weight: .bold)
//
//        style.textColor = UIColor(hexString: "#3B58A4")
//        let pick:PresentedViewController = PresentedViewController()
//        pick.style = style
//        pick.block = { [weak self] (date) in
//        //    self?.authView.textFieldStartDate.text = date
//        }
//        self.present(pick, animated: true, completion: nil)
//    }

    func actionButtonContinue() {
        authView.buttonOK.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        authView.imageButton.addTarget(self, action: #selector(actionUploadImage), for: .touchUpInside)
        authView.buttonUploadVideo.addTarget(self, action: #selector(actionUploadVideo), for: .touchUpInside)
        authView.resetVideo.addTarget(self, action: #selector(resetVideo), for: .touchUpInside)
    }
    @objc func resetVideo() {
        self.videoURl = nil
        self.authView.buttonUploadVideo.isHidden = false
        self.authView.resetVideo.isHidden = true
        self.authView.labelNameVOD.isHidden = true
        
    }
        
    @objc func actionSignUp() {

        guard let chanelId = listChanell.last?.id ,
              let name = authView.textFieldName.text ,
              let description = authView.textFieldDescription.text,
              let img = image  else { return }
              //let planedDate = authView.textFieldStartDate.text
        
        UserDefaults.standard.set(self.listChanell.last?.id, forKey: Constants.chanellID)
        var isPlan: Bool?
        var date: String?
        
        var onlyForSponsors : Bool?
        var onlyForSubscribers: Bool?
        
//        if authView.textFieldStartDate.text == "NOW" {
//            isPlan = false
//            date = "\(Date())"
//        } else {
//
//            isPlan = true
//            date = authView.textFieldStartDate.text
//        }
        //"All","Subscribers", "Only Sponsors"
        if authView.textFieldAviable.text == "All" {
             onlyForSponsors = false
             onlyForSubscribers = false
        } else if authView.textFieldAviable.text == "Suscribers" {
            onlyForSponsors = false
            onlyForSubscribers = true
        } else if authView.textFieldAviable.text == "PPV" {
            onlyForSponsors = true
            onlyForSubscribers = false
        }
        
        
        guard
              
              let sponsor = onlyForSponsors,
              let sub = onlyForSubscribers,
              let video = self.videoURl  else { return }
        
       
        self.encodeVideo(at: video) { url, error in
        
                    do {
                        let data = try Data(contentsOf: url!, options: .mappedIfSafe)//.mappedIfSafe)
                        self.takeChannel = self.fitMeetApi.uploadVideo(image: data, channelId: "\(chanelId)", preview:  (self.imageUpload?.data?.first?.filename)!, title: name, description: description, categoryId: self.IdCategory)
                                   .mapError({ (error) -> Error in
                                       return error })
                                   .sink(receiveCompletion: { _ in }, receiveValue: { response in
                                       if response != nil  {
                                           Loaf("Upload Video  \(response.name!)", state: Loaf.State.success, location: .bottom, sender:  self).show(.short) { disType in
                                               switch disType {
                                               case .tapped: self.gotoChannel()
                                               case .timedOut: self.gotoChannel()
                                           }
                                           }
         
                                       }
                               })
                          //  here you can see data bytes of selected video, this data object is upload to server by multipartFormData upload
                           } catch  {
                               print("ERRRRR")
                       }
            }
     
        
     //   self.nextView(chanellId: chanelId, name: name, description: description, previewPath: img, isPlaned: isP, date: d, onlyForSponsors: sponsor, onlyForSubscribers: sub, categoryId: self.IdCategory)
     
    }
    
    private func gotoChannel() {
        let channelVC = ChanellVC()
        channelVC.user = self.user
        self.navigationController?.pushViewController(channelVC, animated: true)
    }
    
    
    @objc func actionUploadImage(_ sender: UIButton) {
        self.imagePicker.present(from: sender)

    }
    @objc func actionUploadVideo(_ sender: UIButton) {
        self.videoPicker.present(from: sender)

    }
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Add Video"
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
                        self.authView.textFieldAviable.optionArray = ["All","Suscribers","PPV","Private room"]//,"Only Sponsors"
                    }
                }
        })
    }
    func bindingImage(image: UIImage) {
        takeChannel = fitMeetApi.uploadImage(image: image)
            .mapError({ (error) -> Error in return error })
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
//    func nextView(chanellId: Int ,name: String , description: String,previewPath: String,isPlaned: Bool,date: String,onlyForSponsors: Bool,onlyForSubscribers:Bool,categoryId: [Int])  {
//
//        takeChannel = fitMeetStream.createBroadcas(broadcast: BroadcastRequest(
//                                                    channelID: chanellId,
//                                                    name: name,
//                                                    type: "STANDARD",
//                                                    access: "ALL",
//                                                    hasChat: true,
//                                                    isPlanned: isPlaned,
//                                                    onlyForSponsors: onlyForSponsors,
//                                                    onlyForSubscribers: onlyForSubscribers,
//                                                    categoryIDS: categoryId,
//                                                    scheduledStartDate: date,
//                                                    description: description,
//                                                    previewPath: self.imageUpload?.data?.first?.filename))
//
//            .mapError({ (error) -> Error in return error })
//            .sink(receiveCompletion: { _ in }, receiveValue: { response in
//                if let id = response.id  {
//
//                    print("greate broadcast")
//                    guard let usId = self.userId else { return }
//                    self.broadcast = response
//                    UserDefaults.standard.set(self.broadcast?.id, forKey: Constants.broadcastID)
//                    self.fetchStream(id: self.broadcast?.id, name: name)
//
//                    self.authView.textFieldName.text = ""
//                    self.authView.textFieldFree.text = ""
//                    self.authView.textFieldAviable.text = ""
//                    self.authView.textFieldDescription.text = ""
//                    self.authView.textFieldCategory.text = ""
//                    self.authView.imageButton.setImage(nil, for: .normal)
//
//                } else {
//                    guard let mess = response.message else { return }
//                    Loaf("Not Saved \(mess)", state: Loaf.State.error, location: .bottom, sender:  self).show(.short)
//                }
//             })
//
//         }
    
//    func fetchStream(id:Int?,name: String?) {
//        let UserId = UserDefaults.standard.string(forKey: Constants.userID)
//        guard let id = id , let name = name , let userId = UserId  else{ return }
//        let usId = Int(userId)
//        guard let usID = usId else { return }
//        taskStream = fitMeetStream.startStream(stream: StartStream(name: name, userId: usID , broadcastId: id))
//            .mapError({ (error) -> Error in
//                  print(error)
//                   return error })
//                 .sink(receiveCompletion: { _ in }, receiveValue: { response in
//                    guard let url = response.url else { return }
//                     if url != nil {
//                     DispatchQueue.main.async {
//                         AppUtility.lockOrientation(.all, andRotateTo: .portrait)
//                         Loaf("Start  \(response.name!)", state: Loaf.State.success, location: .bottom, sender:  self).show(.short) { disType in
//                             switch disType {
//                             case .tapped:  self.startStream(id: id, url: url)
//                            case .timedOut: self.startStream(id: id, url: url)
//                         }
//                     }
//                 }
//             } else {
//                 Loaf("Not Saved \(response.message!)", state: Loaf.State.error, location: .bottom, sender:  self).show(.short)
//             }
//        })
//    }
    
    private func startStream(id : Int, url : String) {
        UserDefaults.standard.set(url, forKey: Constants.urlStream)
        let twoString = self.removeUrl(url: url)
        self.myuri = twoString.0
        self.myPublish = twoString.1
        self.url = url

        
//        if self.authView.textFieldStartDate.text == "NOW" {
//            let navVC = LiveStreamViewController()
//            navVC.modalPresentationStyle = .fullScreen
//            navVC.idBroad = id
//            guard let myuris = self.myuri,let myPublishh = self.myPublish else { return }
//            navVC.myuri = myuris
//            navVC.myPublish = myPublishh
//           // self.present(navVC, animated: true, completion: nil)
//            self.present(navVC, animated: true) {
//                self.authView.textFieldStartDate.text = ""
//            }
//        } else {
//            let channelVC = ChanellVC()
//            channelVC.user = self.user
//            self.navigationController?.pushViewController(channelVC, animated: true)
//
//        }
   }

    func removeUrl(url: String) -> (url:String,publish: String) {
        let fullUrlArr = url.components(separatedBy: "/")
        let myuri = fullUrlArr[0] + "//" + fullUrlArr[2] + "/" + fullUrlArr[3]
        let myPublish = fullUrlArr[4]
        return (myuri,myPublish)
    }
    
   
   
}
extension AddedVideoVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string

        if textField == authView.textFieldName {
            
        if fullString == "" {
            authView.buttonOK.backgroundColor = UIColor(red: 0.231, green: 0.345, blue: 0.643, alpha: 0.5)
            authView.buttonOK.isUserInteractionEnabled = false
        } else {
           // authView.buttonOK.backgroundColor = UIColor(hexString: "2kWkNSZaD5T")
            authView.buttonOK.backgroundColor = UIColor(hexString: "#3B58A4")
            authView.buttonOK.isUserInteractionEnabled = true
          }
        }
        
//        if textField == authView.textFieldStartDate {
//            print("hhhhhhhh============\(fullString)")
//            if fullString == "NOW" {
//               // authView.buttonOK.backgroundColor = UIColor(hexString: "2kWkNSZaD5T")
//                authView.buttonOK.setTitle("OK", for: .normal)
//                authView.buttonOK.isUserInteractionEnabled = true
//            } else {
//              //  authView.buttonOK.backgroundColor = UIColor(hexString: "2kWkNSZaD5T")
//                authView.buttonOK.setTitle("Planned", for: .normal)
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
//        if textField == authView.textFieldStartDate {
//            self.authView.textFieldName.resignFirstResponder()
//            return true
//        }
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
            return false
        }
}

extension AddedVideoVC: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.authView.imageButton.setImage(image, for: .normal)
        
        guard let imagee = image else { return }
        bindingImage(image: imagee)
        let imageData:Data = imagee.pngData()!
       
        let imageStr = imageData.base64EncodedString()
        self.image = imageStr

    }
}
extension AddedVideoVC: VideoPickerDelegate {
    
    // Don't forget to import AVKit
    func encodeVideo(at videoURL: URL, completionHandler: ((URL?, Error?) -> Void)?)  {
        let avAsset = AVURLAsset(url: videoURL, options: nil)
            
        let startDate = Date()
            
        //Create Export session
        guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
            completionHandler?(nil, nil)
            return
        }
            
        //Creating temp path to save the converted video
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let filePath = documentsDirectory.appendingPathComponent("rendered-Video.mp4")
            
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                completionHandler?(nil, error)
            }
        }
            
        exportSession.outputURL = filePath
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession.timeRange = range
            
        exportSession.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession.status {
            case .failed:
                print(exportSession.error ?? "NO ERROR")
                completionHandler?(nil, exportSession.error)
            case .cancelled:
                print("Export canceled")
                completionHandler?(nil, nil)
            case .completed:
                //Video conversion finished
                let endDate = Date()
                    
                let time = endDate.timeIntervalSince(startDate)
                print(time)
                print("Successful!")
                print(exportSession.outputURL ?? "NO OUTPUT URL")
                completionHandler?(exportSession.outputURL, nil)
                    
                default: break
            }
                
        })
    }
 
    func didSelectVideo(video: URL?) {
      
        guard let video = video else { return }
        self.videoURl = video
        self.authView.buttonUploadVideo.isHidden = true
        self.authView.labelNameVOD.isHidden = false
        self.authView.resetVideo.isHidden = false
        
        let name = self.separateUrl(url: video)
        self.authView.labelNameVOD.text = name
        

//        self.encodeVideo(at: video) { url, error in
//
//            do {
//                let data = try Data(contentsOf: url!, options: .mappedIfSafe)//.mappedIfSafe)
//                       print(data)
//         //   guard let url = url else { return }
//                self.takeChannel = self.fitMeetApi.uploadVideo(image: data)
//                           .mapError({ (error) -> Error in
//                               print("ERROR = \(error)")
//                               return error })
//                           .sink(receiveCompletion: { _ in }, receiveValue: { response in
//                               if response != nil  {
//                                   print("GOODDDDDD")
//                                  // self.imageUpload = response
//
//
//                               }
//                       })
//                  //  here you can see data bytes of selected video, this data object is upload to server by multipartFormData upload
//                   } catch  {
//                       print("ERRRRR")
//               }
//    }
  }
    func separateUrl(url: URL) -> String {
        let urlString = url.absoluteString
        let fullUrlArr = urlString.components(separatedBy: "/")
        let nameVod = fullUrlArr.last
        guard let nameVod = nameVod else { return "" }
        return nameVod
    }
}