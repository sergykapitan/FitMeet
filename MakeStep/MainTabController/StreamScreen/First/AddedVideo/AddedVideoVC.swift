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
        self.authView.textFieldCategory.text = ""
    }
    func optionSelected(option: String) {
        self.authView.textFieldCategory.text = ""
    }
    var bottomConstraint = NSLayoutConstraint()
    var scrollViewBottomConstrain = NSLayoutConstraint()
    
    
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
        scrollViewBottomConstrain = authView.scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
 
            authView.scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scrollViewBottomConstrain,
            authView.scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authView.scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavItem()
        bindingChanell()
        bindingUser()
        bindingCategory()
        setupKeyboardNotifications()
        self.hideKeyboardWhenTappedAround()
       
        authView.tagView.delegate = self
        
        bottomConstraint = authView.textFieldDescription.topAnchor.constraint(equalTo: authView.textFieldAviable.bottomAnchor, constant: 15)
        bottomConstraint.isActive = true
    
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(self.scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        authView.scroll.addGestureRecognizer(scrollViewTap)
        authView.buttonOK.isUserInteractionEnabled = false
        authView.textFieldName.delegate = self
        authView.textFieldDescription.delegate = self
        authView.scroll.delegate = self
   
        authView.textFieldCategory.delegate = self
        authView.textFieldAviable.delegate = self
        authView.textFieldFree.delegate = self
       
        authView.textFieldAviable.isSearchEnable = false
        authView.textFieldFree.isSearchEnable = false
        
        authView.textFieldAviable.optionArray = ["Available for all","Subscribers only"]
        authView.textFieldFree.optionArray = ["Free", "0,99","1,99","2,99","3,99","4,99","5,99","6,99", "7,99","8,99","9,99","10,99","11,99","12,99", "13,99","14,99","15,99","16,99","17,99", "18,99", "19,99", "20,99", "21,99", "22,99", "23,99", "24,99", "25,99", "26,99",  "27,99", "28,99","29,99","30,99", "31,99","32,99", "33,99", "34,99","35,99","36,99","37,99", "38,99", "39,99", "40,99", "41,99", "42,99","43,99","44,99","45,99","46,99","47,99", "48,99","49,99"]
        authView.textFieldFree.isHidden = true
        
        changeData()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.videoPicker = VideoPicker(presentationController: self, delegate: self)
        setupTapGesture()
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
    deinit{
        removeKeyboardNotifications()
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
           sender.removeTagView(tagView)
           let p = self.listCategory.filter{$0.title == title}.compactMap{$0.id}
       
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
   }
    func setupTapGesture() {
        authView.tagView.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureSelector))
        authView.tagView.addGestureRecognizer(tap)
    }
    @objc func tapGestureSelector() {
        authView.textFieldCategory.showList()
    }
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
              let video = self.videoURl,
              let image = self.imageUpload?.data?.first?.filename   else {
                  Loaf("Not Saved video and image", state: Loaf.State.error, location: .bottom, sender:  self).show(.short)
                  return }
        
        UserDefaults.standard.set(self.listChanell.last?.id, forKey: Constants.chanellID)
        self.authView.buttonOK.backgroundColor = .blueColor.alpha(0.4)
        self.authView.buttonOK.isUserInteractionEnabled = false
        self.view.addBlur()       
        self.encodeVideo(at: video) { url, error in
           
                    do {
                        let data = try Data(contentsOf: url!, options: .mappedIfSafe)
                        self.takeChannel = self.fitMeetApi.uploadVideo(image: data, channelId: "\(chanelId)", preview: image, title: name, description: description, categoryId: self.IdCategory)
                                   .mapError({ (error) -> Error in
                                       return error })
                                   .sink(receiveCompletion: { _ in }, receiveValue: { response in
                                       if response.vodUrl != nil  {
                                           self.authView.imageButton.setImage(nil, for: .normal)
                                           self.view.removeBlurA()
                                           self.authView.textFieldName.text = ""
                                           self.authView.textFieldAviable.text = ""
                                           self.authView.textFieldDescription.text = ""
                                           self.authView.tagView.removeAllTags()
                                           self.resetVideo()
                                         
                                           Loaf("Upload Video  \(response.name!)", state: Loaf.State.success, location: .bottom, sender:  self).show(.short) { disType in
                                               switch disType {
                                               case .tapped:
                                                   self.gotoChannel()
                                               case .timedOut:
                                                   self.gotoChannel()
                                           }
                                        }
                                    }
                               })
                          //  here you can see data bytes of selected video, this data object is upload to server by multipartFormData upload
                           } catch  {
                        }
                    }
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
                        self.authView.textFieldAviable.optionArray = ["All","Suscribers","PPV","Private room"]
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
    private func startStream(id : Int, url : String) {
        UserDefaults.standard.set(url, forKey: Constants.urlStream)
        let twoString = self.removeUrl(url: url)
        self.myuri = twoString.0
        self.myPublish = twoString.1
        self.url = url
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
        if textField == authView.textFieldName {
            
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if text.isEmpty {
                authView.buttonOK.backgroundColor = .blueColor.alpha(0.4)
                authView.buttonOK.isUserInteractionEnabled = false
            } else {
                authView.buttonOK.backgroundColor = .blueColor
                authView.buttonOK.isUserInteractionEnabled = true
            }
        }
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

        if textField == authView.textFieldFree {
            self.authView.textFieldName.resignFirstResponder()
            return true
        }
        if textField == authView.textFieldAviable {
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
    
  }
    func separateUrl(url: URL) -> String {
        let urlString = url.absoluteString
        let fullUrlArr = urlString.components(separatedBy: "/")
        let nameVod = fullUrlArr.last
        guard let nameVod = nameVod else { return "" }
        return nameVod
    }
}
extension AddedVideoVC {
    
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if authView.textFieldDescription.isFirstResponder {
               let keyboardHeight = keyboardFrame.cgRectValue.height
                self.authView.scroll.contentOffset.y =  authView.buttonOK.frame.minY - keyboardHeight - authView.buttonOK.bounds.height
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        scrollViewBottomConstrain.constant = 0
        self.authView.scroll.contentOffset.y = 0
    }
}
