//
//  ResetOldPassword.swift
//  MakeStep
//
//  Created by novotorica on 09.09.2021.
//

import Foundation

struct ResetOldPassword: Codable {
    let password: String
    let phone: String
    let hash: String
}
