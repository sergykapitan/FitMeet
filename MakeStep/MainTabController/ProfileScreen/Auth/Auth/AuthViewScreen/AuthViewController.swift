//
//  ViewController.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit
import AuthenticationServices
import Combine

class AuthViewController: UIViewController{
    
  
    
    let authView = AuthViewControllerCode()
    private let signInButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
    private var takeAppleSign: AnyCancellable?
    @Inject var fitMeetApi: FitMeetApi
    var topPhoneConstraint = NSLayoutConstraint()
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.textFieldLogin.delegate = self
        actionButtonContinue()
        authView.buttonContinue.isUserInteractionEnabled = false
        self.hideKeyboardWhenTappedAround() 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        authView.alertLabel.isHidden = true
        authView.alertMailLabel.isHidden = true
        authView.alertImage.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        authView.alertLabel.isHidden = true
        authView.alertMailLabel.isHidden = true
        authView.alertImage.isHidden = true
    }
    func actionButtonContinue() {
        authView.buttonContinue.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        authView.buttonSignIn.addTarget(self, action: #selector(actionSignIn), for: .touchUpInside)
        authView.appleLogInButton.button.addTarget(self, action: #selector(actionSocialNetwork), for: .touchUpInside)
        
        topPhoneConstraint = authView.buttonContinue.topAnchor.constraint(equalTo: authView.textFieldLogin.bottomAnchor, constant: 15)
        topPhoneConstraint.isActive = true
    }
    @objc func actionSignUp() {
        guard let text = authView.textFieldLogin.text else { return }
        let userPhoneOreMail = text.format(phoneNumber: text, shouldRemoveLastDigt: text.count == 1)
        let signUpVC = SignUpViewController()
        signUpVC.userPhoneOreEmail = userPhoneOreMail
        signUpVC.delegate = self
        self.present(signUpVC, animated: true, completion: nil)
    }
    @objc func actionSignIn() {
        weak var pvc = self.presentingViewController
        self.dismiss(animated: true, completion: {
            let signUpVC = SignInViewController()
            pvc?.present(signUpVC, animated: true, completion: nil)
        })
    }
    @objc func actionSocialNetwork() {
        self.avtorizete()
    }
    private func openProfileViewController() {
        if let tab = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController as? MainTabBarViewController {
            self.dismiss(animated: true)
           tab.boolStream = true
           NotificationCenter.default.post(Notification(name: .refreshAllTabs))
           tab.selectedIndex = 4
       }

//        let viewController = MainTabBarViewController()
//        viewController.selectedIndex = 4
//        let mySceneDelegate = (self.view.window?.windowScene)!
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.openRootViewController(viewController: viewController, windowScene: mySceneDelegate)
    }
    func avtorizete() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}
extension AuthViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
       
        if fullString == "" {
            authView.buttonContinue.backgroundColor = UIColor(red: 0.231, green: 0.345, blue: 0.643, alpha: 0.5)
            authView.buttonContinue.isUserInteractionEnabled = false
        } else if  fullString.isValidPhone() || fullString.isValidEmail() {
            authView.buttonContinue.backgroundColor = .blueColor
            authView.buttonContinue.isUserInteractionEnabled = true
        } else {
            authView.buttonContinue.backgroundColor = UIColor(red: 0.231, green: 0.345, blue: 0.643, alpha: 0.5)
            authView.buttonContinue.isUserInteractionEnabled = false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == authView.textFieldLogin {
            self.authView.textFieldLogin.resignFirstResponder()
       }
        return true
    }
    func firstLaunchApp() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        print("launch = \(launchedBefore)")
        if launchedBefore  {
            self.openProfileViewController()
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
             let vc = ChangeNameVC()
             vc.modalPresentationStyle = .fullScreen
             self.present(vc, animated: true, completion: nil)

        }
    }
}

extension AuthViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential:
            
            let token = credential.identityToken!
            let tokenStr = String(data: token, encoding: .utf8)!

            takeAppleSign = fitMeetApi.signWithApple(token: AppleAuthorizationRequest(id_token: tokenStr))
                .mapError({ (error) -> Error in
                            return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if let token = response.token?.token {
                        
                        UserDefaults.standard.set(token, forKey: Constants.accessTokenKeyUserDefaults)
                        UserDefaults.standard.set(response.user?.id, forKey: Constants.userID)
                        UserDefaults.standard.set(response.user?.fullName, forKey: Constants.userFullName)
                        
                    
                  }
            })
        default:
            break
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? UIWindow()
    }
}
extension AuthViewController: SignUpDelegate {
    
    func changeAlert() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            
            self.topPhoneConstraint.constant = 45
            self.authView.alertImage.isHidden = false
            self.authView.alertLabel.text = "This phone number is taken, please choose diffrent"
            self.authView.alertLabel.isHidden = false
            self.authView.alertImage.isHidden = true

        })
        self.view.layoutIfNeeded()
    transitionAnimator.startAnimation()
  
      
    }
    func changeMail() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            
            self.topPhoneConstraint.constant = 45
            self.authView.alertMailLabel.isHidden = false
            self.authView.alertImage.isHidden = false
            self.authView.alertLabel.isHidden = true

        })
        self.view.layoutIfNeeded()
    transitionAnimator.startAnimation()
     
    }
    func changePhone() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            
            self.topPhoneConstraint.constant = 45
            self.authView.alertImage.isHidden = false
            self.authView.alertLabel.text = "phone must be a valid phone number"
            self.authView.alertLabel.isHidden = false
            self.authView.alertImage.isHidden = true


        })
        self.view.layoutIfNeeded()
    transitionAnimator.startAnimation()
          
    }
}
