//
//  NotInternetView.swift
//  MakeStep
//
//  Created by Sergey on 18.04.2022.
//
import UIKit

protocol ReloadView: class {
    func reloadView()
}

class NotInternetView: UIViewController {

    let notView = NotInternetViewCode()
    weak var delegate: ReloadView?
    
    override func loadView() {
        super.loadView()
        view = notView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        actionButton()
    }
    func actionButton(){
        notView.butTryAgain.addTarget(self, action: #selector(actionBtn), for: .touchUpInside)
    }
    @objc func actionBtn() {
        if Connectivity.isConnectedToInternet {
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true) {
                self.delegate?.reloadView()
            }
        } else {
             return
        }
    }
}

