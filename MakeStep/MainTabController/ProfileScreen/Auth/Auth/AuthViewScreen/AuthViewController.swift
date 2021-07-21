//
//  ViewController.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit
import ContextMenuSwift
import AuthenticationServices
import Combine

class AuthViewController: UIViewController {
    
    let authView = AuthViewControllerCode()
    private let signInButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
    private var takeAppleSign: AnyCancellable?
    @Inject var fitMeetApi: FitMeetApi
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // CM.closeAllViews()
    }
    func actionButtonContinue() {
        authView.buttonContinue.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        authView.buttonSignIn.addTarget(self, action: #selector(actionSignIn), for: .touchUpInside)
        authView.buttonSocialNetwork.addTarget(self, action: #selector(actionSocialNetwork), for: .touchUpInside)
    }
    @objc func actionSignUp() {
        let userPhoneOreMail = authView.textFieldLogin.text
        let signUpVC = SignUpViewController()
        signUpVC.userPhoneOreEmail = userPhoneOreMail
        self.present(signUpVC, animated: true, completion: nil)
    }
    @objc func actionSignIn() {
        let signUpVC = SignInViewController()
        self.present(signUpVC, animated: true, completion: nil)
    }
    @objc func actionSocialNetwork() {
       // authView.buttonSocialNetwork.isHidden = false
       // let share = ContextMenuItemWithImage(title: "Share", image: #imageLiteral(resourceName: "Settings"))
       // let edit = "Edit"
       // let delete = ContextMenuItemWithImage(title: "Delete", image: #imageLiteral(resourceName: "Settings"))
        let button = ContextMenuItemWithImage(title: "Apple", image: #imageLiteral(resourceName: "Settings"))
        
        
        CM.items = [ button ]
        CM.showMenu(viewTargeted: authView.buttonSocialNetwork, delegate: self,animated: true)
  
    }

    private func openProfileViewController() {
        let viewController = MainTabBarViewController()
        viewController.selectedIndex = 4
        let mySceneDelegate = (self.view.window?.windowScene)!
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.openRootViewController(viewController: viewController, windowScene: mySceneDelegate)
    }
    func avtorizete() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
       // CM.closeAllViews()
    }

}
extension AuthViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        let string = "formate"
        textField.text = string.format(phoneNumber: fullString, shouldRemoveLastDigt: range.length == 1)
        if fullString == "" {
            authView.buttonContinue.backgroundColor = UIColor(red: 0.231, green: 0.345, blue: 0.643, alpha: 0.5)
            authView.buttonContinue.isUserInteractionEnabled = false
        } else if  fullString.isValidPhone() || fullString.isValidEmail() {
            authView.buttonContinue.backgroundColor = UIColor(hexString: "#3B58A4")
            authView.buttonContinue.isUserInteractionEnabled = true
        } else {
            authView.buttonContinue.backgroundColor = UIColor(red: 0.231, green: 0.345, blue: 0.643, alpha: 0.5)
            authView.buttonContinue.isUserInteractionEnabled = false
        }

        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == authView.textFieldLogin {
            self.authView.textFieldLogin.resignFirstResponder()
        }
        return true
    }  
}
extension AuthViewController : ContextMenuDelegate {
    func contextMenuDidSelect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
       
//        if index == 0 {
//            //CM.onViewDismiss!(targetedView)
//            let request = ASAuthorizationAppleIDProvider().createRequest()
//            request.requestedScopes = [.fullName, .email]
//
//            let controller = ASAuthorizationController(authorizationRequests: [request])
//            controller.delegate = self
//            controller.presentationContextProvider = self
//            controller.performRequests()
//           // CM.closeAllViews()
//            return false
//        }
        return false
       
    }
    
    func contextMenuDidDeselect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) {
        if index == 0 {
           // CM.closeAllViews()
          //  contextMenu.closeAllViews()
            self.avtorizete()
//            let request = ASAuthorizationAppleIDProvider().createRequest()
//            request.requestedScopes = [.fullName, .email]
//
//            let controller = ASAuthorizationController(authorizationRequests: [request])
//            controller.delegate = self
//            controller.presentationContextProvider = self
//            controller.performRequests()

        }
    }
    
    func contextMenuDidAppear(_ contextMenu: ContextMenu) {
        print("contextMenuDidAppear")
    }
    
    func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
        print("contextMenuDidDisappear")
       // CM.closeAllViews()
    }
    
    
    
    
}
extension AuthViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential:
            
            let token = credential.identityToken!
            let tokenStr = String(data: token, encoding: .utf8)!
            
            print("Token == \(tokenStr)")
            takeAppleSign = fitMeetApi.signWithApple(token: AppleAuthorizationRequest(id_token: tokenStr))
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
            
            let code = credential.authorizationCode!
            let codeStr = String(data: code, encoding: .utf8)
            print("User Code: ", codeStr)
            let userId = credential.user
            print("User Identifier: ", userId)
        
            if let fullname = credential.fullName {
                print(fullname)
            }
            
            if let email = credential.email {
                print("Email: ", email)
            }
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
