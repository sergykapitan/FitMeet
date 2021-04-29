//
//  UserSetting.swift
//  FitMeet
//
//  Created by novotorica on 29.04.2021.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: Constants.broadcastID)
        }
    }
    
    init() {
        self.username = UserDefaults.standard.object(forKey: Constants.broadcastID) as? String ?? ""
    }
}
