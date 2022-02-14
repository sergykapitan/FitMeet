//
//  AppDelegate.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit
import AVFoundation
import Logboard
import UserNotifications

let logger = Logboard.with("FitMeet.iOS")

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate {


    override init() {
        super.init()
        let appDependencies = Dependencies{
            Module { FitMeetApi() }
            Module { FitMeetStream() }
            Module { FitMeetChannels() }
            Module { MakeStepChat() }
        }
        appDependencies.build()      
    }
    
    /// Set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.all
    let actionChatTransitionManager = ActionTransishionChatManadger()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Purchases.default.initialize()
        // Initialise the Audio Session, you should do this in your AppDelegate.swift
        let session = AVAudioSession.sharedInstance()
        do {
            // https://stackoverflow.com/questions/51010390/avaudiosession-setcategory-swift-4-2-ios-12-play-sound-on-silent
            if #available(iOS 10.0, *) {
                try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            } else {
                session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord, with: [
                    AVAudioSession.CategoryOptions.allowBluetooth,
                    AVAudioSession.CategoryOptions.defaultToSpeaker
                ])
                try session.setMode(.default)
            }
            try session.setActive(true)
        } catch {
            logger.error(error)
        }
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        IAPManager.shared.setupPurchases { success in
            if success {
                print("can make payments")
                IAPManager.shared.getProducts()
            }
        }
        registerForPushNotifications()
        return true
    }
    

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let vcIndex = tabBarController.viewControllers!.firstIndex(of: viewController)!
        let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
           if  vcIndex == 2 {
               if token != nil {
               let chatVC = SendStream()
               let curvaView = tabBarController.selectedViewController!
               chatVC.transitioningDelegate = actionChatTransitionManager
               chatVC.modalPresentationStyle = .custom
               actionChatTransitionManager.intWidth = 1
               actionChatTransitionManager.intHeight = 0.2
               curvaView.present(chatVC, animated: true, completion: nil)

               return false
               } else {
                   return true
               }
           } else {
               return true
           }
       }

  

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    func registerForPushNotifications() {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
        (granted, error) in
        print("Permission granted: \(granted)")
          guard granted else { return }
          self.getNotificationSettings()
      }
    }
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { (settings) in
        print("Notification settings: \(settings)")
          guard settings.authorizationStatus == .authorized else { return }
          DispatchQueue.main.async {              
              UIApplication.shared.registerForRemoteNotifications()
          }
          
      }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let tokenParts = deviceToken.map { data -> String in
        return String(format: "%02.2hhx", data)
      }
      
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
  
}

