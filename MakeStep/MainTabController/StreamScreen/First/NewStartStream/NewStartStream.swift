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

class NewStartStream: UIViewController, DropDownTextFieldDelegate, UIScrollViewDelegate {
    
    func menuDidAnimate(up: Bool) {
        print("menuDidAnimate")
    }
    
    func optionSelected(option: String) {
        print("optionSelected===========\(option)")
    }
    
    
    let authView = NewStartStreamCode()
    

    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetStream: FitMeetStream
    @Inject var fitMeetChanell: FitMeetChannels
    var imagePicker: ImagePicker!
    
    var image: String?
    var name: String = "JOPE"

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
        authView.imageButton.setImage(#imageLiteral(resourceName: "Rectangle 966gggg"), for: .normal)
    
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
       
        authView.textFieldStartDate.isSearchEnable = true
        authView.textFieldAviable.isSearchEnable = false
        authView.textFieldFree.isSearchEnable = false
        
        authView.textFieldCategory.optionArray = ["Yoga", "Dance","Meditation","Muscular endurance","Flexibility","Stretching","Power","Workshop","tennis","Category 661","Category 671"]
        authView.textFieldStartDate.optionArray = ["NOW", "Later"]
        authView.textFieldAviable.optionArray = ["All","Subscribers", "Only Sponsors"]
        authView.textFieldFree.optionArray = ["Free", "0,99","1,99","2,99","3,99","4,99","5,99","6,99", "7,99","8,99","9,99","10,99","11,99","12,99", "13,99","14,99","15,99","16,99","17,99", "18,99", "19,99", "20,99", "21,99", "22,99", "23,99", "24,99", "25,99", "26,99",  "27,99", "28,99","29,99","30,99", "31,99","32,99", "33,99", "34,99","35,99","36,99","37,99", "38,99", "39,99", "40,99", "41,99", "42,99","43,99","44,99","45,99","46,99","47,99", "48,99","49,99"]
        
        changeData()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
       // authView.textFieldStartDate.cance

        actionButtonContinue()

        authView.buttonContinue.isUserInteractionEnabled = false
 
  
    }
    @objc func scrollViewTapped() {
            authView.scroll.endEditing(true)
            self.view.endEditing(true) // anyone
        }

    func changeData() {
        authView.textFieldStartDate.didSelect { (gg, tt, hh) in
            print("ggggggg ==== \(gg)\n tttttt======\(tt)\n hhhhhhh===\(hh)")
            if gg == "NOW" {
                self.authView.buttonOK.setTitle("OK", for: .normal)
                self.authView.buttonOK.isUserInteractionEnabled = true
                
            } else {
                self.authView.buttonOK.setTitle("Planned", for: .normal)
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
                        self.authView.buttonOK.setTitle("Planned", for: .normal)
                        self.authView.buttonOK.isUserInteractionEnabled = true
                       }
                   }
}
    private func showPicker() {
        var style = DefaultStyle()
        style.pickerColor = StyleColor.colors([style.textColor, .red, .blue])
        style.pickerMode = .dateAndTime
        style.titleString = "This is Date Picker"
        style.returnDateFormat = .yyyy_To_ss
        style.minimumDate = Date()
        style.maximumDate = Date().addingTimeInterval(3600*24*7*52)
        style.titleFont = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        let pick:PresentedViewController = PresentedViewController()
        pick.style = style
        pick.block = { [weak self] (date) in
            self?.authView.textFieldStartDate.text = date
        }
        self.present(pick, animated: true, completion: nil)
    }

