//
//  NewPassword.swift
//  MakeStep
//
//  Created by novotorica on 09.09.2021.
//

import Foundation
import UIKit
import Combine
import Alamofire

protocol CodeErrorDelegate: class {
    func codeError()
}


class NewPassword: UIViewController {
    
    @Inject var fitMeetApi: FitMeetApi
    private var takePassword: AnyCancellable?
    private var takeUser: AnyCancellable?
    
    var bottomConstraint = NSLayoutConstraint()
    
    let signUpView = NewPasswordCode()
    weak var delegate: SignUpDelegate?
    
    typealias CompletionHandler = ( _ success:Bool) -> Void
    weak var delegateCode: CodeErrorDelegate?
    
    var userPhoneOreEmail: String?
    var verCode: String?
    var getHash: String?
    
    private let minLeght = 8
    private var regex = "^[\\d!#$%&*@^-]*$"
    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func loadView() {
        super.loadView()
        view = signUpView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.textFieldName.delegate = self
        signUpView.textFieldUserName.delegate = self
        buttonSignUp()
        self.hideKeyboardWhenTappedAround()
        bottomConstraint = signUpView.buttonContinue.topAnchor.constraint(equalTo: signUpView.textFieldUserName.bottomAnchor, constant: 15)
        bottomConstraint.isActive = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        signUpView.alertLabel.isHidden = true
        signUpView.alertImage.isHidden = true
    }
    func buttonSignUp() {
        signUpView.buttonContinue.addTarget(self, action: #selector(buttonSignUpAction), for: .touchUpInside)
    }
    @objc func buttonSignUpAction() {
        fetchUser()
    }
    private func openProfileViewController() {
        let viewController = MainTabBarViewController()
        viewController.selectedIndex = 4
        let mySceneDelegate = (self.view.window?.windowScene)!
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.openRootViewController(viewController: viewController, windowScene: mySceneDelegate)
    }

    private func fetchUser(){
        if signUpView.textFieldName.text == "" || signUpView.textFieldUserName.text == ""   {
            self.animateView()
            return
        }

        guard  let password1 = signUpView.textFieldName.text,
               let password2 = signUpView.textFieldUserName.text,
               let code = verCode,
               let phone = userPhoneOreEmail,
               let hash = getHash else { return }
        
        if password1 == password2 {
            takePassword = fitMeetApi.resetPasswordSms(reset: ResetPasswordSms(password:  password1, hash: hash))
                        .mapError({ (error) -> Error in
                            print("error = \(error)")
                            if error.localizedDescription == "The operation couldn’t be completed. (MakeStep.FitMeetApi.DifferentError error 0.)" {
                                self.delegateCode?.codeError()
                                self.dismiss(animated: true, completion: nil)
                            }
                                    return error })
                        .sink(receiveCompletion: { _ in }, receiveValue: { response in
                            if response {
                                self.fetchToken(phone: phone, password: password1)
                            }
                        })
        } else {self.animateView()  }
   }
    private func openMainViewController() {
          let mainVC = MainTabBarViewController()
          mainVC.modalPresentationStyle = .fullScreen
          self.present(mainVC, animated: true, completion: nil)
    }
    private func fetchToken(phone:String,password: String) {
        takeUser = fitMeetApi.loginPassword(login: LoginPassword(phone: phone, password: password))
        .mapError({ (error) -> Error in
           return error })
        .sink(receiveCompletion: { _ in }, receiveValue: { response in
            if let token = response.token?.token {
            UserDefaults.standard.set(token, forKey: Constants.accessTokenKeyUserDefaults)
            UserDefaults.standard.set(response.user?.id, forKey: Constants.userID)
            UserDefaults.standard.set(response.user?.fullName, forKey: Constants.userFullName)
                self.openProfileViewController()
           
  
           }
        })
     }
}
extension NewPassword: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
 
        self.signUpView.textFieldName.resignFirstResponder()
        self.signUpView.textFieldUserName.resignFirstResponder()
        
        return true
    }
}
extension NewPassword {
    func animateView() {
    let trA = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1) {
        self.bottomConstraint.constant = 45
        self.signUpView.alertImage.isHidden = false
        self.signUpView.alertLabel.isHidden = false
    }
    self.view.layoutIfNeeded()
    trA.startAnimation()
    }
}
