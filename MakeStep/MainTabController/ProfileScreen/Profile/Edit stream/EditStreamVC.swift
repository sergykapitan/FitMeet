//
//  EditStreamVC.swift
//  MakeStep
//
//  Created by novotorica on 30.09.2021.
//

import Foundation
import UIKit
import ContextMenuSwift
import AuthenticationServices
import Combine
import BottomPopup
import Alamofire
import Kingfisher
import TagListView
import EasyPeasy
import Loaf

protocol RefreshList: AnyObject {
    func refrechList()
}

class EditStreamVC: UIViewController, DropDownTextFieldDelegate, UIScrollViewDelegate,TagListViewDelegate {
    var transitionManager: UIViewControllerTransitioningDelegate?
    
    
    func menuDidAnimate(up: Bool) {
        self.authView.textFieldCategory.text = ""
    }
    func optionSelected(option: String) {
        self.authView.textFieldCategory.text = ""
    }
    var listCategory: [Datum] = []
    
    let authView = EditStreamCode()
    var IdCategory = [Int]()
    var removeIdCategory = [Int]()
    private var isOversized = false {
            didSet {
                self.authView.textFieldCategory.easy.reload()
            }
        }
    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetStream: FitMeetStream
    @Inject var fitMeetChanell: FitMeetChannels
    
    var imagePicker: ImagePicker!
    
    var image: String?
    
    var name: String = "JOPE"
    var user: User?

    private var take: AnyCancellable?
    private var takeChannel: AnyCancellable?
    private var takeBroadcast: AnyCancellable?
    private var taskStream: AnyCancellable?
    
    
    weak var delegate: RefreshList?
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
    var broadcastID: Int?
    
    let serviceProvider = Serviceprovider<CharacterProvider>()
   // let request: URLRequest?
    
    private var dropDown: DropDownTextField!
    
    
    
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

    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authView.cardView.anchor( left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 0, paddingRight: 0)
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        self.bindingCategory()
        self.setBroadcast()
        