    func actionButtonContinue() {
      //  authView.buttonContinue.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        authView.buttonOK.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        authView.imageButton.addTarget(self, action: #selector(actionUploadImage), for: .touchUpInside)
    }
    @objc func actionSignUp() {
      print("create broadcast")
        guard let chanelId = listChanell.last?.id ,let name = authView.textFieldName.text ,let description = authView.textFieldDescription.text,let img = image else { return }
        UserDefaults.standard.set(self.listChanell.last?.id, forKey: Constants.chanellID)
        
        self.nextView(chanellId: chanelId, name: name, description: description, previewPath: img)
        print("Date = \(date)")
    }
    @objc func actionUploadImage(_ sender: UIButton) {
        print("Upload Image")
        
        self.imagePicker.present(from: sender)
        
        
//        let myPickerController = UIImagePickerController()
//        myPickerController.delegate = self;
//        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
//        self.present(myPickerController, animated: true, completion: nil)
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
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Note"), style: .plain, target: self, action:  #selector(notificationHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(timeHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
        self.navigationItem.rightBarButtonItems = [startItem,timeTable]
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
                    print(self.listChanell.last)
                }
        })
    }
    func bindingImage(image: UIImage) {
        takeChannel = fitMeetApi.uploadImage(image: image)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil  {
                    self.imageUpload = response
                    print("GGGGYGGGLUFLUTCFLTFLYT+++++++++\(response.data?.first?.url)")
                }
        })
    }
    func nextView(chanellId: Int ,name: String , description: String,previewPath: String)  {
        
        
        print("PREVIEWPATH ===============\(previewPath)")
       // uploadImage()
  
    
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
                                                    scheduledStartDate: "\(date)",
                                                    description: description,
                                                    previewPath: "/path/to/file.jpg"))
            //
       // "2021-06-18T10:50:26.017Z"
            //"/path/to/file.jpg"
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
    
    func ffff(img_photo_image: UIImage) {
        
        //Set Your URL
          let api_url = Constants.apiEndpoint + "/uploader/user/azure"
          guard let url = URL(string: api_url) else {
              return
          }

          var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
          urlRequest.httpMethod = "POST"
          urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

          //Set Your Parameter
          let parameterDict = NSMutableDictionary()
          parameterDict.setValue(self.name, forKey: "name")

          //Set Image Data
        let imgData = img_photo_image.jpegData(compressionQuality: 1)!

         // Now Execute
          AF.upload(multipartFormData: { multiPart in
//              for (key, value) in parameterDict {
//                  if let temp = value as? String {
//                      multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
//                  }
//                  if let temp = value as? Int {
//                      multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
//                  }
//                  if let temp = value as? NSArray {
//                      temp.forEach({ element in
//                          let keyObj = key as! String + "[]"
//                          if let string = element as? String {
//                              multiPart.append(string.data(using: .utf8)!, withName: keyObj)
//                          } else
//                              if let num = element as? Int {
//                                  let value = "\(num)"
//                                  multiPart.append(value.data(using: .utf8)!, withName: keyObj)
//                          }
//                      })
//                  }
//              }
            //
          //  , fileName: "file.png", mimeType: "image/png"
            multiPart.append(imgData, withName: "file", fileName: "file.png", mimeType: "image/png")
          }, with: urlRequest,interceptor: Interceptor(interceptors: [AuthInterceptor()]))
              .uploadProgress(queue: .main, closure: { progress in
                  //Current upload progress of file
                  print("Upload Progress: \(progress.fractionCompleted)")
              })
              .responseJSON(completionHandler: { data in

                         switch data.result {

                         case .success(_):
                          do {
                          
                          let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                            
                              print("Success!")
                              print(dictionary)
                         }
                         catch {
                            // catch error.
                          print("catch error")

                                }
                          break
                              
                         case .failure(_):
                          print("failure")

                          break
                          
                      }


              })
    }
    
    
   
}
extension NewStartStream: UITextFieldDelegate {
    
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
        
        if textField == authView.textFieldStartDate {
            print("hhhhhhhh============\(fullString)")
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

//
//extension NewStartStream: UIImagePickerControllerDelegate,UINavigationControllerDelegate
//{
//   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
//    {
//        let image_data = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
//    //let i = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
//        self.authView.imageButton.setImage(image_data, for: .normal)
//        guard let image = image_data else { return }
//        let imageData:Data = image.pngData()!
//        
//        let imageStr = imageData.base64EncodedString()
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    
//}
extension NewStartStream: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.authView.imageButton.setImage(image, for: .normal)
        
        guard let imagee = image else { return }
        self.ffff(img_photo_image: imagee)
       // uploadImage(image: imagee)
       // bindingImage(image: imagee)
        let imageData:Data = imagee.pngData()!
       
        let imageStr = imageData.base64EncodedString()
        self.image = imageStr
        
//        serviceProvider.loadView(service: .showCharacter(limit: 30), decodeType: Responce.self) { (result) in
//            switch result {
//            case .success(let responce):
//                print(result)
//            case .failure(let error):
//                print(error)
//            }
//        }
       // self.imageView.image = image
    }
}