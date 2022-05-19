//
//  VideoDeeplinkHandler.swift
//  MakeStep
//
//  Created by Sergey on 19.02.2022.
//


import Foundation
import UIKit

final class VideoDeeplinkHandler: DeeplinkHandlerProtocol {
    
    private weak var rootViewController: UIViewController?
    init(rootViewController: UIViewController?) {
        self.rootViewController = rootViewController
    }
    
    // MARK: - DeeplinkHandlerProtocol
    
    func canOpenURL(_ url: URL) -> Bool {
        return url.absoluteString.hasPrefix("makestepqa://videos")
    }
    func openURL(_ url: URL) {
        guard canOpenURL(url) else {
            return
        }
        openProfileViewController()

    }
    func openProfileViewController() {
        let mainVC = MainTabBarViewController()
        mainVC.selectedIndex = 0
        let home = mainVC.viewControllers?[0]
        print("VC = \(mainVC.viewControllers?[0].navigationController)")
       
        
        mainVC.modalPresentationStyle = .fullScreen
       // home?.navigationController?.pushViewController(PresentVC(), animated: true)
        rootViewController?.present(mainVC, animated: true, completion: {
          //  home?.navigationController?.pushViewController(PresentVC(), animated: true)
            
        })
    }
}
