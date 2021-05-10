//
//  AuthorizationRequest.swift
//  FitMeet
//
//  Created by novotorica on 14.04.2021.
//

import Foundation

struct AuthorizationRequest: Codable  {
    
    let fullName: String
    let username: String
    var email: String?
    var phone: String?
    let password: String
}

