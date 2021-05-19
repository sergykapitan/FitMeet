//
//  AppleAuthorizationRequest.swift
//  FitMeet
//
//  Created by novotorica on 18.05.2021.
//

import Foundation
/// Entity for native Sign In With Apple authorization (iOS 13.0 and newer)
struct AppleAuthorizationRequest: Codable {
    ///User's first name
   // let firstName : String?
    ///User's surname
   // let lastName: String?
    ///Apple Sign In Token
    let id_token: String
}