        authView.tagView.delegate = self
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(self.scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        authView.scroll.addGestureRecognizer(scrollViewTap)
        
        authView.textFieldName.delegate = self
        authView.textFieldDescription.delegate = self
        authView.scroll.delegate = self
   
        authView.textFieldCategory.delegate = self
        authView.textFieldAviable.delegate = self
        authView.textFieldAviable.isSearchEnable = false        
        authView.textFieldAviable.optionArray = ["Available for all","Subscribers only"]
      
        
        changeData()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        actionButtonContinue()
        authView.buttonContinue.isUserInteractionEnabled = false
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
  
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
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.authView.textFieldCategory.text = ""
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
    @objc func scrollViewTapped() {
            authView.scroll.endEditing(true)
            self.view.endEditing(true) // anyone
        }
    func changeData() {
        authView.textFieldAviable.didSelect { (str, ind, col) in
        }

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
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
           sender.removeTagView(tagView)
          let p = self.listCategory.filter{$0.title == title}.compactMap{$0.id}
          guard let id = p.first else { return }
         self.removeIdCategory.append(id)

       }
   
    func actionButtonContinue() {
        authView.buttonOK.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        authView.imageButton.addTarget(self, action: #selector(actionUploadImage), for: .touchUpInside)
    }
    @objc func actionSignUp() {
        guard
              let name = authView.textFieldName.text ,
              let description = authView.textFieldDescription.text else { return }
        
       
        let img = image ?? ""
        let  date = self.broadcast?.scheduledStartDate ?? ""
        var onlyForSponsors : Bool?
        var onlyForSubscribers: Bool?
     
       
        
        if authView.textFieldAviable.text == "Available for all"  {
             onlyForSponsors = false
             onlyForSubscribers = false
        } else if authView.textFieldAviable.text == "Subscribers only" {
            onlyForSponsors = false
            onlyForSubscribers = true
        }
        guard
              let sponsor = onlyForSponsors,
              let sub = onlyForSubscribers else { return }

        self.nextView( name: name, description: description, previewPath: img, isPlaned: false, date: date, onlyForSponsors: sponsor, onlyForSubscribers: sub, categoryId: self.IdCategory)
     
    }
    @objc func actionUploadImage(_ sender: UIButton) {
        self.imagePicker.present(from: sender)

    }
    func bindingImage(image: UIImage) {
        takeChannel = fitMeetApi.uploadImage(image: image)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    self.imageUpload = response
        })
    }
    private func setBroadcast() {
        self.authView.textFieldName.text = self.broadcast?.name
        if let onlySubscraiber = broadcast?.onlyForSubscribers {
        if onlySubscraiber {
            self.authView.textFieldAviable.text = "Subscribers only"
        } else {
            self.authView.textFieldAviable.text = "Available for all"
        }
        }
    
        self.authView.textFieldDescription.text = self.broadcast?.description
        let categorys = broadcast?.categories
        let s = categorys!.map{$0.title!}
        let stringRepresentation = s.joined(separator:",")
        
        authView.tagView.addTags(s)
        broadcastID = broadcast?.id
        
        guard let image = self.broadcast?.previewPath else { return }
        let url = URL(string: image)
        self.authView.imageButton.kf.setImage(with:url , for: .normal)
        self.authView.buttonOK.setTitle("Save", for: .normal)
        self.image = broadcast?.previewPath
    }
    func nextView(
                  name: String ,
                  description: String,
                  previewPath: String,
                  isPlaned: Bool,
                  date: String,onlyForSponsors: Bool,onlyForSubscribers:Bool,categoryId: [Int])  {
        guard let id = broadcastID else { return }
        takeChannel = fitMeetStream.editBroadcastId(id: id,
                                                    broadcast: EditBroadcast(
                                                        name: name,
                                                        access: "ALL",
                                                        hasChat: true,
                                                        onlyForSponsors: onlyForSponsors,
                                                        onlyForSubscribers: onlyForSubscribers,
                                                        addCategoryIds: categoryId,
                                                        removeCategoryIds: removeIdCategory,
                                                        previewPath: self.imageUpload?.data?.first?.filename,
                                                        rate: 0,
                                                        description: description, price: nil))


            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let id = response.id {                   
                    self.dismiss(animated: true) {
                        Loaf("Edit :" + response.name!, state: Loaf.State.success, location: .bottom, sender:  self).show(.short)
                        self.delegate?.refrechList()
                }
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
                    UserDefaults.standard.set(url, forKey: Constants.urlStream)
                    let twoString = self.removeUrl(url: url)
                    self.myuri = twoString.0
                    self.myPublish = twoString.1
                    self.url = url
                    
//                    if self.authView.textFieldStartDate.text == "NOW" {
//                        let navVC = LiveStreamViewController()
//                        navVC.modalPresentationStyle = .fullScreen
//                        navVC.idBroad = id
//                        guard let myuris = self.myuri,let myPublishh = self.myPublish else { return }
//                        navVC.myuri = myuris
//                        navVC.myPublish = myPublishh
//                        self.present(navVC, animated: true) {
//                            self.authView.textFieldStartDate.text = ""
//                        }
//                    } else {
//                        let channelVC = ChanellVC()
//                        channelVC.user = self.user
//                        self.navigationController?.pushViewController(channelVC, animated: true)
//
//                    }
               })
           }
    func removeUrl(url: String) -> (url:String,publish: String) {
        let fullUrlArr = url.components(separatedBy: "/")
        let myuri = fullUrlArr[0] + "//" + fullUrlArr[2] + "/" + fullUrlArr[3]
        let myPublish = fullUrlArr[4]
        return (myuri,myPublish)
    }
    func setImageLogo(image:String) {
        let url = URL(string: image)
        authView.imageButton.kf.setImage(with: url, for: .normal)
       
    }
  
}
extension EditStreamVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string

        if textField == authView.textFieldName {
            
        if fullString == "" {
            authView.buttonOK.backgroundColor = .blueColor
            authView.buttonOK.isUserInteractionEnabled = true
           
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
extension EditStreamVC: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.authView.imageButton.setImage(image, for: .normal)
        
        guard let imagee = image else { return }
        bindingImage(image: imagee)
        let imageData:Data = imagee.pngData()!
       
        let imageStr = imageData.base64EncodedString()
        self.image = imageStr

    }
}
