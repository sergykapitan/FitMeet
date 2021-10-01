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

class EditStreamVC: UIViewController, DropDownTextFieldDelegate, UIScrollViewDelegate {
    
    func menuDidAnimate(up: Bool) {
        print("menuDidAnimate")
    }
    
    func optionSelected(option: String) {
        print("optionSelected===========\(option)")
    }
    
    
    let authView = EditStreamCode()
    

    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetStream: FitMeetStream
    @Inject var fitMeetChanell: FitMeetChannels
    
    var imagePicker: ImagePicker!
    
    var image: String?
    
    var name: String = "JOPE"
    var user: Users?

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
    var broadcastID: Int?
    
    let serviceProvider = Serviceprovider<CharacterProvider>()
   // let request: URLRequest?
    
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

    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authView.cardView.anchor( left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 0, paddingRight: 0)
        guard let image = self.broadcast?.previewPath else { return }
        self.authView.textFieldName.text = self.broadcast?.name
       // self.authView.textFieldFree.text = self.broadcast.
        self.authView.textFieldAviable.text = self.broadcast?.access
        self.authView.textFieldDescription.text = self.broadcast?.description
        let categorys = broadcast?.categories
        broadcastID = broadcast?.id
        let s = categorys!.map{$0.title!}
        let stringRepresentation = s.joined(separator:",")
        self.authView.textFieldCategory.text = stringRepresentation
        let url = URL(string: image)
        self.authView.imageButton.kf.setImage(with:url , for: .normal)      
        self.authView.buttonOK.setTitle("Save", for: .normal)
        self.authView.textFieldStartDate.text = self.broadcast?.scheduledStartDate
        authView.buttonOK.backgroundColor = UIColor(hexString: "#3B58A4")
        self.image = broadcast?.previewPath
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavItem()

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
       
        authView.textFieldStartDate.isSearchEnable = true
        authView.textFieldAviable.isSearchEnable = false
        authView.textFieldFree.isSearchEnable = false
        
        authView.textFieldCategory.optionArray = ["Yoga", "Dance","Meditation","Muscular endurance","Flexibility","Stretching","Power","Workshop","tennis","Category 661","Category 671"]
        authView.textFieldStartDate.optionArray = ["NOW", "Later"]
        authView.textFieldAviable.optionArray = ["All","Subscribers", "Only Sponsors"]
        authView.textFieldFree.optionArray = ["Free", "0,99","1,99","2,99","3,99","4,99","5,99","6,99", "7,99","8,99","9,99","10,99","11,99","12,99", "13,99","14,99","15,99","16,99","17,99", "18,99", "19,99", "20,99", "21,99", "22,99", "23,99", "24,99", "25,99", "26,99",  "27,99", "28,99","29,99","30,99", "31,99","32,99", "33,99", "34,99","35,99","36,99","37,99", "38,99", "39,99", "40,99", "41,99", "42,99","43,99","44,99","45,99","46,99","47,99", "48,99","49,99"]
        
