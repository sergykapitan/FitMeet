//
//  AccountDeeplinkHandler.swift
//  MakeStep
//
//  Created by Sergey on 19.02.2022.
//

import Foundation
import UIKit

final class AccountDeeplinkHandler: DeeplinkHandlerProtocol {
    
    private weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController?) {
        self.rootViewController = rootViewController
    }
    
    // MARK: - DeeplinkHandlerProtocol
    
    func canOpenURL(_ url: URL) -> Bool {
        return url.absoluteString == "makestepqa://account"
    }
    
    func openURL(_ url: URL) {
        guard canOpenURL(url) else {
            return
        }
        openProfileViewController()
    }
    func openProfileViewController() {
        let mainVC = MainTabBarViewController()
        mainVC.selectedIndex = 4
        mainVC.modalPresentationStyle = .fullScreen
        rootViewController?.present(mainVC, animated: true, completion: nil)
    }
    
}
