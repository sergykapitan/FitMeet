//
//  EditProfile.swift
//  FitMeet
//
//  Created by novotorica on 23.06.2021.
//

import Foundation
import UIKit
import Combine
import Loaf

class EditProfile: UIViewController, UIScrollViewDelegate {
    
    let profileView = EditProfileCode()
    var scrollViewBottomConstrain = NSLayoutConstraint()
    
    
    private var take: AnyCancellable?
    private var putUser: AnyCancellable?
    private var takeChannel: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    var imageUpload: UploadImage?
    var user: User?
    var imagePicker: ImagePicker!
    var gender: String = ""
    
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
        scrollViewBottomConstrain = profileView.scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
 
            profileView.scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scrollViewBottomConstrain,
            profileView.scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButtonContinue()
        makeNavItem()
        profileView.scroll.delegate = self
        profileView.textBirthday.addTarget(self, action: #selector(myTargetFunction), for: .allTouchEvents)
        self.hideKeyboardWhenTappedAround() 
        registerForKeyboardNotifications()
        profileView.textFieldName.delegate = self
        profileView.textFieldUserName.delegate = self
        profileView.textGender.delegate = self
        profileView.textBirthday.delegate = self
        profileView.textEmail.delegate = self
        profileView.textPhoneNumber.delegate = self

        profileView.textGender.isSearchEnable = false        
        profileView.textGender.optionArray = ["Male","Female","Undefined","Custom"]
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        changeData()
        bindingUser()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setUserProfile()
            self.navigationController?.navigationBar.isHidden = false
            profileView.alertLabel.isHidden = true
            profileView.alertImage.isHidden = true
        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

         if let swipeGesture = gesture as? UISwipeGestureRecognizer {

             switch swipeGesture.direction {
             case UISwipeGestureRecognizer.Direction.right:
                 self.navigationController?.popViewController(animated: true)
             case UISwipeGestureRecognizer.Direction.down:
                 print("Swiped down")
             case UISwipeGestureRecognizer.Direction.left:
                 print("Swiped left")
             case UISwipeGestureRecognizer.Direction.up:
                 print("Swiped up")
             default:
                 break
             }
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
            if profileView.textPhoneNumber.isFirstResponder {
                self.profileView.scroll.contentOffset.y = 150

        }
        if profileView.textEmail.isFirstResponder {
            self.profileView.scroll.contentOffset.y = 75
    }
    }
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        self.profileView.scroll.contentOffset.y = 0
    }