        changeData()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        actionButtonContinue()
        authView.buttonContinue.isUserInteractionEnabled = false
 
  
    }
    @objc func scrollViewTapped() {
            authView.scroll.endEditing(true)
            self.view.endEditing(true) // anyone
        }

    func changeData() {
        authView.textFieldStartDate.didSelect { (gg, tt, hh) in
            if gg == "NOW" {
                self.authView.buttonOK.setTitle("Save", for: .normal)
                self.authView.buttonOK.isUserInteractionEnabled = true
                
            } else {
                self.authView.buttonOK.setTitle("Save", for: .normal)
                self.authView.buttonOK.isUserInteractionEnabled = true
            }
        }
        authView.textFieldAviable.didSelect { (str, ind, col) in
            if str == "All" || str == "Subscribers"{
                self.authView.textFieldFree.isUserInteractionEnabled = false
                
        } else if str == "Only Sponsors" {
            self.authView.textFieldFree.isUserInteractionEnabled = true
       }
   
    }
        authView.textFieldStartDate.didSelect { (ff, _, _) in
                       if ff == "Later" {
                        self.showPicker()
                        self.authView.buttonOK.setTitle("Save", for: .normal)
                        self.authView.buttonOK.isUserInteractionEnabled = true
                       }
                   }
}
    private func showPicker() {
        var style = DefaultStyle()
        style.pickerColor = StyleColor.colors([style.textColor, .red, .blue])
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
        print("GUARD = \(authView.textFieldName.text)\n \(authView.textFieldDescription.text) \n \(authView.textFieldStartDate.text)")
        guard
              let name = authView.textFieldName.text ,
              let description = authView.textFieldDescription.text,
              let img = image ,
              let planedDate = authView.textFieldStartDate.text else { return }
        
      //  UserDefaults.standard.set(self.listChanell.last?.id, forKey: Constants.chanellID)
        var isPlan: Bool?
        var date: String?
        
        var onlyForSponsors : Bool?
        var onlyForSubscribers: Bool?
        
        if authView.textFieldStartDate.text == "NOW" {
            isPlan = false
            date = "\(Date())"
        } else {
            
            isPlan = true
            date = authView.textFieldStartDate.text
        }
        //"All","Subscribers", "Only Sponsors"
        if authView.textFieldAviable.text == "All" || authView.textFieldAviable.text == "ALL" {
             onlyForSponsors = false
             onlyForSubscribers = false
        } else if authView.textFieldAviable.text == "Subscribers" {
            onlyForSponsors = false
            onlyForSubscribers = true
        } else if authView.textFieldAviable.text == "Only Sponsors" {
            onlyForSponsors = true
            onlyForSubscribers = false
        }
        
        print("Guasrd2 === \(isPlan)\n \(date) \n \(onlyForSubscribers) \n \(onlyForSponsors)")
        guard let isP = isPlan,
              let d = date,
              let sponsor = onlyForSponsors,
              let sub = onlyForSubscribers else { return }

        self.nextView( name: name, description: description, previewPath: img, isPlaned: isP, date: d, onlyForSponsors: sponsor, onlyForSubscribers: sub, categoryId: [25,30])
     
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
    
    
    
    
    
    func bindingChanell() {
        takeChannel = fitMeetChanell.listChannels()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listChanell = response.data
                    print("ListChanel = ==== \(self.listChanell.last)")
                }
        })
    }
    func bindingImage(image: UIImage) {
        takeChannel = fitMeetApi.uploadImage(image: image)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                print("RESPONSE======\(response)")
                if response != nil  {
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
    func nextView(
                  name: String ,
                  description: String,
                  previewPath: String,
                  isPlaned: Bool,
                  date: String,onlyForSponsors: Bool,onlyForSubscribers:Bool,categoryId: [Int])  {
        guard let id = broadcastID else { return }
        
        print("\(id)\n \(name)\n \(description)")
        takeChannel = fitMeetStream.editBroadcastId(id: id,
                                                    broadcast: EditBroadcast(
                                                        name: name,
                                                        type: "STANDARD",
                                                        access: "ALL",
                                                        hasChat: true,
                                                        scheduledStartDate: date,
                                                        onlyForSponsors: onlyForSponsors,
                                                        onlyForSubscribers: onlyForSubscribers,
                                                        addCategoryIDS: categoryId,
                                                        removeCategoryIDS: [0],
                                                        previewPath: self.imageUpload?.data?.first?.filename,
                                                        rate: 0,
                                                        description: description, price: nil))


            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let id = response.id {
                    print("Responce === \(response)")
                    print("greate broadcast")
                    self.dismiss(animated: true, completion: nil)

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
                    print("chat === \(self.authView.textFieldStartDate.text)")
                    
                    if self.authView.textFieldStartDate.text == "NOW" {
                        let navVC = LiveStreamViewController()
                        navVC.modalPresentationStyle = .fullScreen
                        navVC.idBroad = id
                        guard let myuris = self.myuri,let myPublishh = self.myPublish else { return }
                        navVC.myuri = myuris
                        navVC.myPublish = myPublishh
                       // self.present(navVC, animated: true, completion: nil)
                        self.present(navVC, animated: true) {
                            self.authView.textFieldStartDate.text = ""
                        }
                    } else {
                        let channelVC = ChanellVC()
                        channelVC.user = self.user
                        self.navigationController?.pushViewController(channelVC, animated: true)
                    
                    }
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
            authView.buttonOK.backgroundColor = UIColor(red: 0.231, green: 0.345, blue: 0.643, alpha: 0.5)
            authView.buttonOK.isUserInteractionEnabled = true
            authView.buttonOK.backgroundColor = UIColor(hexString: "#3B58A4")
        } else {
           // authView.buttonOK.backgroundColor = UIColor(hexString: "2kWkNSZaD5T")
            authView.buttonOK.backgroundColor = UIColor(hexString: "#3B58A4")
            authView.buttonOK.isUserInteractionEnabled = true
          }
        }
        
        if textField == authView.textFieldStartDate {
            if fullString == "NOW" {
               // authView.buttonOK.backgroundColor = UIColor(hexString: "2kWkNSZaD5T")
                authView.buttonOK.setTitle("OK", for: .normal)
                authView.buttonOK.isUserInteractionEnabled = true
            } else {
              //  authView.buttonOK.backgroundColor = UIColor(hexString: "2kWkNSZaD5T")
                authView.buttonOK.setTitle("Planned", for: .normal)
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
