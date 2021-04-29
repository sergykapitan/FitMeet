//
//  SignUpViewController.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import Foundation
import UIKit
import Combine
import Alamofire

class SignUpViewController: UIViewController {
    
    @Inject var fitMeetApi: FitMeetApi
    
    let signUpView = SignUpViewControllerCode()
    private var userSubscriber: AnyCancellable?
    
    var userPhoneOreEmail: String?
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
        signUpView.textFieldPassword.delegate = self
        signUpView.textFieldPassword.textContentType = .password
        buttonSignUp()
  
    }
    func buttonSignUp() {
        signUpView.buttonContinue.addTarget(self, action: #selector(buttonSignUpAction), for: .touchUpInside)
    }
    @objc func buttonSignUpAction() {
        fetchUser()
    }
    private func openProfileViewController() {
        print("123")
       // let sceneDelegate = self.view.window
      //  let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = MainTabBarViewController()
        viewController.selectedIndex = 4
       // self.dismiss(animated: true, completion: nil)
       // sceneDelegate.window!.rootViewController = viewController
        let mySceneDelegate = (self.view.window?.windowScene)!
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.openRootViewController(viewController: viewController, windowScene: mySceneDelegate)
       // sceneDelegate.window!.rootViewController = viewController
       // sceneDelegate.window!.makeKeyAndVisible()
    }
    private func fetchUser(){
        guard let phone = userPhoneOreEmail , let name = signUpView.textFieldName.text, let usr = signUpView.textFieldUserName.text, let password = signUpView.textFieldPassword.text else { return }
        userSubscriber = fitMeetApi.signupPassword(authRequest: AuthorizationRequest(
                                                    fullName: "string",//name,
                                                    username: "test",//usr,
                                                    email: "mail@mail3456.ru",
                                                    phone: "+79123456009",//phone,
                                                    password: "Password1!"//password
        ))
            .mapError({ (error) -> Error in
                        print("ERROR +++++++ \(error.self)")
                        return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
            if var token = response.token?.token {
                UserDefaults.standard.set(token, forKey: Constants.accessTokenKeyUserDefaults)
                self.openProfileViewController()
            } else if response.message == "error.user.phoneExist"{
                print("такой email уже существует")
            } else if response.message == "error.user.emailExist" {
                print("такой телефон уже существует")
            }else if response.message == "error.user.usernameExist"{
                print("такое имя пользователя уже существует")
            }
                
                
                
                
        })
            
    }
    private func checkValidation(password: String) {
        guard password.count >= minLeght else { return }
        if password.matches(regex) {
            print("Validate")
        } else {
            print("NotValidate")
        }
    }
    private func openMainViewController() {
          let mainVC = MainTabBarViewController()
          mainVC.modalPresentationStyle = .fullScreen
          self.present(mainVC, animated: true, completion: nil)
    }
}
extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
    if textField == signUpView.textFieldPassword {
        let fullString = (textField.text ?? "") + string
        let res: String
        
        if range.length == 1{
            let end  = fullString.index(fullString.startIndex, offsetBy: fullString.count - 1)
            res = String(fullString[fullString.startIndex..<end])
        } else {
            res = fullString
        }
        checkValidation(password: res)
        textField.text = res
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.signUpView.textFieldPassword.resignFirstResponder()
        self.signUpView.textFieldName.resignFirstResponder()
        self.signUpView.textFieldUserName.resignFirstResponder()
        
        return true
    }
  
}