    func setUserProfile() {
        guard let userName = UserDefaults.standard.string(forKey: Constants.userFullName),let userFullName = UserDefaults.standard.string(forKey: Constants.userID) else { return }
        
    }
    func changeData() {
        profileView.textGender.didSelect { (str, ind, col) in
            switch str {
            case "Male" :  self.gender = "MALE"
            case "Female": self.gender = "FEMALE"
            case "Undefined": self.gender = "UNDEFINED"
            case "Custom": self.gender = "CUSTOM"
            default:
                break
            }
        }
   }
    func actionButtonContinue() {
        profileView.buttonSave.addTarget(self, action: #selector(actionSave), for: .touchUpInside)
        profileView.imageButton.addTarget(self, action: #selector(actionUploadImage), for: .touchUpInside)
    }
    
    @objc func actionUploadImage(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    @objc func actionSave() {        
        puteUser()
    }
    @objc func actionEditProfile() {
  
    }
    func bindingUser() {
        take = fitMeetApi.getUser()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                    self.user = response
                    self.profileView.textFieldName.text = self.user?.fullName
                    self.profileView.textFieldUserName.text = self.user?.username
                    
                    if self.user?.gender == "MALE" {
                        self.gender = "Male"
                    }else if  self.user?.gender == "FEMALE" {
                        self.gender = "Female"
                    }else if  self.user?.gender == "UNDEFINED" {
                        self.gender = "Undefined"
                    }else if  self.user?.gender == "CUSTOM" {
                        self.gender = "Custom"
                    }
                    self.profileView.textGender.text = self.gender
                    self.profileView.textBirthday.text = self.user?.birthDate?.getFormattedDate(format: "yyyy-MM-dd")
                    self.profileView.textEmail.text = self.user?.email
                    self.profileView.textPhoneNumber.text = self.user?.phone
                    self.profileView.setImageLogo(image: response.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
                }
        })
    }
    func puteUser() {
        Loaf("OK", state: Loaf.State.success, location: .top, sender:  self).show(.short)
        
        
        let usr = UserRequest( fullName: self.profileView.textFieldName.text,
                               username: self.profileView.textFieldUserName.text,
                               birthDate: self.profileView.textBirthday.text,
                               gender: self.gender,
                               avatarPath: self.imageUpload?.data?.first?.filename)
        self.profileView.buttonSave.backgroundColor = .blueColor.alpha(0.4)
        self.profileView.buttonSave.isUserInteractionEnabled = false
        putUser = fitMeetApi.putUser(user: usr)
            .mapError({ (error) -> Error in
                print(error.localizedDescription)
                return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                    DispatchQueue.main.async {
                        Loaf("Saved in \(response.username!)", state: Loaf.State.success, location: .bottom, sender:  self).show(.short) { disType in
                            self.profileView.buttonSave.backgroundColor = .blueColor
                            self.profileView.buttonSave.isUserInteractionEnabled = true
                            switch disType {
                                     case .tapped:  self.navigationController?.popViewController(animated: true)
                                     case .timedOut: self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                } else {
                   
                    Loaf("Not Saved \(response.message!)", state: Loaf.State.error, location: .bottom, sender:  self).show(.short){ disType in
                        switch disType {
                                 case .tapped:
                            self.profileView.buttonSave.backgroundColor = .blueColor
                            self.profileView.buttonSave.isUserInteractionEnabled = true
                                 case .timedOut:
                            self.profileView.buttonSave.backgroundColor = .blueColor
                            self.profileView.buttonSave.isUserInteractionEnabled = true
                    }
                    }
            }
        })
    }
    func makeNavItem() {
        
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
                    let titleLabel = UILabel()
                   titleLabel.text = " Edit Profile"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
                    let backButton = UIButton()
                  //  backButton.anchor( width: 40, height: 30)
                    backButton.setBackgroundImage(#imageLiteral(resourceName: "backButton"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)
        
                    let stackView = UIStackView(arrangedSubviews: [backButton,titleLabel])
                    stackView.distribution = .equalSpacing
                    stackView.alignment = .center
                    stackView.axis = .horizontal
                    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rightBack))
                    stackView.addGestureRecognizer(tap)

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "notifications1"), style: .plain, target: self, action:  #selector(notificationHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(timeHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
       // self.navigationItem.rightBarButtonItems = [startItem,timeTable]
    }
 
    @objc func myTargetFunction(textField: UITextField) {
        showPicker()
    }
    private func showPicker() {
        var style = DefaultStyle()
        style.pickerColor = StyleColor.colors([style.textColor, .red, .blueColor])
        style.pickerMode = .date
        style.titleString = "Please Сhoose Birhday Date"
        style.returnDateFormat = .d_m_yyyy
        style.minimumDate = "1970-01-01".getFormattedDateR(format: "yyyy-MM-dd")
        style.maximumDate = Date()
        style.titleFont = UIFont.systemFont(ofSize: 25, weight: .bold)
    
        style.textColor = UIColor(hexString: "#3B58A4")
        let pick:PresentedViewController = PresentedViewController()
        pick.style = style
        pick.block = { [weak self] (date) in
            self?.profileView.textBirthday.text = date
        }
        self.present(pick, animated: true, completion: nil)
    }
    @objc func timeHandAction() {
        let tvc = Timetable()
        navigationController?.present(tvc, animated: true, completion: nil)
        
        
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
    @objc func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension EditProfile: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.profileView.textBirthday {
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

 

        return true
    }
    
    func EditProfile(_ textField: UITextField) -> Bool {
        
        if textField == profileView.textFieldName {
            self.profileView.textFieldName.resignFirstResponder()
            return true
        }
        if textField == profileView.textFieldUserName {
            self.profileView.textFieldUserName.resignFirstResponder()
            return true
        }
        if textField == profileView.textGender {
            self.profileView.textGender.resignFirstResponder()
            return true
        }
        if textField == profileView.textBirthday {
            self.profileView.textBirthday.resignFirstResponder()
            return true
        }
        if textField == profileView.textEmail {
            self.profileView.textEmail.resignFirstResponder()
            return true
        }
        if textField == profileView.textPhoneNumber {
            self.profileView.textPhoneNumber.resignFirstResponder()
            return true
        }
   
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    func bindingImage(image: UIImage) {
        takeChannel = fitMeetApi.uploadImage(image: image)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil  {
                    self.imageUpload = response
                    
                  
                }
        })
    }
}
extension EditProfile: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        
    self.profileView.imageButton.setImage(image, for: .normal)
        guard let imagee = image else { return }
        bindingImage(image: imagee)
        let imageData:Data = imagee.pngData()!
        let imageStr = imageData.base64EncodedString()
      

    }
}
