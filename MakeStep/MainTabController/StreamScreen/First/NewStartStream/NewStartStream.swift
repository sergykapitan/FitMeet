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
import Kingfisher

protocol SendDataToLive: AnyObject {
    func sendDatatoLive(category:[Int],description: String?,imagePath:String?)
}

class NewStartStream: UIViewController, DropDownTextFieldDelegate, UIScrollViewDelegate, TagListViewDelegate,CustomPresentable, UITextViewDelegate {
    
    var transitionManager: UIViewControllerTransitioningDelegate?
    
    weak var delegate: SendDataToLive?
    var category: [Datum] = []
    
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
    private var takeBroadcastMap: AnyCancellable?
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
    var imagePath: String?
    
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
                self.authView.textFieldDescription.easy.reload()
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
        bindingCategory()
        if let imagePath = imagePath {
            if let imgURL = URL(string: "https://dev.makestep.com" + imagePath) {
                self.authView.imageButton.kf.setImage(with: imgURL, for: .normal,placeholder: UIImage(named: "Rectangle"),options: [.transition(.fade(0))], progressBlock: nil)
             }
        }else {
                self.authView.imageButton.setBackgroundImage(#imageLiteral(resourceName: "Rectangle"), for: .normal)
        }
        guard !IdCategory.isEmpty else { return }
        bindingMapCategory(categoryId: IdCategory)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        var returnImageString: String = ""
        if self.imageUpload?.data?.first?.filename == nil {
            returnImageString = imagePath ?? ""
        } else {
            returnImageString = self.imageUpload?.data?.first?.filename ?? ""
        }
        delegate?.sendDatatoLive(category: self.IdCategory, description: self.authView.textFieldDescription.text, imagePath: returnImageString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bindingUser()
       

        
        setupKeyboardNotifications()
        self.hideKeyboardWhenTappedAround()
       
        setupTapGesture()

        authView.textFieldDescription.delegate = self
        authView.textFieldCategory.delegate = self
        authView.tagView.delegate = self
  
    
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        actionButtonContinue()
        
       
        
        authView.textFieldCategory.didSelect { (ff, _, _) in

            let j =  self.authView.tagView.tagViews.filter {$0.titleLabel?.text == ff}
            if j.isEmpty {
                self.authView.tagView.addTag(ff)
                let p = self.listCategory.filter{$0.title == ff}.compactMap{$0.id}
                self.IdCategory.append(contentsOf: p)
                print("Category == \(self.IdCategory)")
                self.authView.tagView.layoutSubviews()
                self.authView.spinner.alpha = 1
                self.authView.labelSaved.alpha = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.authView.spinner.alpha = 0
                    self.authView.labelSaved.alpha = 1
                }
                self.updatePresentationLayout(animated: true)
            } else {
                Loaf("Not Saved \(ff)", state: Loaf.State.error, location: .bottom, sender:  self).show(.short)
            }
        self.authView.textFieldCategory.placeholder = ""                    
    }
            authView.textFieldCategory.easy.layout(Height(>=46))
            authView.textFieldDescription.easy.layout(Height(>=46))
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
               self.updatePresentationLayout(animated: true)
               print(IdCategory)
            }
       }
    func actionButtonContinue() {
        authView.imageButton.addTarget(self, action: #selector(actionUploadImage), for: .touchUpInside)
    }

    @objc func actionUploadImage(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
  
    func bindingCategory() {
        takeBroadcast = fitMeetStream.getCategoryPrivate()
            .mapError({ (error) -> Error in
                print(error.localizedDescription)
                return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listCategory = response.data!
                    let list = self.listCategory.compactMap{$0.title}
                    self.authView.textFieldCategory.optionArray = list
                }
        })
    }
    func bindingMapCategory(categoryId: [Int]) {
        takeBroadcastMap = fitMeetStream.getCategoryIdS(ids: categoryId)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                self.category = response.data.compactMap{$0.value}
                self.authView.tagView.addTags(self.category.compactMap{$0.title})
                self.authView.tagView.layoutSubviews()
                
               
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
                       // self.authView.textFieldAviable.optionArray = ["Available for all","Subscribers only","Private Stream"]
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
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.authView.spinner.alpha = 0
                        self.authView.labelSaved.alpha = 1
                    }
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
        if !authView.textFieldCategory.isSelected {
        authView.textFieldCategory.showList()
        }
    }
    deinit {
           print("deiniting")
       }
}
extension NewStartStream: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
        
        if textField == authView.textFieldCategory {
            self.authView.textFieldCategory.resignFirstResponder()
           
            return true
        }
     return false
  }
}
extension NewStartStream: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.authView.imageButton.setImage(image, for: .normal)
        
        self.authView.spinner.alpha = 1
        self.authView.labelSaved.alpha = 0
        guard let imagee = image else { return }
        bindingImage(image: imagee)
        let imageData:Data = imagee.pngData()!       
        let imageStr = imageData.base64EncodedString()
        self.image = imageStr
       
    }
}
extension NewStartStream {
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if authView.textFieldDescription.isFirstResponder {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                if self.view.frame.origin.y >= 400 {
                self.view.frame.origin.y -= keyboardHeight
                }
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardHeight = keyboardFrame.cgRectValue.height
                self.view.frame.origin.y += keyboardHeight
            self.authView.spinner.alpha = 1
            self.authView.labelSaved.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.authView.spinner.alpha = 0
                self.authView.labelSaved.alpha = 1
            }
        }
    }
}
