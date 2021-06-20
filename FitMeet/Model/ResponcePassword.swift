//
//  ResponcePassword.swift
//  FitMeet
//
//  Created by novotorica on 27.04.2021.
//

import Foundation


// MARK: - ResponcePassword
struct ResponcePassword: Codable {
    let user: Users?
    let token: Tokens?
    let statusCode: Int?
    let message, error: String?
}


 //MARK: - User
struct Users: Codable {
    let id: Int?
    let deleted: String?
    let avatarPath: String?
    let fullName, username, gender, status: String?
    let email, phone: String?
    let phoneVerify: Bool?
    let createdAt: String?
    let birthDate, nameLastUpdateDate, usernameLastUpdateDate: String?
    let channelSubscribeCount: Int?
}
// MARK: - Token
struct Tokens: Codable {
    let expiresIn: Int?
    let token: String?
}
