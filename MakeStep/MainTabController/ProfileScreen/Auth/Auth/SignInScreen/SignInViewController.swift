//
//  SignInViewController.swift
//  FitMeet
//
//  Created by novotorica on 15.04.2021.
//

import Foundation
import Foundation
import UIKit
import Combine
import ContextMenuSwift
import AuthenticationServices


class SignInViewController: UIViewController, SignInDelegate {
    
    func changeAlert() {
       
        if self.signUpView.buttonContinue.frame.origin.y == 219.0 {
         
         UIView.animate(withDuration: 0.5) {
           self.signUpView.buttonContinue.frame.origin.y += 15
           self.signUpView.labelAccount.frame.origin.y += 15
            self.signUpView.buttonSignUp.frame.origin.y += 15
         } completion: { (bool) in
             if bool {
                 self.signUpView.alertImage.isHidden = false
                 self.signUpView.alertLabel.isHidden = false
             }
         }
       }
    }
    
    func changeMail() {
        
        if self.signUpView.buttonContinue.frame.origin.y == 219.0 {
         
         UIView.animate(withDuration: 0.5) {
           self.signUpView.buttonContinue.frame.origin.y += 15
           self.signUpView.labelAccount.frame.origin.y += 15
            self.signUpView.buttonSignUp.frame.origin.y += 15
         } completion: { (bool) in
             if bool {
                 self.signUpView.alertImage.isHidden = false
                 self.signUpView.alertMailLabel.isHidden = false
             }
         }
       }
    }
    
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeAppleSign: AnyCancellable?
   
    let signUpView = SignInViewControllerCode()
    private var userSubscriber: AnyCancellable?
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
        signUpView.textFieldLogin.delegate = self
        signUpView.buttonContinue.isUserInteractionEnabled = false
        actionButtonContinue()
        self.hideKeyboardWhenTappedAround() 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        signUpView.alertLabel.isHidden = true
        signUpView.alertMailLabel.isHidden = true
        signUpView.alertImage.isHidden = true
        
    }
    func actionButtonContinue() {
        signUpView.buttonContinue.addTarget(self, action: #selector(actionContinue), for: .touchUpInside)
        signUpView.buttonSignUp.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        signUpView.buttonSocialNetwork.addTarget(self, action: #selector(actionSocialNetwork), for: .touchUpInside)
    }
    @objc func actionContinue() {
        let userPhoneOreMail = signUpView.textFieldLogin.text
        let signInVC = SignInPasswordViewController()
        signInVC.userPhoneOreEmail = userPhoneOreMail
        signInVC.delegate = self
        self.present(signInVC, animated: true, completion: nil)
    }
    @objc func actionSignUp() {
        self.dismiss(animated: true, completion: nil)
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
    @objc func actionSocialNetwork() {
     
      //  let FaceBookButton = ContextMenuItemWithImage(title: "Facebook", image: #imageLiteral(resourceName: "facebook"))
      //  let GoogleButton = ContextMenuItemWithImage(title: "Google", image: #imageLiteral(resourceName: "Google"))
      //  let TwitterButton = ContextMenuItemWithImage(title: "Twitter", image: #imageLiteral(resourceName: "Vector1-3"))
        let Applebutton = ContextMenuItemWithImage(title: "Sign in with Apple", image: #imageLiteral(resourceName: "Apple"))
        
        
        CM.items = [ Applebutton ]
        CM.MenuConstants.MenuWidth = self.signUpView.buttonSocialNetwork.frame.width
        CM.MenuConstants.HorizontalMarginSpace = 17
        CM.MenuConstants.LabelDefaultColor = UIColor(hexString: "#C4C4C4")
        CM.showMenu(viewTargeted: signUpView.buttonSocialNetwork, delegate: self,animated: true)
  
    }

}
extension SignInViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        let string = "formate"
        textField.text = string.format(phoneNumber: fullString, shouldRemoveLastDigt: range.length == 1)
        if fullString == "" {
            signUpView.buttonContinue.backgroundColor = UIColor(red: 0.231, green: 0.345, blue: 0.643, alpha: 0.5)
            signUpView.buttonContinue.isUserInteractionEnabled = false
        } else if  fullString.isValidPhone() || fullString.isValidEmail() {
            signUpView.buttonContinue.backgroundColor = UIColor(hexString: "#3B58A4")
            signUpView.buttonContinue.isUserInteractionEnabled = true
        } else {
            signUpView.buttonContinue.backgroundColor = UIColor(red: 0.231, green: 0.345, blue: 0.643, alpha: 0.5)
            signUpView.buttonContinue.isUserInteractionEnabled = false
        }

        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == signUpView.textFieldLogin {
            self.signUpView.textFieldLogin.resignFirstResponder()
        }
        return true
    }
}
extension SignInViewController : ContextMenuDelegate {
    func contextMenuDidSelect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
       
        if index == 0 {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
            return false
        }
        if index == 1 {
            print("Facebook")
            return false
        }
        if index == 2 {
            print("Google")
            return false
        }
        if index == 3 {
            print("Twitter")
            return false
        }
        return false
       
    }
    
    func contextMenuDidDeselect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) {
        if index == 0 {

            self.avtorizete()


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
extension SignInViewController: ASAuthorizationControllerDelegate {
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

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? UIWindow()
    }
}
