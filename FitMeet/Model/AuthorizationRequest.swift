//
//  AuthorizationRequest.swift
//  FitMeet
//
//  Created by novotorica on 14.04.2021.
//

import Foundation
import Foundation

struct AuthorizationRequest: Codable {
    
    let fullName: String
    let username: String
    let email: String
    let phone: String
    let password: String
}
