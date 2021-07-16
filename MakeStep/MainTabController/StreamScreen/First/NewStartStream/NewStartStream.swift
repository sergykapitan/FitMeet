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

class NewStartStream: UIViewController, DropDownTextFieldDelegate, UIScrollViewDelegate {
    
    func menuDidAnimate(up: Bool) {
        print("menuDidAnimate")
    }
    
    func optionSelected(option: String) {
        print("optionSelected")
    }
    
    
    let authView = NewStartStreamCode()
    

    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetStream: FitMeetStream
    @Inject var fitMeetChanell: FitMeetChannels

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
    
    let date = Date()
    var url: String?
    var myuri: String?
    var myPublish: String?
    
    private var dropDown: DropDownTextField!
    private var flavourOptions = ["Chocolate", "Vanilla", "Strawberry", "Banana", "Lime"]
    
    
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
        authView.textFieldName.text = ""
        authView.textFieldStartDate.text = ""
        authView.textFieldFree.text = ""
        authView.textFieldAviable.text = ""
        authView.textFieldDescription.text = ""
        authView.textFieldCategory.text = ""
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authView.cardView.anchor( left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 0, paddingRight: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavItem()
        bindingChanell()
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(self.scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        authView.scroll.addGestureRecognizer(scrollViewTap)
        
        authView.textFieldName.delegate = self
        authView.textFieldDescription.delegate = self
        authView.scroll.delegate = self
   
        authView.textFieldCategory.delegate = self
        authView.textFieldStartDate.delegate = self
        authView.textFieldAviable.delegate = self
        authView.textFieldFree.delegate = self
       
        authView.textFieldStartDate.isSearchEnable = false
        authView.textFieldAviable.isSearchEnable = false
        authView.textFieldFree.isSearchEnable = false
        
        authView.textFieldCategory.optionArray = ["Yoga", "Dance","Meditation","Muscular endurance","Flexibility","Stretching","Power","Workshop","tennis","Category 661","Category 671"]
        authView.textFieldStartDate.optionArray = ["\(date)", "Later"]
        authView.textFieldAviable.optionArray = ["Subscribers", "Only Sponsors"]
        authView.textFieldFree.optionArray = ["Free", "Not Free"]
        

        actionButtonContinue()

        authView.buttonContinue.isUserInteractionEnabled = false
 
  
    }
    @objc func scrollViewTapped() {
            authView.scroll.endEditing(true)
            self.view.endEditing(true) // anyone
        }
    func actionButtonContinue() {
        authView.buttonContinue.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        authView.buttonOK.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        authView.imageButton.addTarget(self, action: #selector(actionUploadImage), for: .touchUpInside)
    }
    @objc func actionSignUp() {
      print("create broadcast")
        guard let chanelId = listChanell.last?.id ,let name = authView.textFieldName.text ,let description = authView.textFieldDescription.text else { return }
        UserDefaults.standard.set(self.listChanell.last?.id, forKey: Constants.chanellID)
        
        self.nextView(chanellId: chanelId, name: name, description: description)
        print("Date = \(date)")
    }
    @objc func actionUploadImage() {
        print("Upload Image")
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
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
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "Note"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(actionSignUp)),
                                                   UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(actionSignUp))]
    }
    
    func bindingChanell() {
        takeChannel = fitMeetChanell.listChannels()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listChanell = response.data
                    print(self.listChanell.last)
                }
        })
    }
    func nextView(chanellId: Int ,name: String , description: String)  {
       
        takeChannel = fitMeetStream.createBroadcas(broadcast: BroadcastRequest(
                                                    channelID: chanellId,
                                                    name: name,
                                                    type: "STANDARD",
                                                    access: "ALL",
                                                    hasChat: true,
                                                    isPlanned: false,
                                                    onlyForSponsors: false,
                                                    onlyForSubscribers: false,
                                                    categoryIDS: [],
                                                    scheduledStartDate: "2021-06-18T10:50:26.017Z",
                                                    description: description,
                                                    previewPath: "/path/to/file.jpg" ))
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let id = response.id  {
                    print("greate broadcast")
                    guard let usId = self.userId else { return }
                    self.broadcast = response
                    UserDefaults.standard.set(self.broadcast?.id, forKey: Constants.broadcastID)
                    self.fetchStream(id: self.broadcast?.id, name: name)

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
                    print(response)
                    
                    let navVC = LiveStreamViewController()
                    navVC.modalPresentationStyle = .fullScreen
                    guard let myuris = self.myuri,let myPublishh = self.myPublish else { return }
                    navVC.myuri = myuris
                    navVC.myPublish = myPublishh                    
                    self.present(navVC, animated: true, completion: nil)
            })
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
        let fullString = (textField.text ?? "") + string

        if textField == authView.textFieldName {
            
        if fullString == "" {
            authView.buttonOK.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            authView.buttonOK.isUserInteractionEnabled = false
        } else {
            authView.buttonOK.backgroundColor = UIColor(hexString: "0099AE")
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
            return false
        }
}


extension NewStartStream: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image_data = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
    //let i = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
        self.authView.imageButton.setImage(image_data, for: .normal)
        guard let image = image_data else { return }
        let imageData:Data = image.pngData()!
        
        let imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
    }
}
