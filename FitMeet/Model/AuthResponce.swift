//
//  AuthResponce.swift
//  FitMeet
//
//  Created by novotorica on 14.04.2021.
//

import Foundation

// MARK: - AuthResponce
struct AuthResponce : Codable{
    let user: User
    let token: Token
}

// MARK: - Token
struct Token: Codable {
    let expiresIn: Int
    let token: String
}

// MARK: - User
struct User: Codable {
    let id: Int
    let deleted, fullName, username: String
    let gender: Gender
    let status: Status
    let email, phone, avatarPath: String
    let phoneVerify: Bool
    let createdAt, birthDate, nameLastUpdateDate, usernameLastUpdateDate: String
    let birthDateUpdateDate: String
}

// MARK: - Gender
struct Gender: Codable{
    let male, female, undefined: String
}

// MARK: - Status
struct Status: Codable {
    let banned, active: String
}
