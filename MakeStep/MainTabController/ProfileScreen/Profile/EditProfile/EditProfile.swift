//
//  EditProfile.swift
//  FitMeet
//
//  Created by novotorica on 23.06.2021.
//

import Foundation
import UIKit
import Combine

class EditProfile: UIViewController, UIScrollViewDelegate {
    
    let profileView = EditProfileCode()
    private var take: AnyCancellable?
    private var putUser: AnyCancellable?
    @Inject var fitMeetApi: FitMeetApi
    var user: User?
    
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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButtonContinue()
        makeNavItem()
        profileView.scroll.delegate = self
        
        profileView.textFieldName.delegate = self
        profileView.textFieldUserName.delegate = self
        profileView.textGender.delegate = self
        profileView.textBirthday.delegate = self
        profileView.textEmail.delegate = self
        profileView.textPhoneNumber.delegate = self
        
        profileView.textGender.isSearchEnable = false        
        profileView.textGender.optionArray = ["MALE", "FEMALE"]
        
        bindingUser()
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserProfile()
        self.navigationController?.navigationBar.isHidden = false
        profileView.alertLabel.isHidden = true
        profileView.alertImage.isHidden = true
        profileView.cardView.anchor( left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 0, paddingRight: 0)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    
    }
   
   
    func setUserProfile() {
        guard let userName = UserDefaults.standard.string(forKey: Constants.userFullName),let userFullName = UserDefaults.standard.string(forKey: Constants.userID) else { return }
        print("token ====== \(UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults))")
        
    }
    func actionButtonContinue() {
        profileView.buttonSave.addTarget(self, action: #selector(actionSave), for: .touchUpInside)
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
                    self.profileView.textGender.text = self.user?.gender
                    self.profileView.textBirthday.text = self.user?.birthDate
                    self.profileView.textEmail.text = self.user?.email
                    self.profileView.textPhoneNumber.text = self.user?.phone
                    print(self.user)
                }
        })
    }
    func puteUser() {

        let usr = UserRequest( fullName: self.profileView.textFieldName.text, username: self.profileView.textFieldUserName.text, birthDate: "1985-12-20", gender: self.profileView.textGender.text, avatarPath: self.profileView.textPhoneNumber.text)
        
        putUser = fitMeetApi.putUser(user: usr)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                    print(self.user)
                    self.navigationController?.popViewController(animated: true)
                }
        })
    }
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
                    let titleLabel = UILabel()
                   titleLabel.text = "   Profile"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
                   let backButton = UIButton()
                   backButton.setImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)

                   let stackView = UIStackView(arrangedSubviews: [backButton,titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .horizontal

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Note"), style: .plain, target: self, action:  #selector(rightHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(rightHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
        self.navigationItem.rightBarButtonItems = [startItem,timeTable]
    }
    @objc
    func rightHandAction() {
        print("right bar button action")
    }
    @objc
    func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }
  

}

extension EditProfile: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        
        let string = "formate"
        textField.text = string.format(phoneNumber: fullString, shouldRemoveLastDigt: range.length == 1)
        if textField == profileView.textFieldName {
        if fullString == "" {
            profileView.buttonSave.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            profileView.buttonSave.isUserInteractionEnabled = false
        } else {
            profileView.buttonSave.backgroundColor = UIColor(hexString: "0099AE")
            profileView.buttonSave.isUserInteractionEnabled = true
          }
        }
        return false
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
}
